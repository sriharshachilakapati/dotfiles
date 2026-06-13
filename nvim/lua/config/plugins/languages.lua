return {
  -- --------------------------------------------------------------------------
  -- purescript-vim: PureScript syntax, indentation, ftdetect, unicode conceal.
  -- No built-in NeoVim syntax for PureScript exists.
  -- --------------------------------------------------------------------------
  {
    "purescript-contrib/purescript-vim",
    ft = "purescript",
  },

  -- --------------------------------------------------------------------------
  -- vim-syntax-ebnf: EBNF syntax highlighting.
  -- NeoVim has no built-in EBNF syntax. egberts/vim-syntax-ebnf covers BNF,
  -- ABNF, ISO EBNF, and W3C EBNF variants. Last updated 2024.
  -- --------------------------------------------------------------------------
  {
    "egberts/vim-syntax-ebnf",
    ft = "ebnf",
  },

  -- --------------------------------------------------------------------------
  -- kotlin-vim: Kotlin syntax, indent, and ftdetect.
  -- NeoVim has no built-in Kotlin syntax. This is the canonical plugin.
  -- --------------------------------------------------------------------------
  {
    "udalov/kotlin-vim",
    ft = "kotlin",
  },

  -- --------------------------------------------------------------------------
  -- swift.vim: Swift syntax, indent, and ftdetect. macOS only.
  -- NeoVim has no built-in Swift syntax. keith/swift.vim is actively
  -- maintained (last push Sep 2025).
  -- Only loaded on macOS — Swift is not used on the Linux machine.
  -- --------------------------------------------------------------------------
  (vim.fn.has("mac") == 1) and {
    "keith/swift.vim",
    ft = "swift",
  } or nil,
}
