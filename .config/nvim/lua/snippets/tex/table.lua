local rec_ls
rec_ls = function()
	return sn(nil, {
		c(1, {
			t({""}),
			sn(nil, {t({"", "\t\\item "}), i(1), d(2, rec_ls, {})}),
		}),
	})
end

local function column_count_from_string(descr)
	return #(descr:gsub("[^clmrp]", ""))
end

local tab = function(args, snip)
	local cols = column_count_from_string(args[1][1])
	if not snip.rows then
		snip.rows = 1
	end
	local nodes = {}
	local ins_indx = 1
	for j = 1, snip.rows do
		table.insert(nodes, r(ins_indx, tostring(j).."x1", i(1)))
		ins_indx = ins_indx+1
		for k = 2, cols do
			table.insert(nodes, t" & ")
			table.insert(nodes, r(ins_indx, tostring(j).."x"..tostring(k), i(1)))
			ins_indx = ins_indx+1
		end
		table.insert(nodes, t{"\\\\", ""})
	end
	-- fix last node.
	nodes[#nodes] = t""
	return sn(nil, nodes)
end

local mat = function(_, snip)
	if not snip.rows then
		-- one not set -> both not set.
		snip.rows = 3
		snip.cols = 3
	end
	local nodes = {}
	local ins_indx = 1
	for j = 1, snip.rows do
		table.insert(nodes, r(ins_indx, tostring(j).."x1", i(1)))
		ins_indx = ins_indx+1
		for k = 2, snip.cols do
			table.insert(nodes, t" & ")
			table.insert(nodes, r(ins_indx, tostring(j).."x"..tostring(k), i(1)))
			ins_indx = ins_indx+1
		end
		table.insert(nodes, t{"\\\\", ""})
	end
	-- fix last node.
	nodes[#nodes] = t""
	return sn(nil, nodes)
end
return{
	s("ls", {
		t({"\\begin{"}), c(1, {
			t"itemize",
			t"enumerate",
			i(nil)
		}), t({"}", "\t\\item "}),
		i(2), d(3, rec_ls, {}),
		t({"", "\\end{"}), rep(1), t"}", i(0)
	}),
	s("tab", fmt([[
	\begin{{tabular}}{{{}}}
    \toprule
	{}
    \bottomrule
	\end{{tabular}}
	]], {i(1, "c"), d(2, tab, {1}, {
		user_args = {
			function(snip) snip.rows = snip.rows + 1 end,
			-- don't drop below one.
			function(snip) snip.rows = math.max(snip.rows - 1, 1) end
		}
	} )})),
	s("mat", fmt([[
	\begin{{{}}}
	{}
	\end{{{}}}
	]], {c(1, {t"matrix", t"pmatrix", t"bmatrix", t"Bmatrix", t"vmatrix", t"Vmatrix"}),
		d(2, mat, {}, {
			user_args = {
				function(snip) snip.rows = snip.rows + 1 end,
				-- don't drop below one.
				function(snip) snip.rows = math.max(snip.rows - 1, 1) end,
				function(snip) snip.cols = snip.cols + 1 end,
				-- don't drop below one.
				function(snip) snip.cols = math.max(snip.cols - 1, 1) end
			}
		}),
		rep(1)
	})),
}
