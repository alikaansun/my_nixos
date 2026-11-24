local lazypath = vim.fn.stdpath("data") .. "/lazy/lazy.nvim"
if not vim.uv.fs_stat(lazypath) then
  local out = vim.fn.system({
    "git",
    "clone",
    "--filter=blob:none",
    "--branch=stable",
    "https://github.com/folke/lazy.nvim.git",
    lazypath,
  })
  if vim.v.shell_error ~= 0 then
    error("Cloning lazy.nvim failed:\n" .. out)
  end
end
vim.opt.rtp:prepend(lazypath)

require("lazy").setup({
  spec = { { import = "plugins" } },
  -- Everything loads at startup, like nvf: the keymaps in config/keymaps.lua
  -- call plugin commands directly.
  defaults = { lazy = false },
  install = { colorscheme = { "vscode" } },
  checker = { enabled = false },
  change_detection = { notify = false },
  -- No plugin here needs luarocks; this avoids the hererocks/luarocks
  -- requirement on Windows.
  rocks = { enabled = false },
})
