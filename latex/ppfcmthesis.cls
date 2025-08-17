%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%% Modified light extension: added configurable %%
%% logo macros for title & colophon similarity. %%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
\NeedsTeXFormat{LaTeX2e}[1995/12/01]
\ProvidesClass{ppfcmthesis}[2025/08/16 PUT unofficial thesis class (extended logos)]

\newif\if@ppbachelor\@ppbachelorfalse
\DeclareOption{bachelor}{\@ppbachelortrue}

\ExecuteOptions{a4paper,pl,11pt,oneside,final}
\DeclareOption*{\PassOptionsToClass{\CurrentOption}{memoir}}
\ProcessOptions\relax
\LoadClass{memoir}

% --- Language setup (force explicit languages to avoid 'nil' language issues) ---
% Always load both English and Polish; default to Polish if available.
\PassOptionsToPackage{english,polish}{babel}
\RequirePackage{babel}
\newif\if@pppolish
% Babel defines \captions<lang>; test for polish presence
\@ifundefined{captionspolish}{\@pppolishfalse}{\@pppolishtrue}
\if@pppolish
  \selectlanguage{polish}
  \RequirePackage{indentfirst}
  \addto\captionspolish{\renewcommand{\bibname}{Literatura}}
\else
  \selectlanguage{english}
\fi

\RequirePackage{graphicx}
\RequirePackage{setspace}
\RequirePackage{booktabs}
\ifpdf
  \DeclareGraphicsExtensions{.pdf,.png,.jpg,.eps}
\else
  \DeclareGraphicsExtensions{.eps}
\fi
\RequirePackage{fancyvrb}
\RequirePackage{url}
\RequirePackage{nameref}
\RequirePackage{varioref}

% Unified hyperref load (avoid explicit dvips option to be engine-agnostic)
\usepackage[unicode,linktoc=all,bookmarks]{hyperref}
\hypersetup{
  pdffitwindow=true,
  bookmarksnumbered=true,
  bookmarksopen=true,
  colorlinks=true,
  pdfpagelayout=SinglePage,
  pdfpagemode=UseOutlines,
  pdfstartview=Fit,
  linkcolor=black,
  citecolor=black,
  anchorcolor=black,
  filecolor=black,
  menucolor=black,
  urlcolor=black,
  pdftitle={},
  pdfauthor={},
  pdfkeywords={}
}
\RequirePackage{memhfixc}

\ifx\undefined\SingleSpacing
  \RequirePackage{setspace}
  \newcommand{\SingleSpacing}{\singlespacing}
\fi
\ifx\undefined\OnehalfSpacing
  \newcommand{\OnehalfSpacing}{\onehalfspacing}
\fi

% ---------------- Configuration macros for logos ----------------
% User-overridable (before \begin{document}) if needed:
\newcommand{\ppTitleLogoFilePL}{wit/sygnet-pp}
\newcommand{\ppTitleLogoFileEN}{wit/sygnet-pp-eng}
\newcommand{\ppTitleLogoWidth}{\textwidth}
\newcommand{\ppColophonLogoFile}{wit/logo-pp}
\newcommand{\ppColophonLogoWidth}{0.45\textwidth} % for more visual similarity
% If you want EXACT same image: set \ppColophonLogoFile to same as Title variant
% and maybe \ppColophonLogoWidth to same width or a ratio.

