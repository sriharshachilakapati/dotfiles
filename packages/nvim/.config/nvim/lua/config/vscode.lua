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

local vscode = require("vscode")
local map = function(lhs, rhs, modes)
	vim.keymap.set(modes or "n", lhs, rhs, { silent = true })
end

-- ----------------------------------------------------------------------------
-- Tab navigation  (overrides keymaps.lua's :bprevious/:bnext — VS Code uses
-- tabs instead of buffers, so re-map them to buffer commands
-- ----------------------------------------------------------------------------
map("<S-J>", "<cmd>Tabprevious<CR>")
map("<S-K>", "<cmd>Tabnext<CR>")
map("x", "<cmd>Tabclose<CR>")

-- ----------------------------------------------------------------------------
-- LSP-equivalent mappings for VS Code
-- Mirrors autocmds.lua LspAttach bindings using VS Code command equivalents.
-- ----------------------------------------------------------------------------

-- <leader>h  → Hover documentation       (matches IdeaVim <leader>h)
map("<leader>h", function()
	vscode.action("editor.action.showHover")
end)

-- <C-]>      → Go to definition          (matches IdeaVim / IntelliJ default)
map("<C-]>", function()
	vscode.action("editor.action.revealDefinition")
end)

-- <C-S-]>    → List all references       (matches IntelliJ Ctrl+Shift+])
map("<C-S-]>", function()
	vscode.action("editor.action.referenceSearch.trigger")
end)

-- <leader>c  → Toggle line comment (normal + visual)
map("<leader>c", function()
	vscode.action("editor.action.commentLine")
end, { "n", "x" })

-- <leader>s  → Code action / quick fix   (matches IdeaVim <leader>s)
map("<leader>s", function()
	vscode.action("editor.action.quickFix")
end)

-- <leader>ca → Code action (alias)
map("<leader>ca", function()
	vscode.action("editor.action.quickFix")
end)

-- <leader>rn → Rename symbol
map("<leader>rn", function()
	vscode.action("editor.action.rename")
end)

-- grn        → Rename symbol (alias)
map("grn", function()
	vscode.action("editor.action.rename")
end)

-- gd         → Go to definition
map("gd", function()
	vscode.action("editor.action.revealDefinition")
end)

-- gD         → Go to declaration
map("gD", function()
	vscode.action("editor.action.revealDeclaration")
end)

-- gi         → Go to implementation
map("gi", function()
	vscode.action("editor.action.goToImplementation")
end)

-- gt         → Go to type definition
map("gt", function()
	vscode.action("editor.action.goToTypeDefinition")
end)

-- [d / ]d    → Previous / next diagnostic
map("[d", function()
	vscode.action("editor.action.marker.prevInFiles")
end)
map("]d", function()
	vscode.action("editor.action.marker.nextInFiles")
end)

-- <leader>d  → Show diagnostic / error description
map("<leader>d", function()
	vscode.action("editor.action.showHover")
end)
