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
%\usepackage{{graphicx}}
%\usepackage{{booktabs}}
%\graphicspath{{{{./img/}}}}
%\usepackage[colorlinks=true, linkcolor=black, urlcolor=blue, citecolor=blue]{{hyperref}}
]], {})),

s("begindiscreta", fmt([[

\setcounter{{tocdepth}}{{1}} % Only sections in TOC

% Disable automatic numbering completely
\makeatletter
\renewcommand{{\thesection}}{{}} % removes number
\renewcommand{{\@seccntformat}}[1]{{}} % removes number in heading
\makeatother

\let\oldsubsection\subsection
\renewcommand{{\subsection}}[1]{{%
  \par\vspace{{1em}}%
  {{\large\textbf{{#1}}}}\par\vspace{{0.5em}}%
}}
\let\oldsubsubsection\subsubsection
\renewcommand{{\subsubsection}}[1]{{\oldsubsubsection*{{#1}}}}

\usepackage{{xparse}}

% \gnode[⟨label-pos⟩][⟨tikz-style⟩]{{⟨name⟩}}{{⟨coord⟩}}
\NewDocumentCommand{{\gnode}}{{ o o m m }}{{%
  \IfValueTF{{#1}}{{% — label was given
    \IfValueTF{{#2}}{{% — and style too
      \node[label=#1:#3, #2] (#3) at #4 {{}};
    }}{{% — label but no style
      \node[label=#1:#3]      (#3) at #4 {{}};
    }}%
  }}{{% — no label
    \IfValueTF{{#2}}{{% — style but no label
      \node[#2]               (#3) at #4 {{}};
    }}{{% — neither label nor style
      \node                   (#3) at #4 {{}};
    }}%
  }}%
}}


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


s("beginanalisis", fmt([[
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

        \vspace{{0.3cm}}
        {{\LARGE \textbf{{Ensayo sobre la Conceptualización y Definición de Límite y Continuidad}}}}

        \vspace{{0.3cm}}
    \small
        {{\large \textbf{{Autores}}}}
      \begin{{tabular}}{{p{{7cm}}p{{7cm}}}}
        {{\raggedright
          \begin{{itemize}}
             \item Aguirre Alfaro Kathia Silvana
             \item Avalos Gamboa Jholberth Isai
             \item Baca Hilario Heli Arturo
             \item Briceño García Jefferson Smith
             \item Canchachi Luna Fabiola Esther
             \item Castillo Alva Miguel Alexander Del Piero
             \item Chacón Reyes Diego Fernando
             \item Gutierrez Tirado Miluska Olenka
             \item Jimenez Mondragon Manuel Armando
         \end{{itemize}}}} &
           \begin{{itemize}}
             \item Rodriguez Gamboa Patrick Jhofreth
             \item Roncal Cruz Steev Alexander
             \item Sanchez Barrios Gerson Farid
             \item Santos Caballero Pierr Angel
             \item Valencia Haro Anderson Nataniel
             \item Valerio Flores Jhostyn Jared
             \item Valverde Ocaña Noiver Alejandro
             \item Vasquez Mostacero Diego Efrain
             \item Velarde Jacinto Edwin Alexander
           \end{{itemize}}
        \end{{tabular}}

        \vfill
        \vspace{{0.3cm}}
        \textbf{{Curso:}} Análisis Matemático II \\
        \vspace{{0.3cm}}
        \textbf{{Ciclo:}} IV
        \vfill
        Trujillo, Perú - 2025
    \end{{center}}
\end{{titlepage}}

\end{{document}}
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

