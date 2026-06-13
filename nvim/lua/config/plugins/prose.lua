return {
  -- --------------------------------------------------------------------------
  -- goyo: distraction-free writing (kept as-is)
  -- --------------------------------------------------------------------------
  {
    "junegunn/goyo.vim",
    cmd = "Goyo",
  },

  -- --------------------------------------------------------------------------
  -- vim-pencil: soft/hard line wrapping for prose (kept as-is)
  -- --------------------------------------------------------------------------
  {
    "reedes/vim-pencil",
    ft = { "markdown", "text", "vimwiki" },
    config = function()
      vim.g["pencil#wrapModeDefault"] = "soft"
    end,
  },

  -- --------------------------------------------------------------------------
  -- vimwiki: personal wiki (kept as-is)
  -- --------------------------------------------------------------------------
  {
    "vimwiki/vimwiki",
    ft = { "markdown", "vimwiki" },
    init = function()
      -- Use the current working directory as wiki root, markdown syntax
      vim.g.vimwiki_list = {
        {
          path      = vim.fn.getcwd(),
          syntax    = "markdown",
          ext       = ".md",
        },
      }
    end,
  },

  -- --------------------------------------------------------------------------
  -- vim-markdown: enhanced markdown (kept as-is)
  -- --------------------------------------------------------------------------
  {
    "preservim/vim-markdown",
    ft = "markdown",
    dependencies = { "godlygeek/tabular" },
    init = function()
      vim.g.vim_markdown_math                  = 1
      vim.g.vim_markdown_frontmatter           = 1
      vim.g.vim_markdown_folding_disabled      = 1
      vim.g.vim_markdown_conceal               = 0
      vim.g.vim_markdown_conceal_code_blocks   = 0
      vim.g.vim_markdown_fenced_languages      = {
        "help", "c", "c++=cpp", "cpp", "java",
        "javascript", "js=javascript",
        "purescript", "purs=purescript",
        "python", "csharp", "cs=csharp",
        "html", "php",
      }
    end,
  },
}
