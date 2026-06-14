local augroup = vim.api.nvim_create_augroup
local autocmd = vim.api.nvim_create_autocmd

-- ----------------------------------------------------------------------------
-- Floating window borders (NeoVim only — not loaded in VS Code)
-- vim.o.winborder is a NeoVim 0.12 global option that applies a border to
-- every floating window: LSP hover, signature help, diagnostics, Mason, etc.
-- This replaces the old per-handler vim.lsp.with() approach.
-- ----------------------------------------------------------------------------
vim.o.winborder = "rounded"

-- Diagnostic float inherits winborder automatically in 0.12, but set
-- explicitly for any older fallback path.
vim.diagnostic.config({
  float = { border = "rounded" },
})

-- ----------------------------------------------------------------------------
-- LSP keymaps — applied whenever an LSP server attaches to a buffer
-- Mirrors IdeaVim bindings for parity with Android Studio workflow.
-- ----------------------------------------------------------------------------
autocmd("LspAttach", {
  group = augroup("UserLspKeymaps", { clear = true }),
  callback = function(args)
    local buf = args.buf
    local map = function(lhs, rhs, opts)
      vim.keymap.set("n", lhs, rhs, vim.tbl_extend("force", {
        silent = true,
        buffer = buf,
      }, opts or {}))
    end

    -- <leader>h  → Hover / Quick Documentation  (matches IdeaVim <leader>h)
    map("<leader>h", vim.lsp.buf.hover,         { desc = "LSP hover" })

    -- <C-]>      → Go to Definition             (matches IdeaVim / IntelliJ default)
    map("<C-]>",     vim.lsp.buf.definition,    { desc = "LSP definition" })

    -- <C-S-]>   → List all references           (matches IntelliJ Ctrl+Shift+])
    map("<C-S-]>",   "<cmd>Telescope lsp_references<CR>", { desc = "LSP references" })

    -- <leader>s  → Code Action / Intentions      (matches IdeaVim <leader>s → ShowIntentionActions)
    map("<leader>s",  vim.lsp.buf.code_action,  { desc = "LSP code action" })

    -- <leader>ca → Code Action (alias kept for muscle-memory)
    map("<leader>ca", vim.lsp.buf.code_action,  { desc = "LSP code action" })

    -- Additional useful LSP mappings
    map("<leader>rn", vim.lsp.buf.rename,       { desc = "LSP rename" })
    map("grn",  vim.lsp.buf.rename,             { desc = "LSP rename" })
    map("gd",   vim.lsp.buf.definition,         { desc = "LSP definition" })
    map("gD",   vim.lsp.buf.declaration,        { desc = "LSP declaration" })
    map("gi",   vim.lsp.buf.implementation,     { desc = "LSP implementation" })
    map("gt",   vim.lsp.buf.type_definition,    { desc = "LSP type definition" })
    map("[d",   function() vim.diagnostic.jump({ count = -1 }) end, { desc = "Previous diagnostic" })
    map("]d",   function() vim.diagnostic.jump({ count =  1 }) end, { desc = "Next diagnostic" })
    map("<leader>d", vim.diagnostic.open_float, { desc = "Diagnostic float" })
  end,
})

-- ----------------------------------------------------------------------------
-- ESC: dismiss floating windows and close Lazy/plugin UIs
-- ----------------------------------------------------------------------------
-- Close any floating windows (hover, diagnostics, signature help, etc.)
vim.keymap.set("n", "<Esc>", function()
  -- Close all floating windows
  for _, win in ipairs(vim.api.nvim_list_wins()) do
    if vim.api.nvim_win_is_valid(win)
      and vim.api.nvim_win_get_config(win).relative ~= "" then
      vim.api.nvim_win_close(win, false)
    end
  end
  -- Also clear search highlight for convenience
  vim.cmd("nohlsearch")
end, { silent = true, desc = "Dismiss floats / clear search" })

