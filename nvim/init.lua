-- VS Code NeoVim: load shared options + keymaps only, no plugins.
if vim.g.vscode then
  require("config.vscode")
  return
end

-- Bootstrap lazy.nvim
local lazypath = vim.fn.stdpath("data") .. "/lazy/lazy.nvim"
if not vim.loop.fs_stat(lazypath) then
  vim.fn.system({
    "git",
    "clone",
    "--filter=blob:none",
    "https://github.com/folke/lazy.nvim.git",
    "--branch=stable",
    lazypath,
  })
end
vim.opt.rtp:prepend(lazypath)

-- Set <leader> before lazy so mappings are correct
vim.g.mapleader = "\\"
vim.g.maplocalleader = "\\"

-- Load core config
require("config.options")
require("config.keymaps")
require("config.autocmds")

-- Load plugins via lazy.nvim
require("lazy").setup({
  { import = "config.plugins.ui" },
  { import = "config.plugins.editor" },
  { import = "config.plugins.git" },
  { import = "config.plugins.treesitter" },
  { import = "config.plugins.lsp" },
  { import = "config.plugins.completion" },
  { import = "config.plugins.linting" },
  { import = "config.plugins.prose" },
  { import = "config.plugins.languages" },
}, {
  change_detection = { notify = false },
  ui = { border = "rounded" },
})
