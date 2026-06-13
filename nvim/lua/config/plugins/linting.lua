return {
  -- --------------------------------------------------------------------------
  -- nvim-lint: async linting
  -- --------------------------------------------------------------------------
  {
    "mfussenegger/nvim-lint",
    event = { "BufReadPost", "BufNewFile", "BufWritePost" },
    config = function()
      local lint = require("lint")

      lint.linters_by_ft = {
        -- JS/TS linting handled by ts_ls LSP; no standalone linter needed
        python = { "ruff" },
        kotlin = { "ktlint" },
        lua    = { "selene" },
      }

      -- selene uses stdin mode so it can't walk up from the file path to find
      -- selene.toml. Explicitly point it at the config in stdpath("config").
      local selene = lint.linters.selene
      selene.args = {
        "--display-style", "json",
        "--config", vim.fn.stdpath("config") .. "/selene.toml",
        "-",
      }

      -- Trigger linting on save and when leaving insert mode
      local lint_augroup = vim.api.nvim_create_augroup("NvimLint", { clear = true })
      vim.api.nvim_create_autocmd({ "BufWritePost", "InsertLeave", "BufReadPost" }, {
        group = lint_augroup,
        callback = function() lint.try_lint() end,
      })
    end,
  },

  -- --------------------------------------------------------------------------
  -- none-ls: formatting via LSP interface
  -- --------------------------------------------------------------------------
  {
    "nvimtools/none-ls.nvim",
    dependencies = { "nvim-lua/plenary.nvim" },
    event = { "BufReadPost", "BufNewFile" },
    config = function()
      local null_ls = require("null-ls")
      local fmt     = null_ls.builtins.formatting

      local sources = {
        fmt.stylua,    -- Lua
        fmt.ktlint,    -- Kotlin
        fmt.prettierd, -- JS/TS/JSON/CSS/HTML
      }

      if vim.fn.has("mac") == 1 then
        table.insert(sources, fmt.swiftformat)
      end

      null_ls.setup({
        sources = sources,
        on_attach = function(client, bufnr)
          if client:supports_method("textDocument/formatting") then
            local fmt_augroup = vim.api.nvim_create_augroup("LspFormatting_" .. bufnr, { clear = true })
            vim.api.nvim_create_autocmd("BufWritePre", {
              group    = fmt_augroup,
              buffer   = bufnr,
              callback = function()
                vim.lsp.buf.format({ bufnr = bufnr, timeout_ms = 3000 })
              end,
            })
          end
        end,
      })
    end,
  },
}
