local builtin = require('telescope.builtin')
local telescope = require('telescope')

-- Configure Telescope with file_ignore_patterns and improved vimgrep_arguments
telescope.setup {
    defaults = {
        file_ignore_patterns = {
            "%.o$", "%.out$", "%.exe$", "%.class$", "%.dll$", "%.so$", "%.bin$", "%.obj$"
        },
        vimgrep_arguments = {
            "rg",
            "-L", -- Follow symlinks
            "--color=never",
            "--no-heading",
            "--with-filename",
            "--line-number",
            "--column",
            "--smart-case",
            "--glob", "!.git/*", -- Ignore .git folder
        },
        previewer = true,
        file_previewer = require 'telescope.previewers'.vim_buffer_cat.new,
        grep_previewer = require 'telescope.previewers'.vim_buffer_vimgrep.new,
        qflist_previewer = require 'telescope.previewers'.vim_buffer_qflist.new,
    },
    extensions = {
        file_browser = {
            theme = "catppuccin",
            hijack_netrw = true,
        },
    },
}

vim.keymap.set('n', '<leader>ff', builtin.find_files, {})
vim.keymap.set('n', '<C-p>', builtin.git_files, {})
vim.keymap.set('n', '<leader>ps', function()
    builtin.grep_string({ search = vim.fn.input("Grep > ") })
end)
vim.keymap.set('n', '<leader>vh', builtin.help_tags, {})
