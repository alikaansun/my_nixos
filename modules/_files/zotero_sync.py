#!/usr/bin/env python3
"""Convert Zotero PDF attachments to markdown and index the library in Obsidian.

Writes three things:
  <storage>/<KEY>/<KEY>.md              full text of the PDF, with metadata frontmatter
  <storage>/<KEY>/<KEY>_md_assets/      figures extracted from the PDF
  <vault>/Zotero/notes/<citekey>.md     one stub note per item, for Bases and ripgrep

Re-runnable: a PDF is converted only when its .md is missing or older, and a stub's
body is never touched once created -- only its frontmatter is refreshed.
"""

import argparse
import getpass
import os
import re
import sqlite3
import sys
from pathlib import Path

# ponytail: /usr/bin/python3 (3.9, no deps) shadows the nix env in $PATH, so a bare
# `python3 zotero_sync.py` lands on the wrong interpreter. Re-exec under the nix one.
try:
    import pymupdf
    import pymupdf4llm
    import yaml
except ImportError:
    _nixpy = f"/etc/profiles/per-user/{getpass.getuser()}/bin/python3"
    if os.path.exists(_nixpy) and not os.environ.get("_ZOTERO_SYNC_REEXEC"):
        os.environ["_ZOTERO_SYNC_REEXEC"] = "1"
        os.execv(_nixpy, [_nixpy, os.path.abspath(__file__), *sys.argv[1:]])
    sys.exit("pymupdf4llm/pyyaml missing: run `drs` to build the python env, or use `zotero-md-sync`")

# 150 dpi was checked against real S-parameter plots: axis ticks and legends stay
# legible even on a 400px-wide sub-panel, and Claude's vision downsamples above
# ~1568px anyway, so a higher setting costs disk and Nextcloud bandwidth for nothing.
DPI = 150
# Fraction of the page below which an image is a fragment, not a figure. Measured:
# 0.20 started dropping real panels, 0.05 kept every equation snippet and logo.
IMAGE_SIZE_LIMIT = 0.15
# Books and theses carry most of the figure payload (in a 20-pdf sample the three
# longest documents were 89% of it) and are not what you search for a given plot.
# Past this many pages, extract text only. Library median is 8 pages; this hits ~8%.
MAX_FIGURE_PAGES = 50
# Below this many characters the extraction is assumed to have failed (scanned page).
MIN_CHARS = 500


def load_library(db_path):
    """Return (items_by_id, attachments) read from a live Zotero database."""
    con = sqlite3.connect(f"file:{db_path}?immutable=1", uri=True)
    q = lambda sql: con.execute(sql).fetchall()

    field = {name: fid for fid, name in q("SELECT fieldID, fieldName FROM fields")}
    wanted = {
        field[n]: n
        for n in ("title", "abstractNote", "date", "DOI", "url", "citationKey")
        if n in field
    }

    items = {}
    for iid, key, tname in q(
        "SELECT i.itemID, i.key, t.typeName FROM items i"
        " JOIN itemTypes t USING(itemTypeID)"
        " WHERE t.typeName NOT IN ('attachment','note','annotation')"
        "   AND i.itemID NOT IN (SELECT itemID FROM deletedItems)"
    ):
        items[iid] = {"key": key, "type": tname, "creators": [], "collections": [], "tags": []}

    for iid, fid, val in q(
        "SELECT d.itemID, d.fieldID, v.value FROM itemData d"
        " JOIN itemDataValues v USING(valueID)"
    ):
        if iid in items and fid in wanted:
            items[iid][wanted[fid]] = val

    for iid, ctype, first, last, mode in q(
        "SELECT ic.itemID, ct.creatorType, c.firstName, c.lastName, c.fieldMode"
        " FROM itemCreators ic JOIN creators c USING(creatorID)"
        " JOIN creatorTypes ct USING(creatorTypeID) ORDER BY ic.orderIndex"
    ):
        if iid in items:
            name = last if mode == 1 or not first else f"{first} {last}"
            items[iid]["creators"].append((ctype, name))

    # Collection names are not unique (ECIO26 exists twice), so build full paths.
    for iid, path in q(
        "WITH RECURSIVE p(collectionID, path) AS ("
        "  SELECT collectionID, collectionName FROM collections WHERE parentCollectionID IS NULL"
        "  UNION ALL"
        "  SELECT c.collectionID, p.path || '/' || c.collectionName"
        "    FROM collections c JOIN p ON c.parentCollectionID = p.collectionID)"
        " SELECT ci.itemID, p.path FROM collectionItems ci JOIN p USING(collectionID)"
    ):
        if iid in items:
            items[iid]["collections"].append(path)

    for iid, tag in q("SELECT it.itemID, t.name FROM itemTags it JOIN tags t USING(tagID)"):
        if iid in items:
            items[iid]["tags"].append(tag)

    attachments = [
        (akey, parent, fname.replace("storage:", "", 1))
        for akey, parent, fname in q(
            "SELECT ai.key, a.parentItemID, a.path FROM itemAttachments a"
            " JOIN items ai ON ai.itemID = a.itemID"
            " WHERE a.linkMode IN (0,1) AND a.contentType = 'application/pdf'"
            "   AND a.path LIKE 'storage:%'"
            "   AND ai.itemID NOT IN (SELECT itemID FROM deletedItems)"
        )
    ]
    con.close()
    return items, attachments


