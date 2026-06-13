-- Treesitter is intentionally not used in this config.
--
-- NeoVim 0.12 ships built-in regex-based syntax for 600+ languages which
-- covers all languages in this workflow (JSON, XML, Java, JavaScript,
-- TypeScript, Python, Lua, plain text). Kotlin and Swift, which have no
-- built-in syntax, are handled by individual plugins in languages.lua.
--
-- nvim-treesitter was removed because:
--   • The GitHub repository is archived (read-only as of April 2026)
--   • The main branch requires the tree-sitter-cli binary to compile parsers
--   • vim-polyglot was also considered but is similarly unmaintained
--     (no code commit since 2022, actively conflicts with NeoVim's own ftdetect)
--
-- If treesitter is reconsidered in the future, NeoVim 0.12's native
-- vim.treesitter API can be used directly with manually placed parser .so
-- files, without any plugin.

return {}
