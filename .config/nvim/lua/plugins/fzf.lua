local actions = require "fzf-lua.actions"
require'fzf-lua'.setup {
    files = {
        previewer=false
    }
}


vim.keymap.set("n", "<c-P>", function() require('fzf-lua').files({ cmd = vim.env.FZF_DEFAULT_COMMAND } ) end, { desc = "Fzf Files" })
