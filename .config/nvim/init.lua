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
    'lervag/vimtex',
    'nvim-lualine/lualine.nvim', dependencies = {'kyazdani42/nvim-web-devicons' },
    {
    'hrsh7th/nvim-cmp', 
    -- load cmp on InsertEnter
    event = "InsertEnter",
    dependencies = {
	 'hrsh7th/cmp-buffer',
	 'hrsh7th/cmp-path',
     --LuaSnip
     'L3MON4D3/LuaSnip',
     'saadparwaiz1/cmp_luasnip',
	},
   },
   
    {"morhetz/gruvbox", priority = 1000 },
   
})

vim.cmd('colorscheme gruvbox')

require('lualine').setup {
  options = {
    theme = 'gruvbox'
  }
}

require ('plugins/LuaSnip')
-- Set up nvim-cmp.
vim.opt.completeopt = "menu,menuone,noselect"

require("luasnip.loaders.from_vscode").lazy_load()

local cmp = require('cmp')
local select_opts = {behavior = cmp.SelectBehavior.Select}

cmp.setup({
    snippet = {   -- REQUIRED
      expand = function(args) 
        require('luasnip').lsp_expand(args.body) 
      end,
    },

    window = {
        documentation = cmp.config.window.bordered(),
    },
        
    mapping = {
      ['<C-Space>'] = cmp.mapping.complete(),
      ['<C-e>'] = cmp.mapping.abort(),
      ['<C-y>'] = cmp.mapping.confirm({select = true}),
      ['<Tab>'] = cmp.mapping(function(fallback)
        if cmp.visible() then
          if #cmp.get_entries() == 1 then
            cmp.confirm({ select = true })
          else
            cmp.select_next_item()
          end
        else
          fallback()
        end
      end, { "i", "s" }),
        },
 
     sources = {
       { name = 'path'},
       { name = 'buffer', keyword_length = 3},
     },
})


local set = vim.opt

-- Set sections
vim.g.mapleader = " "
set.clipboard = 'unnamedplus'
set.swapfile = false
set.confirm = true
set.history = 1000
set.ignorecase = true
set.mouse = ""
set.number = true
set.expandtab = true
set.shiftwidth = 4
set.softtabstop = 4
set.tabstop = 4
set.smartcase = true
set.smartindent = true
set.smarttab = true
set.splitbelow = true
set.title = true
set.wrap = true
set.linebreak = true
set.showbreak = '▸'  -- You can change this to any character you prefer
set.breakindent = true

vim.cmd[[ 
    highlight Normal ctermbg=NONE guibg=NONE
    filetype plugin indent on
]]

vim.g.vimtex_view_method = 'zathura'
vim.g.vimtex_syntax_conceal_disable = 1
vim.g.vimtex_quickfix_open_on_warning = 0  
vim.g.vimtex_quickfix_autoclose_after_keystrokes = 10
vim.g.vimtex_imaps_enabled = 0
vim.g.vimtex_delim_stopline = 50
vim.g.vimtex_compiler_latexmk = {
  aux_dir = 'auxfiles',
  out_dir = 'pdffiles',
  options = {
        '-shell-escape',
        '-verbose',
        '-file-line-error',
        '-interaction=nonstopmode',
        '-synctex=1'
    }
}
vim.g.vimtex_quickfix_ignore_filters = {
    'LaTeX hooks Warning',
    'Underfull \\hbox',
    'Overfull \\hbox',
    'LaTeX Warning: .+ float specifier changed to',
    'Package siunitx Warning: Detected the "physics" package:',
    'Package hyperref Warning: Token not allowed in a PDF string',
    'Fatal error occurred, no output PDF file produced!',
}
vim.keymap.set('x', '<C-r>', '"hy:s/<C-r>h/')

vim.api.nvim_set_keymap('n', '<C-t>', ':tabnew<CR>', { noremap = true, silent = true })

-- Copy to clipboard
vim.api.nvim_set_keymap('v', '<leader>y', '"+y', { noremap = true })
vim.api.nvim_set_keymap('n', '<leader>Y', '"+yg_', { noremap = true })
vim.api.nvim_set_keymap('n', '<leader>Y', '"+yg_', { noremap = true })
vim.api.nvim_set_keymap('n', '<leader>y', '"+y', { noremap = true })

-- Paste from clipboard
vim.api.nvim_set_keymap('n', '<leader>p', '"+p', { noremap = true })
vim.api.nvim_set_keymap('n', '<leader>P', '"+P', { noremap = true })
vim.api.nvim_set_keymap('v', '<leader>p', '"+p', { noremap = true })
vim.api.nvim_set_keymap('v', '<leader>P', '"+P', { noremap = true })

