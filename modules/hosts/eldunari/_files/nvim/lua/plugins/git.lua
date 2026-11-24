-- What nvf's `git.enable` turns on, minus hunk.nvim (a jj diff editor).
return {
  {
    "lewis6991/gitsigns.nvim",
    opts = {
      on_attach = function(bufnr)
        local gs = require("gitsigns")
        local function map(lhs, rhs, desc, opts)
          vim.keymap.set("n", lhs, rhs, vim.tbl_extend("force", {
            buffer = bufnr,
            silent = true,
            desc = desc,
          }, opts or {}))
        end

        -- nvf gitsigns defaults
        map("]c", function()
          if vim.wo.diff then
            return "]c"
          end
          vim.schedule(function()
            gs.nav_hunk("next")
          end)
          return "<Ignore>"
        end, "Next hunk", { expr = true })
        map("[c", function()
          if vim.wo.diff then
            return "[c"
          end
          vim.schedule(function()
            gs.nav_hunk("prev")
          end)
          return "<Ignore>"
        end, "Previous hunk", { expr = true })
        map("<leader>hs", gs.stage_hunk, "Stage hunk")
        -- stage_hunk on a staged hunk unstages it; undo_stage_hunk is deprecated.
        map("<leader>hu", gs.stage_hunk, "Undo stage hunk")
        map("<leader>hr", gs.reset_hunk, "Reset hunk")
        map("<leader>hS", gs.stage_buffer, "Stage buffer")
        map("<leader>hR", gs.reset_buffer, "Reset buffer")
        map("<leader>hP", gs.preview_hunk, "Preview hunk")
        map("<leader>hb", function()
          gs.blame_line({ full = true })
        end, "Blame line")
        map("<leader>tb", gs.toggle_current_line_blame, "Toggle blame")
        map("<leader>hd", gs.diffthis, "Diff this")
        map("<leader>hD", function()
          gs.diffthis("~")
        end, "Diff project")
        map("<leader>td", gs.preview_hunk_inline, "Toggle deleted")
      end,
    },
  },

  {
    "akinsho/git-conflict.nvim",
    opts = {
      default_mappings = {
        ours = "<leader>gco",
        theirs = "<leader>gct",
        both = "<leader>gcb",
        none = "<leader>gc0",
        -- nvf's defaults, swapped as on the Mac.
        prev = "]x",
        next = "[x",
      },
    },
  },

  { "tpope/vim-fugitive" },

  {
    "linrongbin16/gitlinker.nvim",
    cmd = "GitLink",
    opts = {},
  },
}
