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


