local rec_ls
rec_ls = function()
	return sn(
		nil,
		c(1, {
			-- Order is important, sn(...) first would cause infinite loop of expansion.
			t(""),
			sn(nil, { t({ "", "\t\\item " }), i(1), d(2, rec_ls, {}) }),
		})
	)
end


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
return{
	s({trig ="table"}, {
		t"\\begin{tabular}{",
		i(1,"0"),
		t{"} \\toprule",""},
		d(2, table_node, {1}, {}),
		d(3, rec_table, {1}),
		t{"","\\bottomrule \\end{tabular}"}
	}),

	s({trig = "itt", snippetType="autosnippet"}, {
		t({ "\\begin{itemize}", "\t\\item " }),
		i(1),
		d(2, rec_ls, {}),
		t({ "", "\\end{itemize}" }),
	},
    {condition = line_begin}
    ),
}
