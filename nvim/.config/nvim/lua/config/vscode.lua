-- Configuration applied when running inside VS Code (vscode-neovim extension).
-- Loads the same options and keymaps as the full config so behaviour is
-- consistent — no duplication. Plugins are not loaded.
--
-- options.lua covers: tabs, numbers, search, mouse, etc.
-- keymaps.lua covers: split nav, re-indent, clear search, buffer nav, etc.
-- Only mappings that reference plugins (Telescope, Neotree, Bdelete, Git)
-- will silently no-op in VS Code since those plugins are not loaded.

require("config.options")
require("config.keymaps")

-- ----------------------------------------------------------------------------
-- LSP-equivalent mappings for VS Code
-- Mirrors autocmds.lua LspAttach bindings using VS Code command equivalents.
-- ----------------------------------------------------------------------------
local map = function(lhs, rhs)
  vim.keymap.set("n", lhs, rhs, { silent = true })
end

-- <leader>h  → Hover documentation       (matches IdeaVim <leader>h)
map("<leader>h", "<cmd>call VSCodeNotify('editor.action.showHover')<CR>")

-- <C-]>      → Go to definition          (matches IdeaVim / IntelliJ default)
map("<C-]>",     "<cmd>call VSCodeNotify('editor.action.revealDefinition')<CR>")

-- <C-S-]>    → List all references       (matches IntelliJ Ctrl+Shift+])
map("<C-S-]>",   "<cmd>call VSCodeNotify('editor.action.referenceSearch.trigger')<CR>")

-- <leader>ca → Code action / quick fix   (matches IdeaVim <leader>ca)
map("<leader>ca","<cmd>call VSCodeNotify('editor.action.quickFix')<CR>")

-- grn        → Rename symbol
map("grn",       "<cmd>call VSCodeNotify('editor.action.rename')<CR>")

-- gd         → Go to definition
map("gd",        "<cmd>call VSCodeNotify('editor.action.revealDefinition')<CR>")

-- gD         → Go to declaration
map("gD",        "<cmd>call VSCodeNotify('editor.action.revealDeclaration')<CR>")

-- gi         → Go to implementation
map("gi",        "<cmd>call VSCodeNotify('editor.action.goToImplementation')<CR>")

-- gt         → Go to type definition
map("gt",        "<cmd>call VSCodeNotify('editor.action.goToTypeDefinition')<CR>")

-- [d / ]d    → Previous / next diagnostic
map("[d",        "<cmd>call VSCodeNotify('editor.action.marker.prevInFiles')<CR>")
map("]d",        "<cmd>call VSCodeNotify('editor.action.marker.nextInFiles')<CR>")

-- <leader>d  → Show diagnostic / error description
map("<leader>d", "<cmd>call VSCodeNotify('editor.action.showHover')<CR>")
