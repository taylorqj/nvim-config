local ok, cc = pcall(require, "claudecode")
if not ok then return end

cc.setup({
  -- If `which claude` points to a local install (see below), set:
  -- terminal_cmd = "~/.claude/local/claude",
  -- Other useful opts:
  -- log_level = "info", -- "trace","debug","info","warn","error"
  terminal = {
    provider = "auto",
    snacks_win_opts = {
      keys = {
        nav_left = { "<C-w>h", function(self) vim.cmd("wincmd h") end, mode = "t", desc = "Move to left window" },
        nav_down = { "<C-w>j", function(self) vim.cmd("wincmd j") end, mode = "t", desc = "Move to below window" },
        nav_up = { "<C-w>k", function(self) vim.cmd("wincmd k") end, mode = "t", desc = "Move to above window" },
        nav_right = { "<C-w>l", function(self) vim.cmd("wincmd l") end, mode = "t", desc = "Move to right window" },
      },
    },
  },
})

-- Keymaps (mirrors README defaults)
vim.keymap.set("n", "<leader>ac", "<cmd>ClaudeCode<cr>",            { desc = "Claude: toggle" })
vim.keymap.set("n", "<leader>af", "<cmd>ClaudeCodeFocus<cr>",       { desc = "Claude: focus" })
vim.keymap.set("n", "<leader>ar", "<cmd>ClaudeCode --resume<cr>",   { desc = "Claude: resume" })
vim.keymap.set("n", "<leader>aC", "<cmd>ClaudeCode --continue<cr>", { desc = "Claude: continue" })
vim.keymap.set("n", "<leader>am", "<cmd>ClaudeCodeSelectModel<cr>", { desc = "Claude: select model" })
vim.keymap.set("n", "<leader>ab", "<cmd>ClaudeCodeAdd %<cr>",       { desc = "Claude: add current buffer" })
vim.keymap.set("v", "<leader>as", "<cmd>ClaudeCodeSend<cr>",        { desc = "Claude: send selection" })
vim.keymap.set("n", "<leader>aa", "<cmd>ClaudeCodeDiffAccept<cr>",  { desc = "Claude: accept diff" })
vim.keymap.set("n", "<leader>ad", "<cmd>ClaudeCodeDiffDeny<cr>",    { desc = "Claude: deny diff" })

-- Cursor agent integrations
vim.keymap.set("n", "<leader>ag", "<cmd>CursorAgent code-reviewer<cr>", { desc = "Cursor: code reviewer agent" })
vim.keymap.set("n", "<leader>ap", function()
  local pr = vim.fn.input("PR number or URL: ")
  if pr ~= "" then
    vim.cmd("CursorReviewPR " .. pr)
  end
end, { desc = "Cursor: review PR" })
