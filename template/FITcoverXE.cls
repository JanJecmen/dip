\NeedsTeXFormat{LaTeX2e}
\ProvidesClass{template/FITcoverXE}[2015/04/29 CTU FIT standard class for borders]

% created by Ondrej Guth <ondrej.guth@fit.cvut.cz>

% % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % %
% options
% % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % %

\newif \if@thesistypedefined
\DeclareOption {thesis=B} { \gdef \@thesistype{B} \@thesistypedefinedtrue }
\DeclareOption {thesis=M} { \gdef \@thesistype{M} \@thesistypedefinedtrue }

\newif \if@langdefined
\newif \if@langczech
\DeclareOption {czech} {
	\@langczechtrue
	\@langdefinedtrue
}
\DeclareOption {english} {
	\@langczechfalse
	\@langdefinedtrue
}

\newif\if@inverse
\DeclareOption{inverse}{
	\@inversetrue
}

\ProcessOptions

\if@langdefined \else
	\ClassError {FITthesis} {Language not specified} {Add option czech for Czech language or option english for English language.}
\fi

\LoadClass[a4paper,20pt]{extarticle}[1996/10/08]
\RequirePackage[a4paper,textwidth=171mm,textheight=230mm,rmargin=20mm,tmargin=35mm]{geometry}[2002/07/08]

\RequirePackage{babel}[2008/07/06]

\RequirePackage[IL2]{fontenc}
\RequirePackage{lmodern}

\if@inverse
	\RequirePackage{color}
	\pagecolor{blue}
	\color{white}
\fi

\if@langczech
	\RequirePackage[IL2]{fontenc}
	\RequirePackage{lmodern}
\else
	\AtBeginDocument{\selectlanguage{English}}
\fi

\RequirePackage{palatino}

\RequirePackage{graphicx}

% % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % 

\newif\if@titledefined
\DeclareRobustCommand{\title}[1]{
	\def\thetitle{#1}
	\@titledefinedtrue
}

\newif\if@authordefined
\DeclareRobustCommand{\author}[1]{
	\def\theauthor{#1}
	\@authordefinedtrue
}

\DeclareRobustCommand {\thesistype} {%
	\if@thesistypedefined
		\if\@thesistype B%
			\if@langczech {BAKALÁŘSKÁ PRÁCE}\else {BACHELOR'S THESIS}\fi
		\else
			\if\@thesistype M%
				\if@langczech {DIPLOMOVÁ PRÁCE}\else {MASTER'S THESIS}\fi
			\else
				\ClassError {FITthesis} {Thesis type not specified} {Add option thesis=B for bachelor's thesis or option thesis=M for master's thesis.}
			\fi
		\fi
	\else
		\ClassError {FITthesis} {Thesis type not specified} {Add option thesis=B for bachelor's thesis or option thesis=M for master's thesis.}
	\fi
}

\DeclareRobustCommand {\universitytitle} {%
	\if@langczech{%
		{\v C}ESK{\' E} VYSOK{\' E} U{\v C}EN{\' I} TECHNICK{\' E} V PRAZE%
	}\else{%
		CZECH TECHNICAL UNIVERSITY IN PRAGUE%
	}\fi
}

\DeclareRobustCommand{\facultytitle}{%
	\if@langczech{%
		FAKULTA INFORMA{\v C}N{\' I}CH TECHNOLOGI{\' I}
	}\else{
		FACULTY OF INFORMATION TECHNOLOGY
	}\fi
}


\AtBeginDocument{
\pagestyle{empty}

\begin{center}
	\universitytitle
	
	\vspace{10mm}
	
	\facultytitle
	
	\vspace{3cm}
	\if@inverse
		\includegraphics[height=5cm]{images/cvut-logo-w}
	\else
		\includegraphics[height=5cm]{images/cvut-logo-bw}
	\fi
	
	\vspace{3cm}
	
	\if@titledefined\thetitle\else\ClassError{FITboards}{Thesis' title unspecified}{Specify title of this thesis using the \protect\title\space command.}\fi

	\vfill
	
	\thesistype
\end{center}
	
	\vspace{10mm}
	
	\the\year{} \hfill \if@authordefined\theauthor\else\ClassError{FITboards}{Thesis' author unspecified}{Specify author of this thesis (i.e. your name) using the \protect\author\space command.}\fi
}
