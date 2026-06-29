local tex = {}
tex.in_mathzone = function()
  return vim.fn['vimtex#syntax#in_mathzone']() == 1
end

return {
s({ trig = "([bpv])mat(%d)(%d)", regTrig = true, snippetType = "autosnippet" }, {
  d(1, function(_, snip)
    local mat_type = snip.captures[1] .. "matrix"
    local rows, cols = tonumber(snip.captures[2]), tonumber(snip.captures[3])
    local nodes = {}
    local ts = 1

    table.insert(nodes, t("\\begin{" .. mat_type .. "}"))

    for r = 1, rows do
      table.insert(nodes, t({ "", "\t" }))

      for c = 1, cols do
        table.insert(nodes, i(ts))
        ts = ts + 1
        if c < cols then
          table.insert(nodes, t(" & "))
        end
      end

      if r < rows then
        table.insert(nodes, t(" \\\\"))
      end
    end

    table.insert(nodes, t({ "", "\\end{" .. mat_type .. "}" }))
    return sn(1, nodes)
  end),
}, { condition = tex.in_mathzone })}
