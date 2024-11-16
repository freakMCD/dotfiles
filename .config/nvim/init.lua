-- core 
require("core.lazy") -- plugin manager
require("core.options")
require("core.keymaps")
require("core.autocommands")

-- core plugins 
require("plugins.cmp")
require("plugins.luasnip")
require("plugins.fzf")

-- appearance 
require("plugins.colorscheme")
require("plugins.lualine")

-- ft specific 
require("plugins.vimtex") -- latex
