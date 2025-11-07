local M = {}

local config_dir = vim.fn.expand("~/.config/cursor")
local agents_dir = config_dir .. "/agents"
local commands_dir = config_dir .. "/commands"

-- Parse frontmatter from markdown files
local function parse_frontmatter(content)
  local frontmatter = {}
  local body_start = 1
  
  if content:match("^---\n") then
    local end_marker = content:find("\n---\n", 1, true)
    if end_marker then
      local frontmatter_text = content:sub(1, end_marker + 4)
      body_start = end_marker + 5
      
      -- Extract key-value pairs from frontmatter
      for line in frontmatter_text:gmatch("[^\n]+") do
        if line ~= "---" then
          local key, value = line:match("^([^:]+):%s*(.+)$")
          if key and value then
            frontmatter[key:gsub("^%s*(.-)%s*$", "%1")] = value:gsub("^%s*(.-)%s*$", "%1")
          end
        end
      end
    end
  end
  
  local body = content:sub(body_start):gsub("^%s+", ""):gsub("%s+$", "")
  return frontmatter, body
end

-- Load agent config
function M.load_agent(agent_name)
  local agent_file = agents_dir .. "/" .. agent_name .. ".md"
  if vim.fn.filereadable(agent_file) == 0 then
    vim.notify("Agent not found: " .. agent_name, vim.log.levels.ERROR)
    return nil, nil
  end
  
  local content = vim.fn.readfile(agent_file)
  if #content == 0 then
    return nil, nil
  end
  
  local full_content = table.concat(content, "\n")
  local frontmatter, body = parse_frontmatter(full_content)
  
  return frontmatter, body
end

-- Load command config
function M.load_command(command_name)
  local command_file = commands_dir .. "/" .. command_name .. ".md"
  if vim.fn.filereadable(command_file) == 0 then
    vim.notify("Command not found: " .. command_name, vim.log.levels.ERROR)
    return nil, nil
  end
  
  local content = vim.fn.readfile(command_file)
  if #content == 0 then
    return nil, nil
  end
  
  local full_content = table.concat(content, "\n")
  local frontmatter, body = parse_frontmatter(full_content)
  
  return frontmatter, body
end

-- List available agents
function M.list_agents()
  local agents = {}
  if vim.fn.isdirectory(agents_dir) == 0 then
    return agents
  end
  
  local files = vim.fn.glob(agents_dir .. "/*.md", false, true)
  for _, file in ipairs(files) do
    local name = vim.fn.fnamemodify(file, ":t:r")
    table.insert(agents, name)
  end
  
  return agents
end

-- Use an agent with ClaudeCode
function M.use_agent(agent_name, additional_context)
  local ok, cc = pcall(require, "claudecode")
  if not ok then
    vim.notify("claudecode.nvim not available", vim.log.levels.ERROR)
    return
  end
  
  local frontmatter, body = M.load_agent(agent_name)
  if not body then
    return
  end
  
  -- Build prompt with agent instructions
  local prompt = body
  if additional_context then
    prompt = prompt .. "\n\n" .. additional_context
  end
  
  -- Store prompt in special register and clipboard
  vim.fn.setreg("+", prompt)
  vim.fn.setreg("*", prompt)
  
  -- Create a temp buffer with the prompt for easy reference
  local buf = vim.api.nvim_create_buf(false, true)
  vim.api.nvim_buf_set_name(buf, "cursor-agent-" .. agent_name)
  vim.api.nvim_buf_set_option(buf, "buftype", "nofile")
  vim.api.nvim_buf_set_option(buf, "filetype", "markdown")
  vim.api.nvim_buf_set_lines(buf, 0, -1, false, vim.split(prompt, "\n"))
  
  -- Open in a split
  vim.cmd("split")
  vim.api.nvim_set_current_buf(buf)
  vim.cmd("wincmd p")
  
  -- Start ClaudeCode
  vim.cmd("ClaudeCode")
  
  vim.notify("Agent '" .. agent_name .. "' prompt ready. Prompt in clipboard and shown in split above.", vim.log.levels.INFO)
end

