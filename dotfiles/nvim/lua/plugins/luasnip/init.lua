local ls = require("luasnip")
local types = require("luasnip.util.types")

ls.config.setup({
  enable_autosnippets = true,
  update_events = "TextChanged,TextChangedI",
  region_check_events = "CursorMoved,CursorMovedI,CursorHold",
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
vim.cmd([[silent command! LuaSnipEdit :lua require("luasnip.loaders").edit_snippet_files()]])

