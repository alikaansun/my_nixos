# Neovim on Windows

A hand-written Lua port of `modules/home/nvim.nix`. nvf only runs under Nix, so
this rebuilds the same editor with lazy.nvim: the same plugins, options and
keymaps, including the ones nvf adds by default (`<leader>l*` LSP,
`<leader>f*` Telescope, `<leader>h*` gitsigns, `<leader>gg` lazygit), cut down
to Python. When `nvim.nix` changes, mirror the change here.

It lives under `_files/`, so import-tree never loads it into the flake.

## Setup on a fresh machine

```powershell
scoop install neovim ripgrep fd tree-sitter mingw lazygit
uv tool install basedpyright
uv tool install ruff
New-Item -ItemType Junction -Path "$env:LOCALAPPDATA\nvim" `
  -Target "$HOME\.dotfiles\modules\hosts\eldunari\_files\nvim"
```

Open a **new** terminal (mingw adds `gcc` to PATH), then run `nvim`.
lazy.nvim installs the plugins pinned in `lazy-lock.json`, and
nvim-treesitter compiles the parsers listed in `lua/plugins/treesitter.lua`.
The terminal font must be a Nerd Font (FiraCode Nerd Font here).

## Differences from the Mac

| Mac (nvf) | Here | Why |
| --- | --- | --- |
| snacks.image | off | needs the kitty graphics protocol; Windows Terminal lacks it |
| jupynvim | dropped | Rust core uses Unix-only APIs; plots need kitty graphics |
| nix, bash, clang, tex, typst LSPs | dropped | Python only |
| claudecode.nvim, nextnano.nvim (+ cmp-omni) | dropped | not needed on this PC |
| hunk.nvim (from `git.enable`) | dropped | jj diff editor |
| basedpyright uses the shell's python | uses `<root>/.venv/Scripts/python.exe` | PATH python is the Microsoft Store stub |
| `extraPaths` under `~/Documents/Repos` | `D:/Repos/...` | checkout location |
| `vimgrep` ignore patterns `x/` | `x[/\\]` | Windows paths use `\` |
| toggleterm uses zsh | `pwsh -NoLogo` | only the terminal; `'shell'` stays cmd.exe |

## Gotchas

- **Treesitter compiler.** The tree-sitter CLI defaults to MSVC `cl.exe`;
  `lua/plugins/treesitter.lua` sets `CC=gcc` inside Neovim. `zig cc` does not
  work: the CLI passes it an MSVC target triple that zig rejects.
- **Stale tree-sitter locks.** If a parser build is killed midway, later builds
  fail with "Lock file ... appears stale". Delete the named file under
  `%LOCALAPPDATA%\tree-sitter\lock\` and run `:TSUpdate`.
- **`<A-Up>`/`<A-Down>` (move line).** Windows Terminal binds Alt+arrows to
  pane focus. With a single pane they reach Neovim; if you split panes in
  Windows Terminal, unbind `moveFocus` in its settings.