def meta(item):
    """Flatten a raw item row into the frontmatter we publish."""
    authors = [n for t, n in item["creators"] if t == "author"] or [
        n for _, n in item["creators"]
    ]
    year = re.search(r"\d{4}", item.get("date", "") or "")
    return {
        "title": item.get("title", "(untitled)"),
        "authors": authors,
        "year": int(year.group()) if year else None,
        "type": item["type"],
        "doi": item.get("DOI") or None,
        "citekey": item.get("citationKey") or None,
        "zotero_key": item["key"],
        "zotero_uri": f"zotero://select/library/items/{item['key']}",
        "collections": sorted(set(item["collections"])),
        "tags": sorted(set(item["tags"])),
    }


def frontmatter(d):
    clean = {k: v for k, v in d.items() if v not in (None, [], "")}
    return "---\n" + yaml.safe_dump(clean, allow_unicode=True, sort_keys=False) + "---\n"


def body_of(text):
    """Everything after the frontmatter fence, so hand-written notes survive a refresh."""
    if text.startswith("---\n"):
        end = text.find("\n---\n", 3)
        if end != -1:
            return text[end + 5 :]
    return text


def find_pdf(folder, filename):
    exact = folder / filename
    if exact.is_file():
        return exact
    hits = sorted(p for p in folder.glob("*") if p.suffix.lower() == ".pdf")
    return hits[0] if hits else None


def convert(pdf, key, folder, fm, dry):
    """Extract text+figures. Returns 'ok', 'skip' or 'fail'."""
    out = folder / f"{key}.md"
    if out.exists() and out.stat().st_mtime >= pdf.stat().st_mtime:
        return "skip"
    if dry:
        print(f"  would convert {key}  ({pdf.name})")
        return "ok"

    assets = folder / f"{key}_md_assets"
    assets.mkdir(exist_ok=True)
    try:
        with pymupdf.open(pdf) as doc:
            figures = doc.page_count <= MAX_FIGURE_PAGES
            text = pymupdf4llm.to_markdown(
                doc,
                filename=key,  # names figures <KEY>-<page>-<n>.png instead of the pdf title
                write_images=figures,
                ignore_images=not figures,
                ignore_graphics=not figures,
                image_path=str(assets),
                image_size_limit=IMAGE_SIZE_LIMIT,
                dpi=DPI,
                graphics_limit=5000,
            )
    except Exception as exc:  # one bad PDF must not abort the run
        print(f"  FAIL {key}: {exc}", file=sys.stderr)
        return "fail"

    source = "pymupdf4llm"
    if len(text.strip()) < MIN_CHARS:
        cache = folder / ".zotero-ft-cache"
        if cache.exists() and cache.stat().st_size > len(text):
            text = cache.read_text(errors="replace")
            source = "ft-cache"
    if not text.strip():
        print(f"  EMPTY {key}: no extractable text (scanned? needs OCR)", file=sys.stderr)
        return "fail"

    # Keep figure links relative so they survive syncing to another machine.
    text = text.replace(str(assets) + "/", f"{key}_md_assets/").replace(
        str(assets), f"{key}_md_assets"
    )
    if not any(assets.iterdir()):
        assets.rmdir()

    extra = {"source": source}
    if not figures:
        extra["figures"] = "skipped (long document)"
    out.write_text(frontmatter({**fm, **extra}) + "\n" + text)
    return "ok"


