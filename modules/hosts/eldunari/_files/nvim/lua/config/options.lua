local o = vim.opt

-- nvf defaults (nvf: modules/neovim/init/basic.nix)
o.number = true -- lineNumberMode = "number"
o.relativenumber = false
o.expandtab = true
o.swapfile = false -- preventJunkFiles
o.backup = false
o.writebackup = false
o.undofile = true
o.errorbells = false
o.visualbell = false

-- vim.options from nvim.nix
o.smartindent = false
o.autoindent = false
-- Treesitter-driven folds so <leader>c can collapse functions.
o.foldmethod = "expr"
o.foldexpr = "v:lua.vim.treesitter.foldexpr()"
-- Open all folds when a file loads (nothing collapsed until asked)
o.foldlevel = 99
o.foldlevelstart = 99

-- lualine globalstatus: horizontal splits (e.g. toggleterm) get a
-- WinSeparator line instead of the upper window's statusline.
o.laststatus = 3
