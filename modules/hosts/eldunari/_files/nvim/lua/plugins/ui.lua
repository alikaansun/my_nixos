local border_green = "#89D185"

-- An empty lualine component drawn only for its coloured separator, as in
-- nvf's default sections.
local function spacer(left, right)
  return { "", draw_empty = true, separator = { left = left, right = right } }
end

return {
  {
    "Mofiqul/vscode.nvim",
    priority = 1000,
    config = function()
      require("vscode").setup({
        transparent = false,
        color_overrides = { vscFront = "#CCCCCC" },
      })
      require("vscode").load()
      vim.api.nvim_set_hl(0, "WinSeparator", { fg = border_green })
      vim.api.nvim_set_hl(0, "FloatBorder", { fg = border_green })
    end,
  },

  {
    "nvim-mini/mini.icons",
    priority = 900,
    config = function()
      require("mini.icons").setup()
      -- bufferline, lualine and telescope ask for nvim-web-devicons.
      MiniIcons.mock_nvim_web_devicons()
    end,
  },

  {
    -- nvf's default lualine sections, plus the word count from nvim.nix.
    "nvim-lualine/lualine.nvim",
    opts = {
      options = { globalstatus = true },
      sections = {
        lualine_a = {
          {
            "mode",
            icons_enabled = true,
            separator = { left = "\u{258E}", right = "\u{E0BC}" },
          },
          spacer("\u{E0BA}", "\u{E0BC}"),
        },
        lualine_b = {
          { "filetype", colored = true, icon_only = true, icon = { align = "left" } },
          {
            "filename",
            symbols = { modified = "\u{F044} ", readonly = "\u{EA75} " },
            separator = { right = "\u{E0BC}" },
          },
          spacer("\u{E0BA}", "\u{E0BC}"),
        },
        lualine_c = {
          {
            "diff",
            colored = false,
            diff_color = { added = "DiffAdd", modified = "DiffChange", removed = "DiffDelete" },
            symbols = { added = "+", modified = "~", removed = "-" },
            separator = { right = "\u{E0BC}" },
          },
        },
        lualine_x = {
          {
            -- LSP server name
            function()
              local excluded = {
                toggleterm = true,
                NvimTree = true,
                ["neo-tree"] = true,
                TelescopePrompt = true,
              }
              if excluded[vim.bo.filetype] then
                return ""
              end
              local clients = vim.lsp.get_clients({ bufnr = 0 })
              if vim.tbl_isempty(clients) then
                return "No Active LSP"
              end
              return table.concat(
                vim.tbl_map(function(c)
                  return c.name
                end, clients),
                ", "
              )
            end,
            icon = "\u{F085} ",
            separator = { left = "\u{E0BE}" },
          },
          {
            "diagnostics",
            sources = { "nvim_lsp", "nvim_diagnostic", "vim_lsp", "coc" },
            symbols = {
              error = "\u{F0159}  ",
              warn = "\u{F071}  ",
              info = "\u{F05A}  ",
              hint = "\u{F0335} ",
            },
            colored = true,
            update_in_insert = false,
            always_visible = false,
            diagnostics_color = {
              color_error = { fg = "red" },
              color_warn = { fg = "yellow" },
              color_info = { fg = "cyan" },
            },
          },
          -- From nvim.nix. wordcount() counts markup tokens as words.
          {
            function()
              local wc = vim.fn.wordcount()
              return (wc.visual_words or wc.words) .. " words"
            end,
            cond = function()
              return vim.tbl_contains(
                { "markdown", "tex", "plaintex", "typst", "text" },
                vim.bo.filetype
              )
            end,
          },
        },
        lualine_y = {
          spacer("\u{E0BE}", "\u{E0B8}"),
          {
            "searchcount",
            maxcount = 999,
            timeout = 120,
            separator = { left = "\u{E0BE}" },
          },
          { "branch", icon = "\u{2022}", separator = { left = "\u{E0BE}" } },
        },
        lualine_z = {
          spacer("\u{E0BE}", "\u{E0B8}"),
          { "progress", separator = { left = "\u{E0BE}" } },
          { "location" },
          {
            "fileformat",
            color = { fg = "black" },
            symbols = { unix = "\u{E712}", dos = "\u{E70F}", mac = "\u{E711}" },
          },
        },
      },
    },
  },

  {
    -- Show open buffers as tabs; options are nvf's defaults.
    "akinsho/bufferline.nvim",
    opts = {
      options = {
        mode = "buffers",
        numbers = function(opts)
          return string.format("%s·%s", opts.raise(opts.id), opts.lower(opts.ordinal))
        end,
        close_command = function(bufnum)
          Snacks.bufdelete(bufnum)
        end,
        right_mouse_command = "vertical sbuffer %d",
        left_mouse_command = "buffer %d",
        indicator = { style = "underline" },
        buffer_close_icon = " \u{F0156} ",
        modified_icon = "● ",
        close_icon = " \u{F0156} ",
        left_trunc_marker = "\u{F0A8}",
        right_trunc_marker = "\u{F0A9}",
        max_name_length = 18,
        max_prefix_length = 15,
        truncate_names = true,
        tab_size = 18,
        diagnostics = false, -- nvim.nix turns these off
        offsets = {
          {
            filetype = "snacks_layout_box",
            text = "File Explorer",
            highlight = "Directory",
            separator = true,
          },
        },
        color_icons = true,
        separator_style = "thin",
        always_show_bufferline = true,
        hover = { enabled = true, delay = 200, reveal = { "close" } },
        sort_by = "extension",
      },
    },
  },

  {
    -- snacks.image is left out: it needs the kitty graphics protocol, which
    -- Windows Terminal doesn't speak.
    "folke/snacks.nvim",
    priority = 1000,
    opts = {
      explorer = { enabled = true },
      picker = {
        enabled = true,
        sources = {
          explorer = { hidden = true, ignored = true },
        },
      },
      indent = { enabled = true },
      notifier = { enabled = true },
      scroll = { enabled = true },
      statuscolumn = { enabled = true },
      dashboard = {
        enabled = true,
        sections = {
          { section = "header" },
          { section = "keys", gap = 1 },
          {
            icon = " ",
            title = "Recent Files",
            section = "recent_files",
            indent = 2,
            padding = { 2, 2 },
          },
          { icon = " ", title = "Projects", section = "projects", indent = 2, padding = 2 },
        },
      },
    },
  },

  {
    "folke/which-key.nvim",
    opts = {
      preset = "modern",
      win = { border = "rounded" },
      spec = {
        { "<leader>b", group = "Buffer" },
        { "<leader>bm", group = "BufferLineMove" },
        { "<leader>bs", group = "BufferLineSort" },
        { "<leader>c", group = "Fold" },
        { "<leader>f", group = "Telescope" },
        { "<leader>fl", group = "Telescope LSP" },
        { "<leader>fv", group = "Telescope Git" },
        { "<leader>fvc", group = "Commits" },
        { "<leader>g", group = "Git" },
        { "<leader>gc", group = "Git conflict" },
        { "<leader>h", group = "Gitsigns" },
        { "<leader>l", group = "LSP" },
        { "<leader>w", group = "Window" },
        { "<leader>y", group = "Yank" },
        { "<leader>yc", group = "Copy to clipboard" },
      },
    },
  },

  {
    -- Highlight color codes (e.g. #FFFFFF)
    "catgoose/nvim-colorizer.lua",
    opts = {},
  },

  {
    "sphamba/smear-cursor.nvim",
    opts = {
      cursor_color = "#AEAFAD",
      stiffness = 0.8,
      trailing_stiffness = 0.6,
      stiffness_insert_mode = 0.9,
      trailing_stiffness_insert_mode = 0.7,
      distance_stop_animating = 0.5,
    },
  },
}
