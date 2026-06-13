return {
  -- --------------------------------------------------------------------------
  -- nvim-cmp: completion engine (replaces deoplete + echodoc + float-preview)
  -- --------------------------------------------------------------------------
  {
    "hrsh7th/nvim-cmp",
    event = "InsertEnter",
    dependencies = {
      -- Snippet engine
      "L3MON4D3/LuaSnip",
      "saadparwaiz1/cmp_luasnip",

      -- LSP completion source
      "hrsh7th/cmp-nvim-lsp",

      -- Additional sources
      "hrsh7th/cmp-buffer",    -- words from current buffer
      "hrsh7th/cmp-path",      -- filesystem paths
      "hrsh7th/cmp-cmdline",   -- : command line completion

      -- Friendly snippet collection
      "rafamadriz/friendly-snippets",

      -- VSCode-style icons in the menu
      "onsails/lspkind.nvim",
    },
    config = function()
      local cmp     = require("cmp")
      local luasnip = require("luasnip")
      local lspkind = require("lspkind")

      -- Load friendly-snippets
      require("luasnip.loaders.from_vscode").lazy_load()

      cmp.setup({
        snippet = {
          expand = function(args)
            luasnip.lsp_expand(args.body)
          end,
        },

        window = {
          completion    = cmp.config.window.bordered(),
          documentation = cmp.config.window.bordered(),
        },

        formatting = {
          format = lspkind.cmp_format({
            mode   = "symbol_text",
            maxwidth = 50,
            ellipsis_char = "...",
          }),
        },

        mapping = cmp.mapping.preset.insert({
          ["<C-Space>"] = cmp.mapping.complete(),
          ["<C-e>"]     = cmp.mapping.abort(),
          ["<CR>"]      = cmp.mapping.confirm({ select = false }),

          -- Tab: cycle through completions or jump snippet placeholders
          ["<Tab>"] = cmp.mapping(function(fallback)
            if cmp.visible() then
              cmp.select_next_item()
            elseif luasnip.expand_or_jumpable() then
              luasnip.expand_or_jump()
            else
              fallback()
            end
          end, { "i", "s" }),

          ["<S-Tab>"] = cmp.mapping(function(fallback)
            if cmp.visible() then
              cmp.select_prev_item()
            elseif luasnip.jumpable(-1) then
              luasnip.jump(-1)
            else
              fallback()
            end
          end, { "i", "s" }),

          ["<C-j>"] = cmp.mapping.select_next_item(),
          ["<C-k>"] = cmp.mapping.select_prev_item(),
          ["<C-d>"] = cmp.mapping.scroll_docs(4),
          ["<C-u>"] = cmp.mapping.scroll_docs(-4),
        }),

        sources = cmp.config.sources({
          { name = "nvim_lsp" },
          { name = "luasnip" },
          { name = "path" },
        }, {
          { name = "buffer", keyword_length = 3 },
        }),
      })

      -- Cmdline completion for search
      cmp.setup.cmdline({ "/", "?" }, {
        mapping = cmp.mapping.preset.cmdline(),
        sources = { { name = "buffer" } },
      })

      -- Cmdline completion for ":"
      cmp.setup.cmdline(":", {
        mapping = cmp.mapping.preset.cmdline(),
        sources = cmp.config.sources(
          { { name = "path" } },
          { { name = "cmdline" } }
        ),
      })
    end,
  },

  -- --------------------------------------------------------------------------
  -- LuaSnip: snippet engine
  -- --------------------------------------------------------------------------
  {
    "L3MON4D3/LuaSnip",
    build = "make install_jsregexp",
    lazy = true,
  },
}
