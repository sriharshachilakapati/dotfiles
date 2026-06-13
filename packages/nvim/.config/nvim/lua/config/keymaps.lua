local map = function(mode, lhs, rhs, opts)
  vim.keymap.set(mode, lhs, rhs, vim.tbl_extend("force", { silent = true }, opts or {}))
end

-- ----------------------------------------------------------------------------
-- Re-indent and keep visual selection
-- ----------------------------------------------------------------------------
map("v", ">", ">gv")
map("v", "<", "<gv")

-- ----------------------------------------------------------------------------
-- Split navigation
-- ----------------------------------------------------------------------------
map("n", "<C-J>", "<C-W><C-J>")
map("n", "<C-K>", "<C-W><C-K>")
map("n", "<C-H>", "<C-W><C-H>")
map("n", "<C-L>", "<C-W><C-L>")

-- ----------------------------------------------------------------------------
-- Buffer navigation
-- ----------------------------------------------------------------------------
map("n", "<S-J>", "<cmd>bprevious<CR>")
map("n", "<S-K>", "<cmd>bnext<CR>")

-- Kill buffer without closing the split (native)
map("n", "x", function()
  local buf = vim.api.nvim_get_current_buf()
  -- Switch to the previous buffer (or a new empty one) before deleting,
  -- so the split/window stays open.
  local ok = pcall(vim.cmd, "bprevious")
  if not ok or vim.api.nvim_get_current_buf() == buf then
    vim.cmd("enew")
  end
  if vim.api.nvim_buf_is_valid(buf) then
    vim.api.nvim_buf_delete(buf, { force = false })
  end
end, { desc = "Kill buffer (keep split)" })

-- ----------------------------------------------------------------------------
-- Search
-- ----------------------------------------------------------------------------
map("n", ",/", "<cmd>nohlsearch<CR>")

-- ----------------------------------------------------------------------------
-- File / text search
-- ----------------------------------------------------------------------------
-- <C-P>: fuzzy file finder
map("n", "<C-P>", "<cmd>Telescope find_files<CR>")

-- <C-S-F>: live grep with Silver Searcher backend
map("n", "<C-S-F>", "<cmd>Telescope live_grep<CR>")

-- ----------------------------------------------------------------------------
-- File tree
-- ----------------------------------------------------------------------------
map("n", "<C-n>", "<cmd>Neotree toggle<CR>")

-- ----------------------------------------------------------------------------
-- Git blame  (matches IdeaVim <leader>a → Annotate)
-- ----------------------------------------------------------------------------
map("n", "<leader>a", "<cmd>Git blame<CR>")
map("n", "<C-B>",     "<cmd>Git blame<CR>")   -- preserve old binding

-- ----------------------------------------------------------------------------
-- Paste mode
-- ----------------------------------------------------------------------------
map("n", "<F2>", "<cmd>set paste!<CR>")

-- ----------------------------------------------------------------------------
-- Reload config
-- ----------------------------------------------------------------------------
map("n", ",r", "<cmd>source $MYVIMRC<CR>", { desc = "Reload nvim config" })