-- Review PR command
function M.review_pr(pr_identifier)
  local ok, cc = pcall(require, "claudecode")
  if not ok then
    vim.notify("claudecode.nvim not available", vim.log.levels.ERROR)
    return
  end
  
  local frontmatter, body = M.load_command("review-pr")
  if not body then
    return
  end
  
  -- Execute gh commands to get PR info
  local pr_view_cmd = "gh pr view " .. pr_identifier .. " --json title,body,author,state,url"
  local pr_diff_cmd = "gh pr diff " .. pr_identifier
  
  vim.notify("Fetching PR information...", vim.log.levels.INFO)
  
  -- Run commands and get output
  local pr_view_output = vim.fn.system(pr_view_cmd)
  if vim.v.shell_error ~= 0 then
    vim.notify("Failed to fetch PR details. Make sure 'gh' CLI is installed and authenticated.", vim.log.levels.ERROR)
    return
  end
  
  local pr_diff_output = vim.fn.system(pr_diff_cmd)
  if vim.v.shell_error ~= 0 then
    vim.notify("Failed to fetch PR diff. Make sure 'gh' CLI is installed and authenticated.", vim.log.levels.ERROR)
    return
  end
  
  -- Parse JSON (simple parsing for this use case)
  local pr_data = vim.fn.json_decode(pr_view_output)
  
  -- Build comprehensive prompt
  local prompt = body .. "\n\n"
  prompt = prompt .. "PR Details:\n"
  prompt = prompt .. "Title: " .. (pr_data.title or "N/A") .. "\n"
  prompt = prompt .. "Author: " .. (pr_data.author.login or "N/A") .. "\n"
  prompt = prompt .. "State: " .. (pr_data.state or "N/A") .. "\n"
  prompt = prompt .. "URL: " .. (pr_data.url or "N/A") .. "\n\n"
  prompt = prompt .. "PR Description:\n" .. (pr_data.body or "N/A") .. "\n\n"
  prompt = prompt .. "=== PR DIFF ===\n\n"
  prompt = prompt .. pr_diff_output
  
  -- Store prompt in registers and create temp buffer
  vim.fn.setreg("+", prompt)
  vim.fn.setreg("*", prompt)
  
  local buf = vim.api.nvim_create_buf(false, true)
  vim.api.nvim_buf_set_name(buf, "cursor-pr-review")
  vim.api.nvim_buf_set_option(buf, "buftype", "nofile")
  vim.api.nvim_buf_set_option(buf, "filetype", "markdown")
  vim.api.nvim_buf_set_lines(buf, 0, -1, false, vim.split(prompt, "\n"))
  
  -- Open in a split
  vim.cmd("split")
  vim.api.nvim_set_current_buf(buf)
  vim.cmd("wincmd p")
  
  -- Start ClaudeCode
  vim.cmd("ClaudeCode")
  
  vim.notify("PR review prompt ready. Prompt in clipboard and shown in split above.", vim.log.levels.INFO)
end

-- Create user commands
function M.setup()
  -- Command to use an agent
  vim.api.nvim_create_user_command("CursorAgent", function(opts)
    local agent_name = opts.args
    if agent_name == "" then
      -- List available agents
      local agents = M.list_agents()
      if #agents == 0 then
        vim.notify("No agents found", vim.log.levels.WARN)
        return
      end
      vim.notify("Available agents: " .. table.concat(agents, ", "), vim.log.levels.INFO)
      return
    end
    M.use_agent(agent_name)
  end, {
    nargs = "?",
    complete = function()
      return M.list_agents()
    end,
    desc = "Use a Cursor agent (e.g., :CursorAgent code-reviewer)"
  })
  
  -- Command to review PR
  vim.api.nvim_create_user_command("CursorReviewPR", function(opts)
    local pr_identifier = opts.args
    if pr_identifier == "" then
      vim.notify("Usage: :CursorReviewPR <pr-number-or-url>", vim.log.levels.ERROR)
      return
    end
    M.review_pr(pr_identifier)
  end, {
    nargs = 1,
    desc = "Review a GitHub PR using code-reviewer agent"
  })
  
end

return M
