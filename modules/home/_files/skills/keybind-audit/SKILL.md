---
name: keybind-audit
description: >
  Audit keyboard shortcuts across the user's layered tools (aerospace/hyprland
  window manager, ghostty terminal, herdr multiplexer) and report real
  conflicts, not just overlaps. Use when the user asks to "check keybind
  conflicts/overlaps", "any keybind clashes?", "audit my shortcuts", or similar
  — AND automatically, right after you change any keybind in a config this
  session (herdr/ghostty/aerospace/hyprland), to confirm the new bind doesn't
  collide with an existing one.
---

# Keybind Audit

Reports keybind **conflicts** across the layered input stack. It pulls each
tool's *effective* binds live (defaults + user overrides already merged), so it
never drifts from the real config. There are **no hardcoded keybind lists** to
maintain.

## The layer model (why an overlap isn't always a conflict)

Keys are intercepted top-down. A higher layer *shadows* a lower one:

```
Window manager (aerospace on macOS / hyprland on Linux)   ← global, wins first
  └─ ghostty (terminal emulator)                          ← wins before TUI apps
       └─ herdr (multiplexer, runs inside ghostty)        ← prefix-mode
```

- A chord claimed by only one layer → **fine**.
- A chord claimed by two layers → the **higher layer wins** and swallows the
  key; the lower layer never sees it → **CONFLICT**.
- **herdr nuance:** `prefix+X` bindings are internal — you press the prefix
  first, so `X` never competes globally. Only herdr's **prefix chord itself**
  (and any *direct*, non-`prefix+` herdr bind like `ctrl+1..9`) competes with
  the WM/terminal. So `prefix+shift+j` can never clash with anything above it;
  `ctrl+space` (the prefix) and `ctrl+1..9` can.

## Procedure

1. **Detect platform.** `uname` → `Darwin` = aerospace stack, `Linux` =
   hyprland stack. Only audit the layers present.

2. **Dump effective binds per layer:**

   | Layer | Command | Notes |
   |---|---|---|
   | ghostty | `ghostty +list-keybinds` | `super` == `cmd` on macOS |
   | aerospace (macOS) | `aerospace list-modes`, then `aerospace config --get mode.<mode>.binding --json` for each mode | `main` mode holds the global binds |
   | hyprland (Linux) | `hyprctl binds` | runtime dump of all active binds |
   | herdr | merge `herdr --default-config` (defaults) with `~/.config/herdr/config.toml` (overrides — an override *replaces* the default for that action) | no single effective-dump command |

3. **Normalize every chord** to a canonical form before comparing:
   - Modifiers: `cmd` = `super` = `win` = `⌘`; `opt` = `alt` = `⌥`;
     `control` = `ctrl`. Separators: `-` (aerospace) and `+` and hyprland's
     `SUPER, Q` all collapse to `mod+mod+key`, modifiers sorted alphabetically,
     key lowercased.
   - Expand ranges: `ctrl+1..9` → `ctrl+1 … ctrl+9`.

4. **Classify herdr binds:** split into `prefix` chord + *direct* binds (no
   `prefix+`) which compete globally, vs `prefix+X` binds which are internal
   (ignore for cross-layer comparison — but still flag herdr-internal
   duplicates, two actions on the same `prefix+X`).

5. **Find collisions.** For each canonical chord claimed by ≥2 competing layers,
   emit a `CONFLICT` naming both actions and the **winning** (higher) layer.
   The rest are fine.

## Output format

```
Keybind audit — <platform>, layers: <wm> · ghostty · herdr

CONFLICT  cmd+space
  aerospace (main): exec open Brave      ← WINS (window manager)
  ghostty:          <action>             ← shadowed, never fires in the terminal

CONFLICT  ctrl+space   ← herdr prefix
  aerospace: <action>                    ← WINS, herdr prefix would be dead

herdr-internal duplicate  prefix+n
  next_tab  /  <other action>

No other conflicts. (herdr prefix+X binds are internal and were not compared.)
```

If there are zero conflicts, say so plainly and list how many binds were checked
per layer.

## Scope

In scope: aerospace, hyprland, ghostty, herdr. Out of scope for now (add later
if asked): nvim, zed, kanata (input remap), KDE/plasma.
