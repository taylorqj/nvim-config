-- Configure which-key groups for better organization
local wk = require("which-key")

-- Define leader key groups
wk.add({
    { "<leader>p", group = "Telescope/Project" },
    { "<leader>h", group = "Git Hunks" },
    { "<leader>t", group = "Toggle" },
    { "<leader>v", group = "LSP/View" },
})

-- Show buffer local keymaps
vim.keymap.set("n", "<leader>?", function()
    require("which-key").show({ global = false })
end, { desc = "Buffer Local Keymaps (which-key)" })
