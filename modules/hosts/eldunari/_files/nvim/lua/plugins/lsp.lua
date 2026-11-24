-- basedpyright and ruff come from `uv tool install`, so no mason and no Node.

-- nvim.nix pythonExtraPaths, at this PC's checkout locations.
local python_extra_paths = vim.tbl_filter(function(p)
  return vim.uv.fs_stat(p) ~= nil
end, {
  "D:/Repos/rf_analyzer/src",
  "D:/Repos/Imodulator/src",
})

-- nvf's default LSP keymaps (nvf: modules/plugins/lsp/module.nix).
-- <leader>lf is global, in config/keymaps.lua.
local function lsp_keymaps(bufnr)
  local function map(lhs, rhs, desc)
    vim.keymap.set("n", lhs, rhs, { buffer = bufnr, silent = true, desc = desc })
  end
  local function jump(count)
    return function()
      vim.diagnostic.jump({ count = count, float = true })
    end
  end
  map("<leader>lgD", vim.lsp.buf.declaration, "Go to declaration")
  map("<leader>lgd", vim.lsp.buf.definition, "Go to definition")
  map("<leader>lgt", vim.lsp.buf.type_definition, "Go to type")
  map("<leader>lgi", vim.lsp.buf.implementation, "List implementations")
  map("<leader>lgr", vim.lsp.buf.references, "List references")
  map("<leader>lgn", jump(1), "Go to next diagnostic")
  map("<leader>lgp", jump(-1), "Go to previous diagnostic")
  map("<leader>le", vim.diagnostic.open_float, "Open diagnostic float")
  map("<leader>lH", vim.lsp.buf.document_highlight, "Document highlight")
  map("<leader>lS", vim.lsp.buf.document_symbol, "List document symbols")
  map("<leader>lwa", vim.lsp.buf.add_workspace_folder, "Add workspace folder")
  map("<leader>lwr", vim.lsp.buf.remove_workspace_folder, "Remove workspace folder")
  map("<leader>lwl", function()
    vim.notify(vim.inspect(vim.lsp.buf.list_workspace_folders()))
  end, "List workspace folders")
  map("<leader>lws", vim.lsp.buf.workspace_symbol, "List workspace symbols")
  map("<leader>lh", vim.lsp.buf.hover, "Trigger hover")
  map("<leader>ls", vim.lsp.buf.signature_help, "Signature help")
  map("<leader>ln", vim.lsp.buf.rename, "Rename symbol")
  map("<leader>la", vim.lsp.buf.code_action, "Code action")
  map("<leader>ltf", function()
    vim.g.format_on_save = not vim.g.format_on_save
    vim.notify("Format on save " .. (vim.g.format_on_save and "enabled" or "disabled"))
  end, "Toggle format on save")
end

return {
  {
    "neovim/nvim-lspconfig",
    dependencies = { "hrsh7th/cmp-nvim-lsp" },
    config = function()
      vim.lsp.config("*", {
        capabilities = require("cmp_nvim_lsp").default_capabilities(),
      })

      vim.lsp.config("basedpyright", {
        settings = {
          basedpyright = {
            analysis = {
              extraPaths = python_extra_paths,
              typeCheckingMode = "standard",
              -- Every symbol under extraPaths is otherwise offered as an
              -- auto-import candidate, which buries the real completions.
              autoImportCompletions = false,
            },
          },
        },
        -- Point basedpyright at the project's uv venv. Without this it uses
        -- whatever `python` is on PATH, which on this PC is the Microsoft
        -- Store stub, and no third-party import resolves.
        before_init = function(_, config)
          local root = config.root_dir
          if not root then
            return
          end
          local python = vim.fs.joinpath(root, ".venv", "Scripts", "python.exe")
          if vim.uv.fs_stat(python) then
            -- Mutate in place: config.settings is the table the client
            -- answers workspace/configuration requests from.
            config.settings.python = config.settings.python or {}
            config.settings.python.pythonPath = python
          end
        end,
      })
      vim.lsp.enable("basedpyright")

      vim.api.nvim_create_autocmd("LspAttach", {
        callback = function(args)
          lsp_keymaps(args.buf)
        end,
      })
    end,
  },

  {
    "hrsh7th/nvim-cmp",
    dependencies = { "hrsh7th/cmp-nvim-lsp", "hrsh7th/cmp-path" },
    config = function()
      local cmp = require("cmp")
      local function has_words_before()
        local line, col = unpack(vim.api.nvim_win_get_cursor(0))
        return col ~= 0
          and vim.api.nvim_buf_get_lines(0, line - 1, line, true)[1]:sub(col, col):match("%s")
            == nil
      end
      local source_labels = { nvim_lsp = "[LSP]", path = "[Path]" }

      cmp.setup({
        completion = { completeopt = "menu,menuone,noinsert" },
        -- No cmp-buffer: it suggests any token in the buffer with no syntax
        -- awareness. Keep completion LSP-driven, like VSCode.
        sources = { { name = "nvim_lsp" }, { name = "path" } },
        window = {
          completion = cmp.config.window.bordered({ border = "rounded" }),
          documentation = cmp.config.window.bordered({ border = "rounded" }),
        },
        formatting = {
          format = function(entry, item)
            item.menu = source_labels[entry.source.name]
            return item
          end,
        },
        -- nvf's nvim-cmp mappings
        mapping = {
          ["<C-Space>"] = cmp.mapping.complete(),
          ["<C-e>"] = cmp.mapping.abort(),
          ["<C-d>"] = cmp.mapping.scroll_docs(-4),
          ["<C-f>"] = cmp.mapping.scroll_docs(4),
          ["<CR>"] = cmp.mapping.confirm({ select = true }),
          ["<Tab>"] = cmp.mapping(function(fallback)
            if cmp.visible() then
              cmp.select_next_item()
            elseif has_words_before() then
              cmp.complete()
            else
              fallback()
            end
          end, { "i", "s" }),
          ["<S-Tab>"] = cmp.mapping(function(fallback)
            if cmp.visible() then
              cmp.select_prev_item()
            else
              fallback()
            end
          end, { "i", "s" }),
        },
      })
    end,
  },

  {
    "ray-x/lsp_signature.nvim",
    opts = {
      bind = true,
      handler_opts = { border = "rounded" },
    },
  },

  {
    "stevearc/conform.nvim",
    opts = {
      formatters_by_ft = {
        -- nvf's "ruff-fix" then "ruff" (format --force-exclude ...).
        python = { "ruff_fix", "ruff_format" },
      },
      -- Off by default, as in nvf; <leader>ltf toggles it.
      format_on_save = function()
        if vim.g.format_on_save then
          return { timeout_ms = 1000, lsp_format = "fallback" }
        end
      end,
    },
  },
}
