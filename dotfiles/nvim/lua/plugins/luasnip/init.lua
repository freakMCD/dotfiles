ls = require("luasnip")
local types = require("luasnip.util.types")

ls.config.setup({
    enable_autosnippets = true,
    --    region_check_events = "CursorHold,InsertEnter",
    cut_selection_keys = "<Tab>",
    ext_opts = { 
        [types.choiceNode] = 
            { active = { virt_text = {{"●", "GruvboxOrange"}}, hl_mode = "combine" } },
        [types.insertNode] = 
            { active = { virt_text = {{"●", "GruvboxBlue"}}, hl_mode = "combine" } } 
    }, 

}) 
require("luasnip.loaders.from_vscode").lazy_load()
require("luasnip.loaders.from_lua").load({ paths = {"~/.config/nvim/lua/snippets/"}, fs_event_providers = {libuv=true}})
ls.filetype_extend("tex", { "cpp", "python" })
vim.cmd([[silent command! LuaSnipEdit :lua require("luasnip.loaders").edit_snippet_files()]])

vim.keymap.set({"i"}, "<C-K>", function() ls.expand() end, {silent = true})
vim.keymap.set({"i", "s"}, "<TAB>", function() ls.jump( 1) end, {silent = true})
vim.keymap.set({"i", "s"}, "<S-TAB>", function() ls.jump(-1) end, {silent = true})


vim.keymap.set({"i", "s"}, "<C-E>", function()
	if ls.choice_active() then
		ls.change_choice(1)
	end
end, {silent = true})

