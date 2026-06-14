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

      -- -----------------------------------------------------------------------
      -- After Telescope confirms a selection it may hand us a buffer that was
      -- pre-loaded by the previewer.  The previewer sets `syntax` directly and
      -- may attach a treesitter highlighter — both of which are scoped to the
      -- preview window and become stale once the buffer moves to the main
      -- window.  The result is missing or broken colours.
      --
      -- This post-select hook runs (via vim.schedule, after the buffer switch)
      -- and re-applies a clean filetype on every confirmed pick:
      --   1. Clear the stale syntax value the previewer wrote.
      --   2. Re-run `filetype detect` so the full FileType autocmd chain fires,
      --      which re-sets syntax, LSP, indent rules, etc. from scratch.
      -- -----------------------------------------------------------------------
      local function fix_preview_colours()
        vim.schedule(function()
          local buf = vim.api.nvim_get_current_buf()
          if vim.bo[buf].buftype ~= "" then return end
          -- Clear the previewer's stale syntax value, then force a full
          -- FileType autocmd re-trigger (including ftplugin, commentstring,
          -- LSP, etc.) by re-setting filetype to its current value with ++force.
          vim.bo[buf].syntax = ""
          local ft = vim.bo[buf].filetype
          if ft ~= "" then
            vim.cmd("setlocal filetype=" .. ft)
          else
            vim.cmd("filetype detect")
          end
        end)
      end

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
              ["<CR>"]  = function(prompt_bufnr)
                actions.select_default(prompt_bufnr)
                fix_preview_colours()
              end,
            },
            n = {
              ["<CR>"]  = function(prompt_bufnr)
                actions.select_default(prompt_bufnr)
                fix_preview_colours()
              end,
            },
          },
          layout_config = { prompt_position = "top" },
          sorting_strategy = "ascending",
          preview = {
            -- Plenary's built-in filetype table only covers ~55 extensions, so
            -- common files (.lua, .py, .ts, .md, etc.) get no syntax in the
            -- preview pane.  This hook runs after plenary's detect() but before
            -- the async file read; if plenary returned nothing we fall back to
            -- Neovim's own vim.filetype.match() which covers every filetype
            -- Neovim ships with.
            filetype_hook = function(filepath, _, opts)
              if not opts.ft or opts.ft == "" then
                opts.ft = vim.filetype.match({ filename = filepath }) or ""
              end
              return true  -- always continue with the preview
            end,
          },
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
  -- <leader>c  → toggle line comment (normal: current line, visual: selection)
  -- --------------------------------------------------------------------------
  {
    "numToStr/Comment.nvim",
    event = { "BufReadPost", "BufNewFile" },
    opts = {
      -- Use <leader>c as the line-comment toggle in all modes.
      -- Block-comment operators are left at their defaults (gbc / gb).
      toggler  = { line = "<leader>c" },
      opleader = { line = "<leader>c" },
      -- pre_hook resolves the commentstring directly from Comment.nvim's own
      -- ft table, bypassing ft.calculate() which calls vim.treesitter.get_parser.
      -- On Neovim 0.12 without treesitter grammars installed, get_parser returns
      -- nil (without erroring), causing ft.contains(nil):lang() to crash with
      -- "[Comment.nvim] - nil".
      pre_hook = function(ctx)
        return require("Comment.ft").get(vim.bo.filetype, ctx.ctype)
      end,
    },
    config = function(_, opts)
      local comment = require("Comment")
      comment.setup(opts)

      -- Visual-mode: toggle line comments on the selected range.
      -- We must escape to normal mode first so that '< and '> marks are
      -- committed before Comment.nvim reads them.
      vim.keymap.set("x", "<leader>c", "<ESC><cmd>lua require('Comment.api').toggle.linewise(vim.fn.visualmode())<CR>",
        { silent = true, desc = "Toggle line comment" })
    end,
  },
}
