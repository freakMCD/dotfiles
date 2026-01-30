vim.g.vimtex_view_method = 'zathura'
vim.g.vimtex_quickfix_open_on_warning = 0  
vim.g.vimtex_quickfix_autoclose_after_keystrokes = 2
vim.g.vimtex_compiler_latexmk = {
  aux_dir = '.auxfiles',
  out_dir = 'pdffiles',
}
vim.g.vimtex_toc_custom_matchers = {
  {
    title = "Problema",
    prefilter_cmds = { "begin" },
    re = [[\v^\s*\\begin\{problem\}]],
  },
}
