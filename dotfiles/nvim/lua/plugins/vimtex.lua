vim.g.vimtex_view_method = 'zathura'
vim.g.vimtex_quickfix_open_on_warning = 0  
vim.g.vimtex_quickfix_autoclose_after_keystrokes = 2
vim.g.vimtex_compiler_latexmk = {
  aux_dir = '.auxfiles',
  out_dir = 'pdffiles',
}
vim.g.vimtex_toc_show_preamble = 0

local matcher = {
  title = "Problemas",
  prefilter_cmds = { "begin" },
  re = [[\v^\s*\\begin\{problem\}\{(.+)\}]],
}

function matcher.get_entry(context)
  local line = vim.fn.getline(context.lnum)
  local title = line:match("^%s*\\begin{problem}{([^}]*)}")

  return {
    title = title,
    number = "",
    file = context.file,
    line = context.lnum,
    rank = context.lnum_total,
    level = 0,
    type = "content",
  }
end

vim.g.vimtex_toc_custom_matchers = { matcher }
