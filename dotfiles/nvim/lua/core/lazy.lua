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
    branch = "main",
    lazy = false,
    build = ":TSUpdate",

    config = function()
      local treesitter = require("nvim-treesitter")

      local languages = { "c", "lua", "html", "css", "fish", "bash", "nix", "python", }

      treesitter.setup({})
      treesitter.install(languages)

      local group = vim.api.nvim_create_augroup(
        "treesitter_highlighting",
        { clear = true }
      )

      vim.api.nvim_create_autocmd("FileType", {
        group = group,
        pattern = { "c", "lua", "html", "css", "fish", "nix", "python" },
        callback = function(args)
          vim.treesitter.start(args.buf)
        end,
      })
    end,
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
    cmd = "FzfLua",
    dependencies = { "nvim-tree/nvim-web-devicons" },
    opts = {
      files = {
        fd_opts = "--color=never -t f . /mnt/DATA ~/nix",
        fzf_opts = {
          ["--delimiter"] = "/",
          ["--with-nth"] = "4..",
        },
      },
    },
  },

  {
    'saghen/blink.cmp',
    version = '1.*',
    dependencies = {
      {
        "L3MON4D3/LuaSnip",
        version = "v2.*",
        config = function()
          require("plugins.luasnip")
        end,
      },
    },

    opts = {
      snippets = { preset = 'luasnip' },
      keymap = {
        preset = 'enter',

        ['<Up>'] = false,
        ['<Down>'] = false,
      },
      completion = { list = { selection = { preselect = false} } },
    },
  },

  {
    'lervag/vimtex',
    lazy = false,
    init = function()
      require("plugins.vimtex")
    end
  },

  {
    "dense-analysis/ale",

    init = function()
      vim.g.ale_disable_lsp = 1
      vim.g.ale_linters_explicit = 1

      vim.g.ale_linters = {
        python = { "ruff" },
        c = { "gcc" },
        nix = { "nix" },
      }

      vim.g.ale_fix_on_save = 1
      vim.g.ale_fixers = {
        ["*"] = { "trim_whitespace" },
      }
    end,
  },
})
