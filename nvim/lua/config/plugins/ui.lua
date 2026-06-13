return {
	-- --------------------------------------------------------------------------
	-- Colorscheme: ayu (dark)
	-- --------------------------------------------------------------------------
	{
		"Shatur/neovim-ayu",
		lazy = false,
		priority = 1000, -- load before everything else
		config = function()
		require("ayu").setup({
			mirage = false, -- false = dark variant
			overrides = {
				-- Give the Neo-tree split border a visible accent so it stands
				-- out from the editor pane. Ayu-dark's UI accent is #E6B450
				-- (orange); using a muted version keeps it subtle but clear.
				NeoTreeWinSeparator = { fg = "#3d4752", bg = "#0F131A" },
				NeoTreeNormal       = { bg = "#0F131A" },
				NeoTreeNormalNC     = { bg = "#0F131A" },
			},
		})
			vim.cmd("colorscheme ayu-dark")
		end,
	},

	-- --------------------------------------------------------------------------
	-- Statusline: lualine (replaces vim-airline)
	-- 'dark' theme with powerline_fonts=1: bold mode section with accent color,
	-- muted middle sections, Powerline chevron separators.
	-- --------------------------------------------------------------------------
	{
		"nvim-lualine/lualine.nvim",
		dependencies = { "nvim-tree/nvim-web-devicons" },
		event = "VeryLazy",
		config = function()
			require("lualine").setup({
				options = {
					theme = "ayu_dark",
					icons_enabled = true,
					globalstatus = false,
				},
				sections = {
					lualine_a = { "mode" },
					lualine_b = { "branch", "diff", "diagnostics" },
					lualine_c = { { "filename", path = 1 } },
					lualine_x = { "encoding", "fileformat", "filetype" },
					lualine_y = { "progress" },
					lualine_z = { "location" },
				},
				-- Tabline: buffer names fill the bar (neutral, like airline).
				-- Tabs appear on the right only when more than one tab is open.
				tabline = {
					lualine_a = { "buffers" },
					lualine_z = { "tabs" },
				},
				extensions = { "neo-tree", "fugitive", "lazy" },
			})
		end,
	},

	-- --------------------------------------------------------------------------
	-- Icons (shared dependency for lualine, neo-tree, trouble, telescope)
	-- --------------------------------------------------------------------------
	{ "nvim-tree/nvim-web-devicons", lazy = true },

	-- --------------------------------------------------------------------------
	-- Indent guides: indent-blankline (replaces indentLine)
	-- --------------------------------------------------------------------------
	{
		"lukas-reineke/indent-blankline.nvim",
		main = "ibl",
		event = { "BufReadPost", "BufNewFile" },
		opts = {
			indent = {
				char = "│",
			},
			scope = {
				enabled = true,
				show_start = false,
				show_end = false,
			},
		},
	},
}
