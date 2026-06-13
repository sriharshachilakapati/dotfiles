return {
  -- --------------------------------------------------------------------------
  -- lazydev.nvim: configures lua_ls to understand the NeoVim runtime API
  -- for every file in this config — no hardcoded paths needed.
  -- Replaces the manual workspace.library entries in .luarc.json.
  -- --------------------------------------------------------------------------
  {
    "folke/lazydev.nvim",
    ft = "lua",
    opts = {
      library = {
        -- Load the NeoVim API type definitions; luv for vim.uv.*
        { path = "${3rd}/luv/library", words = { "vim%.uv" } },
      },
    },
  },

  -- --------------------------------------------------------------------------
  -- Mason: LSP / DAP / linter / formatter installer
  -- --------------------------------------------------------------------------
  {
    "mason-org/mason.nvim",
    build = ":MasonUpdate",
    opts = { ui = { border = "rounded" } },
    config = function(_, opts)
      require("mason").setup(opts)

      -- Auto-install linters and formatters via Mason.
      -- These are not LSP servers so mason-lspconfig doesn't manage them.
      -- Installing here (after mason is set up) avoids the race condition
      -- caused by mason-null-ls triggering a concurrent install queue.
      local tools = {
        "prettierd",   -- JS/TS/JSON/CSS/HTML formatter
        "stylua",      -- Lua formatter
        "ktlint",      -- Kotlin linter/formatter
        "selene",      -- Lua linter
        "ruff",        -- Python linter
        "swiftformat", -- Swift formatter
      }
      local registry = require("mason-registry")
      registry.refresh(function()
        for _, name in ipairs(tools) do
          local pkg = registry.get_package(name)
          if not pkg:is_installed() then
            pkg:install()
          end
        end
      end)
    end,
  },

  -- --------------------------------------------------------------------------
  -- nvim-lspconfig: kept as a CONFIG DATA source only.
  -- Its lsp/*.lua files define cmd, filetypes, root_markers for each server.
  -- We no longer call require('lspconfig')[server].setup() — that API is
  -- deprecated in NeoVim 0.11+. Instead we use vim.lsp.config / vim.lsp.enable.
  -- --------------------------------------------------------------------------
  { "neovim/nvim-lspconfig", lazy = true },

  -- --------------------------------------------------------------------------
  -- mason-lspconfig: auto-installs servers and calls vim.lsp.enable() for each
  -- --------------------------------------------------------------------------
  {
    "mason-org/mason-lspconfig.nvim",
    dependencies = {
      "mason-org/mason.nvim",
      "neovim/nvim-lspconfig",
    },
    config = function()
      -- Servers managed by Mason (all platforms)
      -- sourcekit ships with Xcode and is not Mason-installable on Linux.
      local mason_servers = {
        "ts_ls",                  -- TypeScript / JavaScript
        "pyright",                -- Python
        "lua_ls",                 -- Lua
        "purescriptls",           -- PureScript
        "kotlin_language_server", -- Kotlin
        "jdtls",                  -- Java (Eclipse JDT)
        "vimls",                  -- Vimscript
      }

      require("mason-lspconfig").setup({
        ensure_installed       = mason_servers,
        automatic_installation = true,
        -- automatic_enable = true is the default in mason-lspconfig v2:
        -- it calls vim.lsp.enable() for every installed server automatically.
        automatic_enable       = true,
      })

      -- -----------------------------------------------------------------------
      -- Global LSP defaults (capabilities applied to ALL servers via wildcard).
      -- cmp_nvim_lsp extends the client capabilities so nvim-cmp gets rich
      -- completion data.  Must be set before servers start.
      -- -----------------------------------------------------------------------
      vim.lsp.config("*", {
        capabilities = require("cmp_nvim_lsp").default_capabilities(),
      })

      -- -----------------------------------------------------------------------
      -- Per-server overrides via vim.lsp.config().
      -- Only needed when the defaults provided by nvim-lspconfig's lsp/*.lua
      -- need to be extended (e.g. custom settings blocks).
      -- lua_ls settings are minimal here — lazydev.nvim handles the NeoVim
      -- runtime library injection dynamically per-file.
      -- -----------------------------------------------------------------------
      vim.lsp.config("lua_ls", {
        -- on_init runs inside NeoVim after the LSP client starts, so
        -- vim.env.VIMRUNTIME is available and resolves to the real path.
        -- This injects the NeoVim runtime library so lua_ls understands
        -- the vim.* global and all NeoVim APIs.
        on_init = function(client)
          client.config.settings.Lua = vim.tbl_deep_extend("force",
            client.config.settings.Lua or {}, {
              runtime = {
                version = "LuaJIT",
                path    = { "lua/?.lua", "lua/?/init.lua" },
              },
              workspace = {
                checkThirdParty = false,
                library = { vim.env.VIMRUNTIME },
              },
            })
        end,
        settings = {
          Lua = {
            diagnostics = { globals = { "vim" } },
            telemetry   = { enable = false },
          },
        },
      })

      -- Swift: macOS only — enable manually since it is not in mason_servers
      if vim.fn.has("mac") == 1 then
        vim.lsp.enable("sourcekit")
      end
    end,
  },

  -- --------------------------------------------------------------------------
  -- Diagnostic UI improvements
  -- --------------------------------------------------------------------------
  {
    "folke/trouble.nvim",
    dependencies = { "nvim-tree/nvim-web-devicons" },
    keys = {
      { "<leader>xx", "<cmd>Trouble diagnostics toggle<CR>",
        desc = "Toggle diagnostics" },
      { "<leader>xw", "<cmd>Trouble diagnostics toggle filter.buf=0<CR>",
        desc = "Document diagnostics" },
      { "<leader>xd", "<cmd>Trouble diagnostics toggle<CR>",
        desc = "Workspace diagnostics" },
    },
    opts = {},
  },

  -- --------------------------------------------------------------------------
  -- lspkind: VSCode-style pictograms in completion menu
  -- --------------------------------------------------------------------------
  { "onsails/lspkind.nvim", lazy = true },
}