def stub_name(fm, used):
    raw = fm["citekey"] or fm["zotero_key"]
    name = re.sub(r"[^\w.-]", "_", raw)
    if name in used:
        name = f"{name}-{fm['zotero_key']}"
    used.add(name)
    return name


def self_test():
    """body_of() guards hand-written notes, so it gets the one check in here."""
    assert body_of("no frontmatter here") == "no frontmatter here"
    assert body_of("---\ntitle: x\n---\nbody\n") == "body\n"
    assert body_of("---\ntitle: x\n---\n") == ""
    # a --- inside the body is a horizontal rule, not a fence
    assert body_of("---\ntitle: x\n---\nintro\n\n---\n\nmore\n") == "intro\n\n---\n\nmore\n"
    # a title that itself contains --- must not be mistaken for the closing fence
    fm = frontmatter({"title": "a\n---\nb", "zotero_key": "K"})
    assert body_of(fm + "kept") == "kept", body_of(fm + "kept")
    # round trip: refreshing frontmatter leaves the body byte-identical
    body = "\n> [!note]- 🤖 Abstract\n> text\n\nmy own notes\n"
    assert body_of(frontmatter({"title": "t"}) + body) == body
    print("self-test ok")


def main():
    ap = argparse.ArgumentParser(description=__doc__)
    ap.add_argument("--zotero", type=Path)
    ap.add_argument("--vault", type=Path)
    ap.add_argument("--dry-run", action="store_true")
    ap.add_argument("--limit", type=int, help="convert at most N PDFs (for testing)")
    ap.add_argument("--self-test", action="store_true")
    args = ap.parse_args()

    if args.self_test:
        return self_test()

    if not args.zotero or not args.vault:
        ap.error("--zotero and --vault are required")
    storage = args.zotero / "storage"
    notes = args.vault / "Zotero" / "notes"
    db = args.zotero / "zotero.sqlite"
    if not db.exists():
        sys.exit(f"no zotero.sqlite at {db}")

    items, attachments = load_library(db)
    print(f"{len(items)} items, {len(attachments)} pdf attachments")

    # --- convert PDFs -------------------------------------------------------
    tally = {"ok": 0, "skip": 0, "fail": 0, "unattempted": 0}
    fulltext = {}
    for akey, parent, filename in attachments:
        folder = storage / akey
        if parent not in items or not folder.is_dir():
            continue
        pdf = find_pdf(folder, filename)
        if pdf is None:
            continue
        fm = meta(items[parent])
        if args.limit and tally["ok"] >= args.limit:
            tally["unattempted"] += 1
            if (folder / f"{akey}.md").exists():
                fulltext[parent] = (folder / f"{akey}.md", pdf)
            continue
        result = convert(pdf, akey, folder, fm, args.dry_run)
        tally[result] += 1
        if result != "fail":
            fulltext[parent] = (folder / f"{akey}.md", pdf)
    summary = f"converted {tally['ok']}, up-to-date {tally['skip']}, failed {tally['fail']}"
    if tally["unattempted"]:
        summary += f", not attempted (--limit) {tally['unattempted']}"
    print(summary)

    # --- write vault stubs --------------------------------------------------
    created = refreshed = 0
    used = set()
    if not args.dry_run:
        notes.mkdir(parents=True, exist_ok=True)
    for iid, item in sorted(items.items(), key=lambda kv: kv[1]["key"]):
        fm = meta(item)
        if iid in fulltext:
            md, pdf = fulltext[iid]
            fm["fulltext"] = str(md)
            fm["pdf"] = str(pdf)
        path = notes / f"{stub_name(fm, used)}.md"
        abstract = item.get("abstractNote")
        if path.exists():
            body = body_of(path.read_text())
            refreshed += 1
        else:
            body = "\n"
            if abstract:
                quoted = "\n".join(f"> {ln}" for ln in abstract.splitlines())
                body = f"\n> [!note]- 🤖 Abstract\n{quoted}\n\n"
            created += 1
        if not args.dry_run:
            path.write_text(frontmatter(fm) + body)
    print(f"stubs: {created} created, {refreshed} refreshed  ->  {notes}")

    if notes.is_dir():
        orphans = [p.stem for p in notes.glob("*.md") if p.stem not in used]
        if orphans:
            print(f"{len(orphans)} stub(s) no longer in Zotero (left alone): {', '.join(orphans[:10])}")


if __name__ == "__main__":
    main()
