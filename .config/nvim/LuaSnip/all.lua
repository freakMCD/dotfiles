
local ls = require("luasnip")
local s = ls.snippet
local sn = ls.snippet_node
local t = ls.text_node
local i = ls.insert_node
local f = ls.function_node
local d = ls.dynamic_node
local fmt = require("luasnip.extras.fmt").fmt
local fmta = require("luasnip.extras.fmt").fmta
local rep = require("luasnip.extras").rep


-- Table 
table_node= function(args)
	local tabs = {}
	local count
	table = args[1][1]:gsub("%s",""):gsub("|","")
	count = table:len()
	for j=1, count do
		local iNode
		iNode = i(j)
		tabs[2*j-1] = iNode
		if j~=count then
			tabs[2*j] = t" & "
		end
	end
	return sn(nil, tabs)
end

rec_table = function ()
	return sn(nil, {
		c(1, {
			t({""}),
			sn(nil, {t{"\\\\",""} ,d(1,table_node, {ai[1]}), d(2, rec_table, {ai[1]})})
		}),
	});
end


-- Place this in ${HOME}/.config/nvim/LuaSnip/all.lua
return {
  -- A snippet that expands the trigger "hi" into the string "Hello, world!".
  require("luasnip").snippet(
    { trig = "hi" },
    { t("Hello, world!") }
  ),

  -- To return multiple snippets, use one `return` statement per snippet file
  -- and return a table of Lua snippets.
  require("luasnip").snippet(
    { trig = "foo" },
    { t("Another snippet.") }
  ),
    s("tabular", {
	t"\\begin{tabular}{",
	i(1,"0"),
	t{"}",""},
	d(2, table_node, {1}, {}),
	d(3, rec_table, {1}),
	t{"","\\end{tabular}"}
    })


}
