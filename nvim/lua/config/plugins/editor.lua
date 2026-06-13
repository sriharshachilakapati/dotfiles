return {
  -- --------------------------------------------------------------------------
  -- Telescope: fuzzy finder (replaces fzf + fzf.vim)
  -- <C-P>     find_files  → rg --files (respects .gitignore, fast) + fzf-native
  -- <C-S-F>   live_grep   → ag (Silver Searcher, content search across files)
  -- --------------------------------------------------------------------------
  {
    "nvim-telescope/telescope.nvim",
    branch = "0.1.x",
    dependencies = {
      "nvim-lua/plenary.nvim",
      { "nvim-telescope/telescope-fzf-native.nvim", build = "make" },
    },
    cmd = "Telescope",
    keys = {
      { "<C-P>",   "<cmd>Telescope find_files<CR>",  desc = "Find files" },
      { "<C-S-F>", "<cmd>Telescope live_grep<CR>",   desc = "Live grep (ag)" },
    },
    config = function()
      local telescope = require("telescope")
      local actions   = require("telescope.actions")

      telescope.setup({
        defaults = {
          -- Silver Searcher for live_grep (<C-S-F>)
          vimgrep_arguments = {
            "ag",
            "--nocolor",
            "--noheading",
            "--numbers",
            "--column",
            "--smart-case",
            "--nobreak",
          },
          mappings = {
            i = {
              ["<C-j>"] = actions.move_selection_next,
              ["<C-k>"] = actions.move_selection_previous,
              ["<esc>"] = actions.close,
            },
          },
          layout_config = { prompt_position = "top" },
          sorting_strategy = "ascending",
        },
        pickers = {
          find_files = {
            -- rg --files respects .gitignore so build/, .gradle/, node_modules/
            -- etc. are excluded automatically. Use --hidden to still show
            -- dotfiles like .env while skipping ignored paths.
            find_command = { "rg", "--files", "--hidden", "--glob", "!**/.git/*" },
          },
        },
      })

      telescope.load_extension("fzf")
    end,
  },

  -- --------------------------------------------------------------------------
  -- Neo-tree: file explorer (replaces NERDTree)
  -- --------------------------------------------------------------------------
  {
    "nvim-neo-tree/neo-tree.nvim",
    branch = "v3.x",
    dependencies = {
      "nvim-lua/plenary.nvim",
      "nvim-tree/nvim-web-devicons",
      "MunifTanjim/nui.nvim",
    },
    keys = {
      { "<C-n>", "<cmd>Neotree toggle<CR>", desc = "Toggle file tree" },
    },
    opts = {
      popup_border_style = "rounded",
      default_component_configs = {
        git_status = {
          symbols = {
            added     = "󰐕",  -- nf-md-plus_circle       (new file tracked)
            modified  = "󰏫",  -- nf-md-pencil            (file edited)
            deleted   = "󰍴",  -- nf-md-minus_circle      (file removed)
            renamed   = "󰁔",  -- nf-md-arrow_right_bold  (file moved/renamed)
            untracked = "󰘎",  -- nf-md-help_circle       (not yet tracked)
            ignored   = "󰈉",  -- nf-md-file_hidden       (gitignored)
            unstaged  = "󰀪",  -- nf-md-alert_circle      (changed, not staged)
            staged    = "󰄬",  -- nf-md-check             (staged for commit)
            conflict  = "󰀧",  -- nf-md-alert             (merge conflict)
          },
        },
      },
      filesystem = {
        filtered_items = {
          hide_dotfiles   = false,
          hide_gitignored = false,
          -- Always show untracked files — never hide them
          never_show = {},
        },
        follow_current_file = { enabled = true },
      },
      window = {
        width = 30,
        border = "rounded",
      },
    },
  },

  -- --------------------------------------------------------------------------
  -- bufdelete: kill buffer without closing the split (replaces vim-bufkill)
  -- Mapped to `x` in keymaps.lua via :Bdelete
  -- --------------------------------------------------------------------------
  {
    "famiu/bufdelete.nvim",
    keys = {
      { "x", "<cmd>Bdelete<CR>", desc = "Kill buffer (keep split)" },
    },
  },

  -- --------------------------------------------------------------------------
  -- vim-zoom: zoom/unzoom pane (kept as-is, still works in NeoVim)
  -- --------------------------------------------------------------------------
  { "dhruvasagar/vim-zoom" },

  -- --------------------------------------------------------------------------
  -- vim-windowswap: swap split contents (kept as-is, still works in NeoVim)
  -- --------------------------------------------------------------------------
  { "wesQ3/vim-windowswap" },

  -- --------------------------------------------------------------------------
  -- neoscroll: smooth scrolling (replaces comfortable-motion.vim)
  -- --------------------------------------------------------------------------
  {
    "karb94/neoscroll.nvim",
    event = "VeryLazy",
    opts = {
      mappings = { "<C-u>", "<C-d>", "<C-b>", "<C-f>", "<C-y>", "<C-e>", "zt", "zz", "zb" },
      hide_cursor = true,
      stop_eof = true,
      easing_function = "sine",
    },
  },

  -- --------------------------------------------------------------------------
  -- Comment.nvim: smart commenting (replaces nerdcommenter)
  -- --------------------------------------------------------------------------
  {
    "numToStr/Comment.nvim",
    event = { "BufReadPost", "BufNewFile" },
    opts = {},
  },
}
