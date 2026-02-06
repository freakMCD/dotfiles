local ls = require("luasnip")
local s = ls.snippet
local sn = ls.snippet_node
local t = ls.text_node
local i = ls.insert_node
local fmt = require("luasnip.extras.fmt").fmt

return {
  -- Autosnippet: scanf
  s({ trig = "scanf", name = "scanf", snippetType = "autosnippet" }, fmt([[scanf("%{}", &{});]], {
    i(1, "d"),
    i(2),
  })),

  -- Autosnippet: printf
  s({ trig = "printf", name = "printf", dscr = "Insert printf", snippetType = "autosnippet" }, fmt([[printf("{}");]], {
    i(1),
  })),

  -- Autosnippet: for loop
  s({ trig = "for", name = "for loop", snippetType = "autosnippet" }, fmt([[
    for (int {1} = 0; {2} < {3}; {4}++) {{
        {5}
    }}
  ]], {
    i(1, "i"),
    rep(1),
    i(2, "n"),
    rep(1),
    i(3),
  })),

  -- Manual snippet: main() function
  s("main", fmt([[
    int main(int argc, char *argv[]) {{
        {1}
        return 0;
    }}
  ]], {
    i(1, "// code here"),
  })),

}

