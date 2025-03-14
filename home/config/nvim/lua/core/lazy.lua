-- Install lazy.nvim automatically
local lazypath = vim.fn.stdpath("data") .. "/lazy/lazy.nvim"
if not vim.loop.fs_stat(lazypath) then
  vim.fn.system({
    "git",
    "clone",
    "--filter=blob:none",
    "https://github.com/folke/lazy.nvim.git",
    "--branch=stable", -- latest stable release
    lazypath,
  })
end
vim.opt.rtp:prepend(lazypath)

require("lazy").setup({
{
   "nvim-treesitter/nvim-treesitter",
    build = ":TSUpdate",
    config = function () 
      local configs = require("nvim-treesitter.configs")

      configs.setup({
          ensure_installed = { "c", "lua", "html", "css", "fish", "bash", "python", "nix" },
          sync_install = false,
          highlight = { enable = true },
          indent = { enable = false },  
        })
	end
},
{ "ellisonleao/gruvbox.nvim", priority = 1000 , config = true} ,
{
  "ibhagwan/fzf-lua",
  dependencies = { "nvim-tree/nvim-web-devicons" },
  opts = {}
},

  {
  'hrsh7th/nvim-cmp', 
  -- load cmp on InsertEnter
  event = "InsertEnter",
  dependencies = {
 'hrsh7th/cmp-buffer',
 'hrsh7th/cmp-path',
   --LuaSnip
   'saadparwaiz1/cmp_luasnip',
   'L3MON4D3/LuaSnip',
  },
},

  'neovim/nvim-lspconfig',
  'hrsh7th/cmp-nvim-lsp', -- LSP source for nvim-cmp,  

-- tex
{ 'lervag/vimtex', ft = "tex" },
{
    'dense-analysis/ale',
    config = function()
        -- Configuration goes here.
        local g = vim.g

        g.ale_linters = {
            lua = {'lua_language_server'},
            tex = {'lacheck'},
        }
    end
}
})

require("fzf-lua").setup{
  files = {
    fd_opts = [[--color=always -t f  . /mnt/DATA ~/nix ]],
    fzf_opts = {  
      ["--delimiter"] = "/";
      ["--with-nth"] = "4..";
    },
  },
}

vim.g.mapleader = " "
vim.api.nvim_set_keymap('n', '<Leader>f', "<cmd>lua require('fzf-lua').files()<CR>", { noremap = true, silent = true })
vim.api.nvim_set_keymap('n', '<Leader>b', "<cmd>lua require('fzf-lua').buffers()<CR>", { noremap = true, silent = true })
vim.api.nvim_set_keymap('n', '<Leader>l', "<cmd>lua require('fzf-lua').lines()<CR>", { noremap = true, silent = true })


require("gruvbox").setup({
  italic = {
    strings = false,
    emphasis = true,
    comments = true,
    operators = false,
    folds = true,
  },
  strikethrough = true,
  invert_selection = false,
  invert_signs = false,
  invert_tabline = false,
  invert_intend_guides = false,
  inverse = true, -- invert background for search, diffs, statuslines and errors
  contrast = "hard", -- can be "hard", "soft" or empty string
})
vim.cmd[[ 
    colorscheme gruvbox
    highlight Normal ctermbg=NONE guibg=NONE
]]
vim.api.nvim_set_hl(0, "StatusLine", { bg = 'NvimDarkGray1', bold = true })
vim.api.nvim_set_hl(0, "StatusLineNC", { bg = 'NvimDarkGray2' })
