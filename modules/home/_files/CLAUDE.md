# Global instructions (all projects)

## Repositories

My git repositories live under `~/Documents/Repos`. When I refer to a repo by name (e.g. "Imodulator"), look for it there.

## Claude config & memory location

My Claude config and memory files (including this global CLAUDE.md) are managed in my dotfiles flake at `~/.dotfiles` (e.g. `~/.dotfiles/modules/home/_files/CLAUDE.md`), symlinked into `~/.claude`. To persist global changes, edit the real files under `~/.dotfiles`, not the symlinks.

## Obsidian notes

Whenever I ask you to do something with my notes (read, write, edit, search, ingest, save, query my Obsidian vault), use `obsidian-cli` (which is installed) rather than ad-hoc filesystem operations or any Obsidian plugin/MCP.

Default to the **ObsNotes** vault and do not edit without asking. 

# Ponytail (over-engineering antidote)

Use the main `ponytail` skill automatically for all relevant coding tasks (writing, adding, refactoring, fixing, reviewing, or designing code, and choosing libraries/dependencies) — default to the laziest solution that actually works.

For the other ponytail skills (`ponytail-review`, `ponytail-audit`, `ponytail-debt`, `ponytail-gain`, `ponytail-help`), ask me before using them.
