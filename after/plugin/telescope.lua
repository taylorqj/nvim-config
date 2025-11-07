local builtin = require('telescope.builtin')

-- File finding
vim.keymap.set('n', '<leader>pf', builtin.find_files, { desc = 'Find Files' })
vim.keymap.set('n', '<C-p>', builtin.git_files, { desc = 'Git Files' })
vim.keymap.set('n', '<leader>pb', builtin.buffers, { desc = 'Buffers' })
vim.keymap.set('n', '<leader>ph', builtin.help_tags, { desc = 'Help Tags' })

-- Search/grep
vim.keymap.set('n', '<leader>ps', builtin.live_grep, { desc = 'Live grep' })
vim.keymap.set('n', '<leader>pg', builtin.live_grep, { desc = 'Live grep' })
vim.keymap.set('n', '<leader>pw', builtin.grep_string, { desc = 'Grep word under cursor' })
