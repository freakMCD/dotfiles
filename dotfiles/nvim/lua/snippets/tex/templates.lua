local ls  = require("luasnip")
local s   = ls.snippet
local fmt = require("luasnip.extras.fmt").fmt

return {
  s("preamble", fmt([[
\documentclass[parskip=half]{{scrartcl}}
% --- Encoding and language ---
\usepackage[T1]{{fontenc}}
\usepackage[spanish,es-minimal]{{babel}}
% --- Math ---
\usepackage{{amsthm, amssymb, mathtools}}
% --- Lists ---
\usepackage[shortlabels]{{enumitem}}
\setlist[enumerate]{{font=\bfseries}}
% --------------------------------------------- %
\usepackage{{graphicx}}
\usepackage{{booktabs}}
\graphicspath{{{{./img/}}}}
\usepackage[colorlinks=true, linkcolor=blue!50!black, urlcolor=blue, citecolor=blue]{{hyperref}}
]], {})),

  s("exercises", fmt([[
\usepackage{{tcolorbox}}
\tcbuselibrary{{breakable}}

\newtcolorbox{{problem}}[1]{{
    before upper={{
        \phantomsection
        \addcontentsline{{toc}}{{section}}{{#1}}
    }},
    breakable,
    colback=blue!5,
    colframe=blue!50!black,
    colbacktitle=blue!50!black,
    coltitle=white,
    fonttitle=\bfseries,
    title={{#1}},
    fontupper=\small
}}
]], {})),

s("thebiblio", fmt([[
\addcontentsline{{toc}}{{section}}{{Referencias}}
\begin{{thebibliography}}{{99}}
  {}
\end{{thebibliography}}
]], {i(1)})),

s("defcontinuidad", fmt([[
\[
  \forall \epsilon > 0,\ \exists \delta > 0:\ |x - a| < \delta \Rightarrow |f(x) - f(a)| < \epsilon
\]
]], {})),

s("deffuncion", fmt([[
\[
  f: \begin{{array}}[t]{{c@{{\hspace{{0.3em}}}}c@{{\;}}l@{{\;}}}}
    D & \longrightarrow & \mathbb{{R}} \\
    x & \longmapsto & f(x)
  \end{{array}}
\]
]], {})),
}

