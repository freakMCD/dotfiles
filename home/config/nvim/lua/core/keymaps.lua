M = {}
local opts = { noremap = true, silent = true }

local term_opts = { silent = true }

-- Shorten function name
local keymap = vim.keymap.set

local function toggle_quickfix()
    local quickfix_open = false
    for _, win in ipairs(vim.fn.getwininfo()) do
        if win.quickfix == 1 then
            quickfix_open = true
            break
        end
    end

    if quickfix_open then
        vim.cmd("cclose")
    else
        vim.cmd("copen")
    end
end


-- Remap space as leader key
keymap("", "<Space>", "<Nop>", opts)
keymap('x', '<C-r>', '"hy:s/<C-r>h/')

keymap("n", "<F2>", toggle_quickfix, { silent = true })


vim.g.mapleader = " "



local function swap_substrings_in_range(opts)
  local sub1 = vim.fn.input("Enter first substring: ")
  local sub2 = vim.fn.input("Enter second substring: ")

  if sub1 == "" or sub2 == "" then
    print("Both substrings must be provided!")
    return
  end

  -- Create a unique placeholder that is unlikely to occur in your file.
  local placeholder = ("__SWAP_PLACEHOLDER_%d_%d__"):format(os.time(), math.random(10000))

  local buf = vim.api.nvim_get_current_buf()
  -- Convert the command’s 1-indexed range to 0-indexed for the API.
  local start_line = opts.line1 - 1
  local end_line = opts.line2  -- nvim_buf_get_lines uses an end-exclusive index

  -- Get the lines from the given range.
  local lines = vim.api.nvim_buf_get_lines(buf, start_line, end_line, false)

  -- Escape the substrings so that any special characters are taken literally.
  local pat1 = vim.pesc(sub1)
  local pat2 = vim.pesc(sub2)

  for i, line in ipairs(lines) do
    -- Replace occurrences of string1 with string2
    line = line:gsub(pat1, placeholder)
    line = line:gsub(pat2, sub1)
    line = line:gsub(placeholder, sub2)
    lines[i] = line
  end

  vim.api.nvim_buf_set_lines(buf, start_line, end_line, false, lines)
end

vim.api.nvim_create_user_command("SwapSubstrings", swap_substrings_in_range, { range = true })

