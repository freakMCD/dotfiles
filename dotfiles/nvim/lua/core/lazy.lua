-- Bootstrap lazy.nvim
local lazypath = vim.fn.stdpath("data") .. "/lazy/lazy.nvim"
if not (vim.uv or vim.loop).fs_stat(lazypath) then
  local lazyrepo = "https://github.com/folke/lazy.nvim.git"
  local out = vim.fn.system({ "git", "clone", "--filter=blob:none", "--branch=stable", lazyrepo, lazypath })
  if vim.v.shell_error ~= 0 then
    vim.api.nvim_echo({
      { "Failed to clone lazy.nvim:\n", "ErrorMsg" },
      { out, "WarningMsg" },
      { "\nPress any key to exit..." },
    }, true, {})
    vim.fn.getchar()
    os.exit(1)
  end
end
vim.opt.rtp:prepend(lazypath)

vim.g.mapleader = " "

require("lazy").setup({
  {
    "nvim-treesitter/nvim-treesitter",
    build = ":TSUpdate",
    config = function ()
      local configs = require("nvim-treesitter.configs")

      configs.setup({
        ensure_installed = { "c", "lua", "html", "css", "fish", "bash", "nix" },
        sync_install = false,
        highlight = { enable = true, disable = { "bash" } },
        indent = { enable = false }
      })
    end
  },

  {
    "ellisonleao/gruvbox.nvim",
    priority = 1000,
    config = function()
      require("plugins/gruvbox")()
    end,
  },

  {
    "ibhagwan/fzf-lua",
    dependencies = { "nvim-tree/nvim-web-devicons" },
    opts = {
      files = {
        fd_opts = "--color=always -t f . /mnt/DATA ~/nix",
        fzf_opts = {
          ["--delimiter"] = "/",
          ["--with-nth"] = "4..",
        },
      },
    },
  },

  {
    'hrsh7th/nvim-cmp',
    event = "InsertEnter",
    dependencies = {
      'hrsh7th/cmp-buffer',
      'hrsh7th/cmp-path',
      'saadparwaiz1/cmp_luasnip',
      {
        'L3MON4D3/LuaSnip',
        config = function()
          require("plugins.luasnip")
        end
      },
    },
    config = function()
      require("plugins.cmp")
    end
  },

  {
    'lervag/vimtex',
    lazy = false,
    init = function()
      require("plugins.vimtex")
    end
  },

  {
    'dense-analysis/ale',
    config = function()
      local g = vim.g
      g.ale_disable_lsp = 1
      g.ale_linters_explicit = 1

      g.ale_linters = {
        python = {'ruff'},
        c = {'gcc'},
        nix = {'nix'},
      }

      g.ale_fix_on_save = 1
      g.ale_fixers = { ["*"] = { "trim_whitespace" } }
    end
  }
})

