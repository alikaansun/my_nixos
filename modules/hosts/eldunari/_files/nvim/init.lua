-- Windows port of modules/home/nvim.nix.
--
-- nvf only runs under Nix, so this rebuilds the same editor by hand with
-- lazy.nvim: same plugins, options and keymaps (including the ones nvf adds by
-- default, e.g. <leader>l* for LSP and <leader>f* for Telescope), trimmed to
-- Python. When nvim.nix changes, mirror the change here.
--
-- Linked to %LOCALAPPDATA%\nvim; see README.md next to this file.

vim.g.mapleader = " "
vim.g.maplocalleader = " "

require("config.options")
require("config.autocmds")
require("config.keymaps")
require("config.lazy")
