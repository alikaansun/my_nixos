-- Global keymaps: nvimKeymaps from nvim.nix, plus the Telescope and
-- Bufferline keymaps nvf adds by default. LSP keymaps live in plugins/lsp.lua
-- (buffer-local, on LspAttach), git ones in plugins/git.lua.

local function map(mode, lhs, rhs, desc)
  vim.keymap.set(mode, lhs, rhs, { silent = true, desc = desc })
end

-- Buffers ----------------------------------------------------------------
-- <leader>b<N> jumps to the Nth buffer in the bufferline.
for i = 1, 9 do
  map("n", "<leader>b" .. i, "<cmd>BufferLineGoToBuffer " .. i .. "<cr>", "Go to buffer " .. i)
end
map("n", "<leader>bx", "<cmd>lua Snacks.bufdelete()<cr>", "Close buffer")
map("n", "<leader>bt", "<cmd>enew<cr>", "New buffer")

-- nvf bufferline defaults
map("n", "<leader>bn", "<cmd>BufferLineCycleNext<cr>", "Next buffer")
map("n", "<leader>bp", "<cmd>BufferLineCyclePrev<cr>", "Previous buffer")
map("n", "<leader>bc", "<cmd>BufferLinePick<cr>", "Pick buffer")
map("n", "<leader>bse", "<cmd>BufferLineSortByExtension<cr>", "Sort buffers by extension")
map("n", "<leader>bsd", "<cmd>BufferLineSortByDirectory<cr>", "Sort buffers by directory")
map("n", "<leader>bsi", function()
  require("bufferline").sort_by(function(a, b)
    return a.id < b.id
  end)
end, "Sort buffers by ID")
map("n", "<leader>bmn", "<cmd>BufferLineMoveNext<cr>", "Move next buffer")
map("n", "<leader>bmp", "<cmd>BufferLineMovePrev<cr>", "Move previous buffer")

-- Windows ----------------------------------------------------------------
-- <C-h/j/k/l> window navigation; mode "t" makes it work from inside
-- terminal buffers (toggleterm) without <C-\><C-n>.
for _, dir in ipairs({ "h", "j", "k", "l" }) do
  map({ "n", "t" }, "<C-" .. dir .. ">", "<cmd>wincmd " .. dir .. "<cr>", "Window " .. dir)
end
map("n", "<leader>wv", "<cmd>vsplit<cr>", "Split window vertically")
map("n", "<leader>w-", "<cmd>split<cr>", "Split window horizontally")
map("n", "<leader>wc", "<cmd>close<cr>", "Close split (keep buffer)")
map("n", "<leader>wo", "<cmd>only<cr>", "Close other splits")
map("n", "<leader>w=", "<cmd>wincmd =<cr>", "Equalize split sizes")

map(
  "n",
  "<leader>lf",
  "<cmd>lua require('conform').format({ async = true, lsp_fallback = true })<cr>",
  "Format buffer"
)

-- Folds ------------------------------------------------------------------
-- Each suffix mirrors the native z-command (swap `z` for `<leader>c`).
for _, f in ipairs({
  { "a", "Toggle fold under cursor" },
  { "c", "Close fold under cursor" },
  { "o", "Open fold under cursor" },
  { "M", "Close all folds" },
  { "R", "Open all folds" },
  { "m", "Fold more (one level)" },
  { "r", "Fold less (one level)" },
  { "j", "Jump to next fold" },
  { "k", "Jump to previous fold" },
}) do
  map("n", "<leader>c" .. f[1], "z" .. f[1], f[2])
end

-- Tools ------------------------------------------------------------------
map("n", "<leader>?", "<cmd>Telescope keymaps<cr>", "Search keymaps")
map("n", "<leader>e", "<cmd>lua Snacks.explorer()<cr>", "Toggle file tree")
map("n", "<leader>o", "<cmd>Outline<cr>", "Toggle symbol outline")

-- Yank / paste -----------------------------------------------------------
map("n", "<leader>yp", "<cmd>let @\" = expand('%:p')<cr>", "Yank absolute file path")
map("n", "<leader>yr", "<cmd>let @\" = expand('%:.')<cr>", "Yank relative file path")
map("v", "<leader>yy", "y", "Yank selection")
map("n", "<leader>yy", "yy", "Yank line")
map("n", "<leader>ya", "<cmd>%y<cr>", "Yank whole file")
map("n", "<leader>ycp", "<cmd>let @+ = expand('%:p')<cr>", "Yank absolute file path to clipboard")
map("n", "<leader>ycr", "<cmd>let @+ = expand('%:.')<cr>", "Yank relative file path to clipboard")
map("v", "<leader>ycy", '"+y', "Yank selection to clipboard")
map("n", "<leader>ycy", '"+yy', "Yank line to clipboard")
map("n", "<leader>yca", "<cmd>%y+<cr>", "Yank whole file to clipboard")
map({ "n", "v" }, "<leader>p", '"+p', "Paste from clipboard")

-- Move lines -------------------------------------------------------------
map("n", "<A-Down>", "<cmd>m .+1<cr>==", "Move line down")
map("n", "<A-Up>", "<cmd>m .-2<cr>==", "Move line up")
map("v", "<A-Down>", ":m '>+1<cr>gv=gv", "Move selection down")
map("v", "<A-Up>", ":m '<-2<cr>gv=gv", "Move selection up")

-- Telescope (nvf defaults) -----------------------------------------------
for _, t in ipairs({
  { "<leader>ff", "find_files", "Find files" },
  { "<leader>fg", "live_grep", "Live grep" },
  { "<leader>fb", "buffers", "Buffers" },
  { "<leader>fh", "help_tags", "Help tags" },
  { "<leader>ft", "", "Open" },
  { "<leader>fr", "resume", "Resume (previous search)" },
  { "<leader>fs", "treesitter", "Treesitter" },
  -- git
  { "<leader>fvf", "git_files", "Git files" },
  { "<leader>fvcw", "git_commits", "Git commits" },
  { "<leader>fvcb", "git_bcommits", "Git buffer commits" },
  { "<leader>fvb", "git_branches", "Git branches" },
  { "<leader>fvs", "git_status", "Git status" },
  { "<leader>fvx", "git_stash", "Git stash" },
  -- lsp
  { "<leader>flsb", "lsp_document_symbols", "LSP Document Symbols" },
  { "<leader>flsw", "lsp_workspace_symbols", "LSP Workspace Symbols" },
  { "<leader>flr", "lsp_references", "LSP References" },
  { "<leader>fli", "lsp_implementations", "LSP Implementations" },
  { "<leader>flD", "lsp_definitions", "LSP Definitions" },
  { "<leader>flt", "lsp_type_definitions", "LSP Type Definitions" },
  { "<leader>fld", "diagnostics", "Diagnostics" },
}) do
  map("n", t[1], "<cmd>Telescope " .. t[2] .. "<cr>", t[3])
end
