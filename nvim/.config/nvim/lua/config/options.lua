local opt = vim.opt

-- Unset JAVA_TOOL_OPTIONS for NeoVim and all child processes it spawns
-- (LSP servers, linters, formatters). The shell keeps it for dock-icon
-- suppression; NeoVim doesn't need it and it causes "Picked up ..." noise
-- in every JVM tool output (ktlint, kotlin-language-server, jdtls, etc.).
vim.env.JAVA_TOOL_OPTIONS = nil

-- Line numbers
opt.number = true
opt.relativenumber = true

-- Indentation (default 4 spaces; languages override in autocmds)
opt.tabstop = 4
opt.shiftwidth = 4
opt.expandtab = true

-- Search
opt.ignorecase = true
opt.smartcase = true
opt.hlsearch = true
opt.incsearch = true

-- Appearance
opt.termguicolors = true
opt.cursorline = true
opt.colorcolumn = "81"
opt.signcolumn = "yes:2"    -- 2 columns: padding + gitsigns icon, prevents layout shift
opt.scrolloff = 4           -- keep context lines above/below cursor

-- Mouse
opt.mouse = "a"

-- Splits
opt.splitbelow = true
opt.splitright = true

-- History / undo
opt.history = 1000
opt.undolevels = 1000
opt.undofile = true         -- persistent undo across sessions

-- No backup/swap
opt.backup = false
opt.swapfile = false
opt.writebackup = false

-- Wild menu / completion
opt.wildignore:append({ "*.swp", "*.bak", "*.pyc", "*.class" })
opt.completeopt = { "menu", "menuone", "noselect" }  -- required for nvim-cmp

-- Update time (affects gitsigns responsiveness)
opt.updatetime = 100

-- Misc
opt.encoding = "utf-8"
opt.hidden = true           -- allow unsaved buffers in background
opt.wrap = false
opt.showmode = false        -- lualine shows the mode already
