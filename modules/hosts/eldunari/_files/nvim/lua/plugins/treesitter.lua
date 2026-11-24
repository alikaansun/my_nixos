-- nvim-treesitter's main branch compiles each parser on this machine with
-- the tree-sitter CLI and a C compiler; see README.md.

-- The tree-sitter CLI defaults to MSVC's cl.exe on Windows. Use MinGW gcc
-- (scoop install mingw) instead. `zig cc` doesn't work: the CLI passes it an
-- MSVC target triple (x86_64-pc-windows-msvc) that zig rejects.
if vim.fn.has("win32") == 1 and not vim.env.CC and vim.fn.executable("gcc") == 1 then
  vim.env.CC = "gcc"
end

local parsers = {
  "python",
  "lua",
  "vim",
  "vimdoc",
  "query",
  "markdown",
  "markdown_inline",
  "regex",
  "yaml",
  "toml",
  "json",
  "bash",
}

return {
  {
    "nvim-treesitter/nvim-treesitter",
    branch = "main",
    build = ":TSUpdate",
    config = function()
      require("nvim-treesitter").install(parsers)
      vim.api.nvim_create_autocmd("FileType", {
        callback = function(args)
          -- Highlight and indent with treesitter wherever a parser exists.
          if pcall(vim.treesitter.start, args.buf) then
            vim.bo[args.buf].indentexpr = "v:lua.require'nvim-treesitter'.indentexpr()"
          end
        end,
      })
    end,
  },
}
