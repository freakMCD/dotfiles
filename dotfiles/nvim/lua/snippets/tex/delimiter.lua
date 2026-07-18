local helpers = require('luasnip-helper-funcs')
local get_visual = helpers.get_visual

-- Math context detection
local tex = {}
tex.in_mathzone = function() return vim.fn['vimtex#syntax#in_mathzone']() == 1 end
tex.in_text = function() return not tex.in_mathzone() end

-- Return snippet tables
return
{
  -- LATEX QUOTATION MARK
  s({trig = "``", snippetType="autosnippet"},
    fmta(
      "``<>''",
      {
        d(1, get_visual),
      }
    )
  ),

  s({trig = "([^%a])langle", regTrig = true, wordTrig = false, snippetType="autosnippet"},
    fmta(
      "<>\\langle <> \\rangle",
      {
        f( function(_, snip) return snip.captures[1] end ),
        d(1, get_visual),
      }
    )
  ),
}

