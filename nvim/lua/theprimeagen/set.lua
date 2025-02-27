--prevent recording
vim.cmd([[
  silent! unmap q
  silent! unmap Q
  silent! unmap <C-q>
]])

--tabs
vim.opt.tabstop = 4
vim.opt.softtabstop = 4
vim.opt.shiftwidth = 4
vim.opt.expandtab = true

vim.opt.smartindent = true

--search
vim.opt.hlsearch = false
vim.opt.incsearch = true
vim.opt.ignorecase = true
vim.opt.smartcase = true

--line wrapping
vim.opt.wrap = false


vim.opt.scrolloff = 8
vim.opt.signcolumn = "yes"
vim.opt.isfname:append("@-@")
vim.opt.nu = true
vim.opt.relativenumber = true

vim.opt.guicursor = "i:block-blinkwait0-blinkoff50-blinkon50"

vim.opt.termguicolors = true

--windows
vim.opt.splitright = true
vim.opt.splitbelow = true

vim.opt.updatetime = 50

vim.opt.shada = ""
vim.cmd("set shada=")
