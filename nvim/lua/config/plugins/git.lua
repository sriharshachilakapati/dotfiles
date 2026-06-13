local sign_values = {
	add = { text = " 󰐕" }, -- nf-md-plus_circle       (new lines)
	change = { text = " 󰏫" }, -- nf-md-pencil            (modified lines)
	delete = { text = " 󰍴" }, -- nf-md-minus_circle      (deleted below)
	topdelete = { text = " 󰍴" }, -- nf-md-minus_circle      (deleted above)
	changedelete = { text = " 󰀪" }, -- nf-md-alert_circle      (changed + deleted)
	untracked = { text = " 󰘎" }, -- nf-md-help_circle       (untracked file)
}

return {
	-- --------------------------------------------------------------------------
	-- gitsigns: git diff in sign column (replaces vim-gitgutter)
	-- --------------------------------------------------------------------------
	{
		"lewis6991/gitsigns.nvim",
		event = { "BufReadPost", "BufNewFile" },
		opts = {
			signs = sign_values,
			signs_staged = sign_values,
			sign_priority = 6,
			update_debounce = 100,
			current_line_blame = false,
			attach_to_untracked = false,
			on_attach = function(bufnr)
				local gs = package.loaded.gitsigns
				local map = function(mode, lhs, rhs, opts)
					vim.keymap.set(
						mode,
						lhs,
						rhs,
						vim.tbl_extend("force", { silent = true, buffer = bufnr }, opts or {})
					)
				end

				-- Hunk navigation
				map("n", "]h", gs.next_hunk, { desc = "Next hunk" })
				map("n", "[h", gs.prev_hunk, { desc = "Prev hunk" })

				-- Stage / reset hunks
				map("n", "<leader>hs", gs.stage_hunk, { desc = "Stage hunk" })
				map("n", "<leader>hr", gs.reset_hunk, { desc = "Reset hunk" })
				map("n", "<leader>hp", gs.preview_hunk, { desc = "Preview hunk" })
			end,
		},
	},

	-- --------------------------------------------------------------------------
	-- vim-fugitive: Git commands (kept as-is, works perfectly in NeoVim)
	-- <leader>a and <C-B> → :Git blame  (set in keymaps.lua)
	-- --------------------------------------------------------------------------
	{
		"tpope/vim-fugitive",
		cmd = {
			"Git",
			"G",
			"Gdiffsplit",
			"Gread",
			"Gwrite",
			"Ggrep",
			"GMove",
			"GDelete",
			"GBrowse",
			"GRemove",
			"GRename",
			"Glgrep",
			"Gedit",
		},
		keys = {
			{ "<leader>a", "<cmd>Git blame<CR>", desc = "Git blame" },
			{ "<C-B>", "<cmd>Git blame<CR>", desc = "Git blame (alt)" },
		},
	},
}
