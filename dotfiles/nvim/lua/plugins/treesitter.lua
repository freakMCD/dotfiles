return {
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
}
