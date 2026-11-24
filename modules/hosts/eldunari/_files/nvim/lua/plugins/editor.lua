return {
  {
    -- Options are nvf's telescope defaults plus the overrides in nvim.nix.
    "nvim-telescope/telescope.nvim",
    dependencies = { "nvim-lua/plenary.nvim" },
    opts = {
      defaults = {
        vimgrep_arguments = {
          "rg",
          "--color=never",
          "--no-heading",
          "--with-filename",
          "--line-number",
          "--column",
          "--smart-case",
          "--hidden",
          "--no-ignore",
        },
        prompt_prefix = "  \u{F422}   ",
        selection_caret = "  ",
        entry_prefix = "  ",
        initial_mode = "insert",
        selection_strategy = "reset",
        sorting_strategy = "ascending",
        layout_strategy = "horizontal",
        layout_config = {
          horizontal = { prompt_position = "top", preview_width = 0.55 },
          vertical = { mirror = false },
          width = 0.8,
          height = 0.8,
          preview_cutoff = 120,
        },
        file_ignore_patterns = {
          "node_modules",
          "%.git[/\\]",
          "dist[/\\]",
          "build[/\\]",
          "target[/\\]",
          "graft[/\\]",
        },
        path_display = { "absolute" },
        set_env = { COLORTERM = "truecolor" },
        winblend = 0,
      },
      pickers = {
        find_files = {
          find_command = { "fd", "--type=file" },
          hidden = false,
          no_ignore = true,
        },
      },
    },
  },

  {
    "akinsho/toggleterm.nvim",
    opts = {
      open_mapping = "<c-t>",
      direction = "horizontal",
      size = function(term)
        if term.direction == "horizontal" then
          return 15
        elseif term.direction == "vertical" then
          return vim.o.columns * 0.4
        end
      end,
      winbar = {
        enabled = true,
        name_formatter = function(term)
          return term.name
        end,
      },
      shade_terminals = false,
      -- Otherwise toggleterm reopens in whatever mode the terminal was left in.
      persist_mode = false,
      -- PowerShell 7 instead of cmd.exe. Only the terminal changes; 'shell'
      -- stays cmd.exe so :! and plugins behave as Neovim expects on Windows.
      shell = vim.fn.executable("pwsh") == 1 and "pwsh -NoLogo" or vim.o.shell,
    },
    config = function(_, opts)
      require("toggleterm").setup(opts)
      local lazygit = require("toggleterm.terminal").Terminal:new({
        cmd = "lazygit",
        direction = "float",
        hidden = true,
        on_open = function()
          vim.cmd("startinsert!")
        end,
      })
      vim.keymap.set("n", "<leader>gg", function()
        lazygit:toggle()
      end, { silent = true, desc = "Open lazygit [toggleterm]" })
    end,
  },

  {
    "kylechui/nvim-surround",
    opts = {},
  },

  {
    "hedyhli/outline.nvim",
    opts = {},
  },

  {
    "hat0uma/csvview.nvim",
    opts = {},
  },

  {
    "MeanderingProgrammer/render-markdown.nvim",
    opts = {},
  },
}
