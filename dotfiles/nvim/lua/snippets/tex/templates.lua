local ls  = require("luasnip")
local i = ls.insert_node
local s   = ls.snippet
local fmt = require("luasnip.extras.fmt").fmt

return {
s("preamble", fmt([[
\documentclass[parskip=half]{{scrartcl}}

\input{{base}}
% \input{{exercises}}
% \input{{algorithms}}

]], {})),

s("thebiblio", fmt([[
\addcontentsline{{toc}}{{section}}{{Referencias}}
\begin{{thebibliography}}{{99}}
  {}
\end{{thebibliography}}
]], {i(1)})),

s("deffunction", fmt([[
\[
  f: \begin{{array}}[t]{{c@{{\hspace{{0.3em}}}}c@{{\;}}l@{{\;}}}}
    D & \longrightarrow & \mathbb{{R}} \\
    x & \longmapsto & f(x)
  \end{{array}}
\]
]], {})),
}

