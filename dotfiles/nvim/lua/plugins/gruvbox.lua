return function()
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
    inverse = true,
    contrast = "hard",
  })

  vim.cmd("colorscheme gruvbox")

vim.api.nvim_set_hl(0, "StatusLine", { link = "Normal" })
vim.api.nvim_set_hl(0, "StatusLineNC", { link = "NormalFloat" })
vim.api.nvim_set_hl(0, "Normal", { bg = "NONE" })
end
