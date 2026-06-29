local keymap = vim.keymap.set

local function toggle_quickfix()
  local qf_open = false
  for _, w in ipairs(vim.fn.getwininfo()) do
    if w.quickfix == 1 then
      qf_open = true
      break
    end
  end

  vim.cmd(qf_open and "cclose" or "copen")
end

keymap("n", "<F2>", toggle_quickfix, { silent = true })

keymap("n", "<Leader>f", function()
  require("fzf-lua").files()
end, { silent = true })

keymap("n", "<Leader>b", function()
  require("fzf-lua").buffers()
end, { silent = true })

keymap("n", "<Leader>l", function()
  require("fzf-lua").lines()
end, { silent = true })

keymap("n", "<Leader>o", function()
  require("fzf-lua").oldfiles()
end, { silent = true })

keymap("n", "<leader>e", vim.diagnostic.open_float)