-- q closes Lazy, Mason, and any other plugin UI buffers that support it
vim.api.nvim_create_autocmd("FileType", {
  group = augroup("PluginUiClose", { clear = true }),
  pattern = { "lazy", "mason", "null-ls-info", "lspinfo", "checkhealth" },
  callback = function(args)
    vim.keymap.set("n", "q", "<cmd>close<CR>",
      { buffer = args.buf, silent = true, desc = "Close plugin UI" })
  end,
})

-- ----------------------------------------------------------------------------
-- Language-specific indentation
-- ----------------------------------------------------------------------------
local indent2 = augroup("Indent2Space", { clear = true })
autocmd("FileType", {
  group = indent2,
  pattern = { "javascript", "typescript", "javascriptreact", "typescriptreact",
              "purescript", "lua", "html", "css", "json", "yaml" },
  callback = function()
    vim.opt_local.tabstop = 2
    vim.opt_local.shiftwidth = 2
    vim.opt_local.expandtab = true
  end,
})

-- ----------------------------------------------------------------------------
-- PureScript: remove stale signs before saving (mirrors old .vimrc behaviour)
-- ----------------------------------------------------------------------------
autocmd("BufWritePre", {
  group = augroup("PureScriptSave", { clear = true }),
  pattern = "*.purs",
  callback = function()
    vim.fn.sign_unplace("*", { buffer = vim.fn.bufnr("%") })
  end,
})

-- ----------------------------------------------------------------------------
-- Markdown / Prose: soft-wrap and pencil
-- ----------------------------------------------------------------------------
autocmd("FileType", {
  group = augroup("ProseFT", { clear = true }),
  pattern = { "markdown", "text", "vimwiki" },
  callback = function()
    -- vim-pencil is loaded lazily; call only if available
    if vim.fn.exists(":Pencil") == 2 then
      vim.cmd("PencilSoft")
    end
  end,
})

-- ----------------------------------------------------------------------------
-- Highlight yanked text briefly
-- ----------------------------------------------------------------------------
autocmd("TextYankPost", {
  group = augroup("YankHighlight", { clear = true }),
  callback = function()
    vim.highlight.on_yank({ higroup = "IncSearch", timeout = 150 })
  end,
})

-- ----------------------------------------------------------------------------
-- Restore cursor position when reopening a file
-- ----------------------------------------------------------------------------
autocmd("BufReadPost", {
  group = augroup("RestoreCursor", { clear = true }),
  callback = function()
    local mark = vim.api.nvim_buf_get_mark(0, '"')
    local line_count = vim.api.nvim_buf_line_count(0)
    if mark[1] > 0 and mark[1] <= line_count then
      pcall(vim.api.nvim_win_set_cursor, 0, mark)
    end
  end,
})

-- ----------------------------------------------------------------------------
-- Wipe the empty [No Name] buffer that Neovim creates on startup once a
-- real file is opened (e.g. via Telescope on first load).
-- Guards: only wipe buf #1 if it is still unnamed, empty, and unmodified.
-- ----------------------------------------------------------------------------
autocmd("BufWinEnter", {
  group = augroup("WipeInitialNoName", { clear = true }),
  callback = function()
    local current = vim.api.nvim_get_current_buf()
    -- Only act when we have just entered a real, named file buffer.
    if vim.api.nvim_buf_get_name(current) == "" then return end
    if vim.bo[current].buftype ~= "" then return end

    local initial = 1  -- Neovim always assigns buf #1 on startup
    if not vim.api.nvim_buf_is_valid(initial) then return end
    if initial == current then return end

    local name     = vim.api.nvim_buf_get_name(initial)
    local lines    = vim.api.nvim_buf_get_lines(initial, 0, -1, false)
    local modified = vim.bo[initial].modified
    local is_empty = #lines == 0 or (#lines == 1 and lines[1] == "")

    if name == "" and is_empty and not modified then
      vim.api.nvim_buf_delete(initial, { force = false })
    end
  end,
})
