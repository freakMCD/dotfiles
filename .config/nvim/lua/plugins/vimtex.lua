vim.g.vimtex_view_method = 'zathura'
vim.g.vimtex_quickfix_open_on_warning = 0  
vim.g.vimtex_quickfix_autoclose_after_keystrokes = 5

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
