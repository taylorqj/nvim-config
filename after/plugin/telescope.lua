local builtin = require('telescope.builtin')
local telescope = require('telescope')
local telescope_ag = require('telescope-ag')

telescope_ag.setup({
    cmd = telescope_ag.cmds.rg
})

telescope.load_extension("ag")

vim.keymap.set('n', '<leader>pf', builtin.find_files, {})
vim.keymap.set('n', '<leader>pb', builtin.buffers, {})
vim.keymap.set('n', '<leader>ph', builtin.help_tags, {})

vim.keymap.set('n', '<C-p>', builtin.git_files, {})
vim.keymap.set('n', '<leader>ps', function()
    builtin.grep_string({ search = vim.fn.input("Grep > ") });
end)