\aliaspagestyle{title}{empty}
\date{}
\newcommand{\ppsupervisor}[1]{\def\@ppsupervisor{#1}}
\newcommand{\ppyear}[1]{\def\@ppyear{#1}}
\newcommand{\authortitle}[1]{\def\@authortitle{#1}}

\setlength{\droptitle}{0cm}
\preauthor{\begin{center}\large\@authortitle}
\postauthor{\end{center}}

\renewcommand{\maketitlehooka}{%
\begin{center}
  \if@pppolish
    \IfFileExists{\ppTitleLogoFilePL.pdf}{\includegraphics[width=\ppTitleLogoWidth]{\ppTitleLogoFilePL}}{\IfFileExists{\ppTitleLogoFilePL.png}{\includegraphics[width=\ppTitleLogoWidth]{\ppTitleLogoFilePL}}{}}\par
    WYDZIA{\L} INFORMATYKI I TELEKOMUNIKACJI\\
    Instytut Informatyki
  \else
    \IfFileExists{\ppTitleLogoFileEN.pdf}{\includegraphics[width=\ppTitleLogoWidth]{\ppTitleLogoFileEN}}{\IfFileExists{\ppTitleLogoFileEN.png}{\includegraphics[width=\ppTitleLogoWidth]{\ppTitleLogoFileEN}}{}}\par
    FACULTY OF COMPUTING AND TELECOMMUNICATION\\
    Institute of Computing Science
  \fi
\end{center}}

\pretitle{\vspace{3.5cm}\begin{center}%
\if@pppolish
  \if@ppbachelor Praca dyplomowa licencjacka \else Praca dyplomowa magisterska \fi
\else
  \if@ppbachelor Bachelor's thesis \else Master's thesis \fi
\fi
\par\vspace{1.0cm}\Large\bfseries\MakeUppercase}
\posttitle{\end{center}}

\newcommand{\album}[1]{\unskip ,~#1}
\renewcommand{\and}{\\}
\renewcommand{\maketitlehookb}{\vspace{1cm}}
\renewcommand{\maketitlehookc}{%
  \vfill
  \begin{center}
    \if@pppolish Promotor\\\@ppsupervisor
    \else Supervisor\\\@ppsupervisor \fi
  \end{center}
  \vspace{1.5cm}
  \begin{center}POZNA\'N \@ppyear\end{center}
}

% Colophon (stopka końcowa)
\newcommand{\ppcolophon}{%
  \renewcommand{\and}{\unskip{}, }%
  \renewcommand{\album}[1]{\unskip}%
  \cleardoublepage\thispagestyle{empty}\vspace*{\fill}%
  \centering
  % Make logo stylized similarly (centered, adjustable width) – optional
  \IfFileExists{\ppColophonLogoFile.pdf}{\includegraphics[width=\ppColophonLogoWidth]{\ppColophonLogoFile}}{\IfFileExists{\ppColophonLogoFile.png}{\includegraphics[width=\ppColophonLogoWidth]{\ppColophonLogoFile}}{}}\par
  \vspace{1em}
  \footnotesize\SingleSpacing
  \@author\ (\@ppyear)\\[0.7em]
  \if@pppolish
    Instytut Informatyki, Wydzia{\l} Informatyki i Telekomunikacji\\
    Politechnika Pozna\'nska
  \else
    Poznan University of Technology\\
    Faculty of Computing and Telecommunication\\
    Institute of Computing Science
  \fi

  \medskip
  \if@pppolish
    Sk{\l}ad przy u{\.z}yciu systemu \LaTeX{} (Overleaf).
  \else
    Typeset using \LaTeX.
  \fi
  \par\vspace*{\fill}
}

% Page style and headers
\makepagestyle{ppfcmthesis}
\makeevenfoot{ppfcmthesis}{}{}{}
\makeatletter
\newcommand{\@ppfcmthesismarks}{%
  \let\@mkboth\markboth
  \def\chaptermark##1{\markboth{##1}{##1}}
  \def\sectionmark##1{\markright{\ifnum \c@secnumdepth>\z@ \thesection.\ \fi ##1}}
  \def\tocmark{\markboth{\contentsname}{}}
  \def\lofmark{\markboth{\listfigurename}{}}
  \def\lotmark{\markboth{\listtablename}{}}
  \def\bibmark{\markboth{\bibname}{}}
  \def\indexmark{\markboth{\indexname}{}}
}
\makepsmarks{ppfcmthesis}{\@ppfcmthesismarks}
\makeatother
\makeevenhead{ppfcmthesis}{\thepage}{}{\normalfont\small\itshape\leftmark}
\makeoddhead{ppfcmthesis}{\normalfont\small\itshape\rightmark}{}{\thepage}

\setcounter{tocdepth}{2}
\maxtocdepth{subsection}
\maxsecnumdepth{subsection}

\pagestyle{ppfcmthesis}
\setstocksize{297mm}{210mm}
\settrimmedsize{297mm}{210mm}{*}
\settrims{0pt}{0cm}
\setlrmarginsandblock{3.5cm}{2.5cm}{*}
\setulmarginsandblock{2.5cm}{2.5cm}{*}
\setmarginnotes{6pt}{50pt}{\onelineskip}
\setheadfoot{\onelineskip}{2\onelineskip}
\setheaderspaces{*}{2\onelineskip}{*}
\OnehalfSpacing

\changecaptionwidth
\captionwidth{.9\linewidth}
\captionnamefont{\footnotesize\scshape}
\captiontitlefont{\footnotesize}

\newcommand{\fcmfcaption}[2][\@empty]{%
  \captionnamefont{\footnotesize\bfseries}%
  \captiondelim{.~}%
  \captionstyle{}%
  \captiontitlefont{\footnotesize}%
  \ifx #1\@empty \caption{#2}\else \caption[#1]{#2}\fi}

\newcommand{\fcmtcaption}[2][\@empty]{%
  \captionnamefont{\footnotesize\bfseries\hfill}%
  \captiondelim{}%
  \captionstyle{\raggedleft\\}%
  \captiontitlefont{\footnotesize\normalfont}%
  \ifx #1\@empty \caption{#2}\else \caption[#1]{#2}\fi}

\def\thesubsubsection {\thesubsection .\arabic{subsubsection}}
\checkandfixthelayout

% Term macros
\newcommand{\termdef}[1]{\emph{#1}}
\newcommand{\acronym}[1]{\emph{\MakeUppercase{#1}}}
\newcommand{\definicja}[1]{\termdef{#1}}
\newcommand{\akronim}[1]{\acronym{#1}}
\newcommand{\english}[1]{ang.~\emph{#1}}

% Table head
\newcolumntype{L}{c}\newcommand{\tabhead}[1]{\multicolumn{1}{L}{#1}}