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
  {   "morhetz/gruvbox", 
      priority = 1000 
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

-- appearance
{
    'nvim-lualine/lualine.nvim', 
    dependencies = 'kyazdani42/nvim-web-devicons',
},


-- tex
{
    'lervag/vimtex',
    ft = "tex",
},
{
    'dense-analysis/ale',
    config = function()
        -- Configuration goes here.
        local g = vim.g

        g.ale_ruby_rubocop_auto_correct_all = 1

        g.ale_linters = {
            ruby = {'rubocop', 'ruby'},
            lua = {'lua_language_server'},
            tex = {'lacheck'},
        }
    end
}
})
