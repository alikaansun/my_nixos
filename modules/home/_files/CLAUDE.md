# Global instructions (all projects)

## Obsidian notes

Whenever I ask you to do something with my notes (read, write, edit, search, ingest, save, query my Obsidian vault), use the `claude-obsidian:*` skills rather than ad-hoc filesystem operations. Invoke the relevant skill first — e.g. `wiki-cli` for read/write/search transport, `wiki-ingest` for ingesting sources, `save` for saving conversations, `wiki-query` for questions.

Do not hardcode or assume the vault path. Let the skill discover the active vault and transport (e.g. via `wiki-cli` transport detection / Obsidian's own vault registry) at the time of the request, since paths and the active vault can change.

## Ponytail (over-engineering antidote)

Use the main `ponytail` skill automatically for all relevant coding tasks (writing, adding, refactoring, fixing, reviewing, or designing code, and choosing libraries/dependencies) — default to the laziest solution that actually works.

For the other ponytail skills (`ponytail-review`, `ponytail-audit`, `ponytail-debt`, `ponytail-gain`, `ponytail-help`), ask me before using them.
