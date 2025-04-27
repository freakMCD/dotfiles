local ls  = require("luasnip")
local s   = ls.snippet
local fmt = require("luasnip.extras.fmt").fmt

return {
  s("preamble", fmt([[
\documentclass[11pt,a4paper,parskip=half,DIV=12]{{scrartcl}}
\usepackage[T1]{{fontenc}}
\usepackage{{amsmath, amsthm, amsfonts, amssymb}}
\usepackage{{graphicx}}
\usepackage[shortlabels]{{enumitem}}
\setlist[enumerate]{{font=\bfseries}}

\usepackage{{tikz}}
\usetikzlibrary{{positioning,calc}}

]], {})),

  s("begindiscreta", fmt([[
\renewcommand{{\thesection}}{{\hspace*{{-1.0em}}}}
\renewcommand{{\thesubsection}}{{\hspace*{{-1.0em}}}}
\renewcommand{{\thesubsubsection}}{{\hspace*{{-1.0em}}}}

\begin{{document}}
\begin{{titlepage}}
    \begin{{center}}
        \vspace*{{1cm}}

        {{\huge \textbf{{Universidad Nacional de Trujillo}}}}

        \vspace{{0.5cm}}
        {{\LARGE \textbf{{Facultad de Ciencias Físicas y Matemáticas}}}}

        \vspace{{0.5cm}}
        {{\Large \textbf{{Escuela de Matemáticas}}}}

        \vspace{{1cm}}
        \includegraphics[width=0.4\textwidth]{{~/MathCareer/unt-logo.png}}

        \vspace{{0.5cm}}
        {{\LARGE \textbf{{Trabajo Práctico 3}} \\ \vspace{{0.5cm}} \textbf{{Orden Producto y Orden lexicográfico}}}}

        \vfill

        {{\large \textbf{{Autores}}}}
        \vspace{{0.5cm}}

        \begin{{tabular}}{{c}}
            Santos Caballero Pierr Ángel\\
            Valencia Haro Anderson Nataniel\\
            Vasquez Mostacero Diego Efraín\\
            Velarde Jacinto Edwin Alexander\\
            Villegas Albarrán Erick Ismael\\
        \end{{tabular}}

        \vfill

        \textbf{{Curso:}} Matemática Discreta \\
        \vspace{{0.3cm}}
        \textbf{{Docente:}} Ramirez Lara Guillermo Teodoro \\
        \vspace{{0.3cm}}
        \textbf{{Ciclo:}} III
        \vfill
        Trujillo - Perú \\
        2025
    \end{{center}}
\end{{titlepage}}
\end{{document}}
]], {})),

}

