--Entering Normal Mode
vim.api.nvim_set_keymap('i', 'kj', '<Esc>', { noremap = true })
vim.api.nvim_set_keymap('i', 'jk', '<Esc>', { noremap = true })

--Error jumping

-- Map <leader>e to jump to the next error
vim.keymap.set("n", "<C-k>", "<cmd>cnext<CR>zz")
vim.keymap.set("n", "<C-j>", "<cmd>cprev<CR>zz")
vim.keymap.set("n", "<leader>k", "<cmd>lnext<CR>zz")
vim.keymap.set("n", "<leader>j", "<cmd>lprev<CR>zz")

-- Map <leader>q to open the quickfix list
vim.keymap.set('n', '<leader>q', ':copen<CR>', { noremap = true, silent = true })

-- Show diagnostics in a floating window
-- Show diagnostics in the command line
-- Populate loclist with all diagnostics for the current buffer
vim.api.nvim_set_keymap('n', '<leader>q', ':lua vim.diagnostic.setloclist()<CR>', { noremap = true, silent = true })

-- Show diagnostics in the command line
-- Automatically show diagnostics in a floating window on cursor hold
vim.o.updatetime = 250 -- Adjust this delay if needed

-- Show diagnostics on cursor hover after updatetime delay
vim.cmd [[autocmd CursorHold * lua vim.diagnostic.open_float(nil, { focus = false })]]



----------------------------
----------------------------
--                        --
--  The Primeagen Remaps  --
--                        --
----------------------------
----------------------------

--Set Leader Key
vim.g.mapleader = " "

--File explorer Short Cut
vim.keymap.set("n", "<leader>pv", vim.cmd.Ex)
--Appends Previous line to current line end
vim.keymap.set("n", "J", "mzJ`z")

--Moving Highlighted text with K and J Keys
vim.keymap.set("v", "J", ":m '>+1<CR>gv=gv")
vim.keymap.set("v", "K", ":m '<-2<CR>gv=gv")

--Ctrl and d and u for half page jumping with cursor still in the middle
vim.keymap.set("n", "<C-d>", "<C-d>zz")
vim.keymap.set("n", "<C-u>", "<C-u>zz")

--Search terms in the middle when using /
vim.keymap.set("n", "n", "nzzzv")
vim.keymap.set("n", "N", "Nzzzv")

--Adding to System Clipboard
vim.keymap.set({ "n", "v" }, "<leader>y", [["+y]])
vim.keymap.set("n", "<leader>Y", [["+Y]])

--Replacing Current Word In Document
vim.keymap.set("n", "<leader>r", [[:%s/\<<C-r><C-w>\>/<C-r><C-w>/gI<Left><Left><Left>]])



----------------------------
----------------------------
--                        --
--  Josean Martinez       --
--                        --
----------------------------
----------------------------



-- window management
vim.keymap.set("n", "<leader>sv", "<C-w>v")     -- split window vertically
vim.keymap.set("n", "<leader>sh", "<C-w>s")     -- split window horizontally
vim.keymap.set("n", "<leader>se", "<C-w>=")     -- make split windows equal width & height
vim.keymap.set("n", "<leader>sx", ":close<CR>") -- close current split window

-- Navigate between windows using leader key + Vim motion keys
vim.api.nvim_set_keymap('n', '<leader>h', '<C-W>h', { noremap = true, silent = true })
vim.api.nvim_set_keymap('n', '<leader>j', '<C-W>j', { noremap = true, silent = true })
vim.api.nvim_set_keymap('n', '<leader>k', '<C-W>k', { noremap = true, silent = true })
vim.api.nvim_set_keymap('n', '<leader>l', '<C-W>l', { noremap = true, silent = true })

-- tab management
vim.keymap.set("n", "<leader>to", ":tabnew<CR>")   -- open new tab
vim.keymap.set("n", "<leader>tx", ":tabclose<CR>") -- close current tab
vim.keymap.set("n", "<leader>tn", ":tabn<CR>")     --  go to next tab
vim.keymap.set("n", "<leader>tp", ":tabp<CR>")     --  go to previous tab

--Adds a full line
vim.keymap.set("x", "<leader>p", [["_dP]])
