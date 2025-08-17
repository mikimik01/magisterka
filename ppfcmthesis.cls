\NeedsTeXFormat{LaTeX2e}
\ProvidesClass{ppfcmthesis}[2024/01/01 Polish Thesis Class]

% Base class
\LoadClass[12pt,a4paper,oneside]{book}

% Required packages
\RequirePackage[utf8]{inputenc}
\RequirePackage[polish]{babel}
\RequirePackage[T1]{fontenc}
\RequirePackage{geometry}
\RequirePackage{fancyhdr}
\RequirePackage{listings}
\RequirePackage{amsmath}
\RequirePackage{xcolor}

% Page geometry
\geometry{
    left=3cm,
    right=2.5cm,
    top=2.5cm,
    bottom=2.5cm
}

% Set Polish as default language
\selectlanguage{polish}

% Page style
\pagestyle{fancy}
\fancyhf{}
\fancyhead[R]{\thepage}
\renewcommand{\headrulewidth}{0pt}

% Chapter and section numbering per chapter
\numberwithin{equation}{chapter}
\numberwithin{figure}{chapter}
\numberwithin{table}{chapter}

% Configure listings
\lstset{
    basicstyle=\ttfamily\small,
    numbers=left,
    numberstyle=\tiny,
    stepnumber=1,
    numbersep=5pt,
    backgroundcolor=\color{white},
    showspaces=false,
    showstringspaces=false,
    showtabs=false,
    frame=single,
    rulecolor=\color{black},
    tabsize=2,
    captionpos=b,
    breaklines=true,
    breakatwhitespace=false,
    title=\lstname
}

% Define thesis title page and basic structure
\newcommand{\thesistitle}[1]{\def\@thesistitle{#1}}
\newcommand{\thesisauthor}[1]{\def\@thesisauthor{#1}}
\newcommand{\thesisyear}[1]{\def\@thesisyear{#1}}

\renewcommand{\maketitle}{
    \begin{titlepage}
        \centering
        \vspace*{2cm}
        {\huge\bfseries \@thesistitle \par}
        \vspace{2cm}
        {\Large \@thesisauthor \par}
        \vfill
        {\large \@thesisyear \par}
    \end{titlepage}
}