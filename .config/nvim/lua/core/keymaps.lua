M = {}
local opts = { noremap = true, silent = true }

local term_opts = { silent = true }

-- Shorten function name
local keymap = vim.keymap.set

-- Remap space as leader key
keymap("", "<Space>", "<Nop>", opts)
keymap('x', '<C-r>', '"hy:s/<C-r>h/')

vim.g.mapleader = " "


