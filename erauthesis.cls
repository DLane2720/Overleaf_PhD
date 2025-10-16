%%%%%%
%%%%%%
%%      erauthesis.cls
%%
%%		updated-Version 0.2
%%		April, 2023
%%
%%		Modified by Ph.D candidate Nuha Aljuneidi < aljunein [at] my[dot] erau [dot] edu >
%%
%%		This LaTeX document class formats Ph.D Dissertaion 
%%			according to the guidelines of Embry-Riddle Aeronautical University (ERAU).
%%		It is based on the LaTeX2e standard "report" document class.
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%		erauthesis.cls
%%
%%		Version 0.1
%%		October 20, 2020
%%
%%		For support, contact Dongeun Seo < seod [at] erau [dot] edu >.
%%
%%		This LaTeX document class formats master's thesis 
%%			according to the guidelines of Embry-Riddle Aeronautical University (ERAU).
%%		It is based on the LaTeX2e standard "report" document class.
%%
%%%%%%
%%%%%%


\NeedsTeXFormat{LaTeX2e}
\ProvidesClass{erauthesis}

%%% Degree Name Class Options
%
% Define class options to allow authors to declare their degree when loading the document class.  Default is Ph.D 
%\DeclareOption is a command in LaTeX that is used to define options that can be passed to a document class or package

\DeclareOption{Ph.D}		{\gdef\@degree{Doctor of Philosophy}	\gdef\@Dissertation{Dissertation}}




%%% Line Spacing Class Options
%
% Define class options to double-space all text.
%
\DeclareOption{singlespaceone}		{\AtBeginDocument{\singlespacingone}}
\DeclareOption{doublespaceone}		{\AtBeginDocument{\doublespacingone}}
%
% The following commands allow temporary reversion to single-spacing (e.g., footnotes and long quotes) and so forth.
%
\newcommand\singlespacingone{\renewcommand\baselinestretch{1.00}\normalsize}
\newcommand\doublespacingone{\renewcommand\baselinestretch{1.75}\normalsize}
%
% The following environments provide the same line-spacing control as the commands above.
%
\newenvironment{singlespaceone}{\begingroup\singlespacingone}{\endgroup}
\newenvironment{doublespaceone}{\begingroup\doublespacingone}{\endgroup}

%%% Co-Advisor Class Options
%
% Define a class option to support two research advisors on the signature page.  Default is nocoadivsors.


%%% Table of Contents Heading Class Options
%
% Define a class option to format the headings of the Table of Contents and Lists of Tables and Figures like chapters or like the title page.
% Default is titletables, which is required by the Graduate College.
%
\DeclareOption{chaptertables}		{\@chaptertablestrue}
\DeclareOption{titletables}			{\@chaptertablesfalse}
%
\newif\if@chaptertables
\@chaptertablesfalse


%%% Appendix Heading Class Options
%
% Define a class option to format the headings for appendices and other back matter like chapters or like the title page.
% Default is titleappendices, which is required by the Graduate College.
%
\DeclareOption{chapterappendices}	{\@chapterappendicestrue}
\DeclareOption{titleappendices}		{\@chapterappendicesfalse}
%
\newif\if@chapterappendices
\@chapterappendicesfalse


%%% Hyperref Package Color Formatting Options
%
% Define class options to suppress coloring of embedded PDF links for print vs. online versions of the document.  Default is print.
%
\DeclareOption{print}			{				%
	\gdef\fau@hypersetup{						%
		\providecommand\hypersetup[1]{\relax}	% in case the hyperref package is not loaded
		\hypersetup{							% switch all link colors to black with no frame
			colorlinks=true,					% false: boxed links; true: colored links
			linkcolor=[rgb]{0.0,0.0,0.0},		% color of internal links
			citecolor=[rgb]{0.0,0.0,0.0},		% color of links to bibliography
			filecolor=[rgb]{0.0,0.0,0.0},		% color of file links
			urlcolor=[rgb]{0.0,0.0,0.0}			% color of external links
}}}												%
\DeclareOption{online}			{				%
	\gdef\fau@hypersetup{\relax}}
\AtBeginDocument{								%
	\providecommand\phantomsection{}			% in case the hyperref package is not loaded
	\providecommand\texorpdfstring[2]{#1}		% in case the hyperref package is not loaded
	\fau@hypersetup}							%


%%% Margin Options
%
% Define class options for pre- and post-Summer 2014 margin guidelines.  Default is 2014margins.
%
\DeclareOption{2020margins}	{%
	% 1.5" inner margin
	% 1.0" outer and top
	% 0.75" bottom margin
	% 0.25" footer skip
	\gdef\fau@margins{%
		\setlength\hoffset{0.5in}%
		\setlength\oddsidemargin{0in}%
		\setlength\textwidth{6.0in}%
		\setlength\marginparsep{0in}%
		\setlength\marginparwidth{0in}%
		\setlength\voffset{-24pt}%
		\setlength\topmargin{-24pt}%
		\setlength\headheight{24pt}%
		\setlength\headsep{0pt}%
		\setlength\textheight{9.0in}%
		\setlength\footskip{0.25in}}}


%%% Prohibited report Class Options
%
% Disallow two options of the "report" document class because they are incompatible with ERAU's formatting guidelines.
%
\DeclareOption{twocolumn}{\ClassWarning{erauthesis}{The erauthesis class does not support the twocolumn option.}}
\DeclareOption{notitlepage}{\ClassWarning{erauthesis}{The erauthesis class does not support the notitlepage option.}}


%%% Prohibited report Class Page Size Options
%
% Disallow all page size options of the "report" document class other than letterpaper
%
\DeclareOption{a4paper}{\ClassWarning{erauthesis}{The erauthesis class only supports the letterpaper page size.}}
\DeclareOption{a5paper}{\ClassWarning{erauthesis}{The erauthesis class only supports the letterpaper page size.}}
\DeclareOption{b5paper}{\ClassWarning{erauthesis}{The erauthesis class only supports the letterpaper page size.}}
\DeclareOption{legalpaper}{\ClassWarning{erauthesis}{The erauthesis class only supports the letterpaper page size.}}
\DeclareOption{executivepaper}{\ClassWarning{erauthesis}{The erauthesis class only supports the letterpaper page size.}}
\DeclareOption{landscape}{\ClassWarning{erauthesis}{The erauthesis class only supports the portrait page orientation.}}


%%% Default report Class Options and Execution
%
% Send any remaining options on to the report class, set some defaults, process any specified options, and load the report class.
%	letterpaper: 	prepare PDF on standard letter paper
%	openright: 	when printing two-sided, chapters start on odd-numbered pages
%	onecolumn: 	the text appears in a single column (required)
%	titlepage: 		print a title page (required)
%This line declares an option that will pass any unrecognized options to the report class.
\DeclareOption*{\PassOptionsToClass{\CurrentOption}{report}}

% This line sets the default options for the document, including doublespaceone (double spacing), Ph.D (for a Doctor of Philosophy degree), nocoadvisors (no co-advisors), titletables (to include tables in the table of contents), titleappendices (to include appendices in the table of contents), print (for printing purposes), and 2020margins (to use margins suitable for 2020).
\ExecuteOptions{doublespaceone,Ph.D,nocoadvisors,titletables,titleappendices,print,2020margins}

\ProcessOptions

%This line loads the report class with the specified options, including letterpaper (paper size), openright (chapters begin on right-hand pages), onecolumn (single column layout), titlepage (to create a separate title page), and 12pt (font size).
\LoadClass[letterpaper,openright,onecolumn,titlepage,12pt]{report}


%%% Page Geometry
%
% Set margins.
%
\fau@margins


%%% Major Document Division Formats
%
% These commands set page numbering and sectioning options for the major document divisions, including
%	\frontmatter before the first chapter, (This command starts the front matter section of a document. In LaTeX, the front matter typically includes the title page, abstract, table of contents, list of figures, and list of tables. The page numbering for the front matter is usually in Roman numerals.)
%	\mainmatter including all the main text, (This command starts the main matter section of a document. This is where the main content of the document is included. The page numbering for the main matter is usually in Arabic numerals.)
%	\backmatter including any appendices, the bibliography, and perhaps sometimes an index.( This command starts the back matter section of a document. In LaTeX, the back matter typically includes the appendix, bibliography, and any additional materials that are included after the main content).
%
\newcommand\frontmatter{\newpage\pagenumbering{roman}}
\newcommand\mainmatter{\newpage\pagenumbering{arabic}}
\newcommand\backmatter{\appendix}
% this code redefines various LaTeX commands to change the formatting of appendix sections, including the chapter and section numbering, the heading styles, and the table of contents entries.
\renewcommand\appendix{\par
		\setcounter{chapter}{0}%
		\setcounter{section}{0}%
		\gdef\@chapapp{\appendixname}%
		\gdef\thechapter{\@Alph\c@chapter}%
		\def\@makeschapterhead##1{%
			\noindent\raisebox{-1.0in}{%
				\begin{minipage}[t]{\hsize}%
					\doublespacingone\centering%
					\parindent\z@\normalfont%
					\def\\{\protect\linebreak}%
					{\bfseries\MakeTextUppercase{##1}\par}%
				\end{minipage}}\par\nobreak
			\vskip5.0ex}%
		\if@chapterappendices\else
			\clearpage
			\def\@chapter[##1]##2{\ifnum \c@secnumdepth >\m@ne
					\refstepcounter{chapter}%
					\typeout{\@chapapp\space\thechapter}%
					\addcontentsline{toc}{chapter}{\protect APPENDIX \numberline{\thechapter}\hspace{-0.7em}}%##1}%
				\else
					\addcontentsline{toc}{chapter}{##1}%
				\fi
				\chaptermark{##1}%
				\addtocontents{lof}{\protect\addvspace{10\p@}}%
				\addtocontents{lot}{\protect\addvspace{10\p@}}%
				\if@twocolumn
					\@topnewpage[\@makechapterhead{##2}]%
				\else
					\@makechapterhead{##2}%
					\@afterheading
				\fi}
			\def\@makechapterhead##1{%
				\noindent\raisebox{-0.3in}{%
					\begin{minipage}[t]{\hsize}%
						\doublespacingone\centering%
						\parindent\z@\normalfont%
						\def\\{\protect\linebreak}%
						\ifnum\c@secnumdepth>\m@ne  {\bfseries\MakeTextUppercase{\@chapapp\ \thechapter} - } \fi%
						{\bfseries\MakeTextUppercase{##1}\par}%
					\end{minipage}}\par\nobreak
				\vskip5.0ex}%
			\renewcommand\section{%
				\@startsection{section}{1}{\z@}%
				{-3.5ex \@plus -1ex \@minus -.2ex}{2.3ex \@plus.2ex}%
				{\normalfont\sectionstyle}}
			\renewcommand\subsection{%
				\@startsection{subsection}{2}{\z@}%
				{-3.25ex\@plus -1ex \@minus -.2ex}{1.5ex \@plus .2ex}%
				{\normalfont\subsectionstyle}}
			\renewcommand\subsubsection{%
				\@startsection{subsubsection}{3}{\z@}%
				{-3.25ex\@plus -1ex \@minus -.2ex}{1.5ex \@plus .2ex}%
				{\normalfont\subsubsectionstyle}}
			\renewcommand\paragraph{%
				\@startsection{paragraph}{4}{\z@}%
				{3.25ex \@plus1ex \@minus.2ex}{-1em}%
				{\normalfont\paragraphstyle}}
			\renewcommand\subparagraph{%
				\@startsection{subparagraph}{5}{\parindent}%
				{3.25ex \@plus1ex \@minus .2ex}{-1em}%
				{\normalfont\subparagraphstyle}}
		\fi}


%%% Default Format
%
% Section Numbering Formatting
%
\raggedright
\setlength{\parindent}{0.25in}






%%%%%%
%%%%%%
%% 
%%		AUTHOR COMMANDS
%%
%%		Each thesis author should execute the commands from the following three groups.
%%		They produce pages required by ERAU with the required formatting.
%%
%%%%%%
%%%%%%


%%%
%
% Preamble Thesis, Author and Degree Information
%
% 	Every thesis should include the following information for the title, signature and abstract pages.
% 	These commands should appear in the preamble, before the \begin{document}.
%
%	\title{*thesis title*}
%	\author{*student's name*}
%	\graduation{*month*}{*year*}
%	\advisor{*thesis advisor's name*}
%	\supervisor{*thesis committee member's name*}	(Repeated once for each committee member.)
%	\department{*department*}
%	\chair{*department chair's name*}
%	\dean{*college dean's name*}
% 	\dgc{*provost's name*}
%
%	Details for each command follow.
%
%%%


%%% Department
%
% This required command sets the department from which the student is graduating.
% 	e.g., \department{Department of Physics}
% Note that the word "the" is included in the template where appropriate, and should not be specified.
%
\newcommand\department[1]{\gdef\@department{#1}}
\def\@department{\ClassError{erauthesis}{\protect\department\space undefined}
	{Please specify your \protect\department\space for the signature page.}}


%%% Graduation Date
%
% This required command sets the month and year in which the student will graduate.
% 	e.g., \graduation{December}{2014}
% Note that month and year are given as separate arguments
%
\newcommand\graduation[2]{\gdef\@gradmonth{#1}\gdef\@gradyear{#2}}
\def\@gradmonth{\ClassError{erauthesis}{\protect\graduation\space date undefined}
	{Please specify your month and year of \protect\graduation\space for the title page.}}
\def\@gradyear{\ClassError{erauthesis}{\protect\graduation\space date undefined}
	{Please specify your month and year of \protect\graduation\space for the title page.}}


%%% Advisor
% 
% This required command sets the name and titles of the student's primary thesis advisor.
% 	e.g., \advisor[Dr.]{Korey Sorge}[Ph.D.]
% The first and last arguments are optional, and the defaults are as shown.
\newcommand\advisor[1]{\gdef\@advisor{#1}}

\def\@advisor{\ClassError{erauthesis}{\protect\advisor\space undefined}
	{Please specify your \protect\advisor\space for the signature page.}}


 
%
% This optional command sets the position title of the student's primary thesis advisor, the advisor title is the "committee chair"
% 	which may not always be the default "Dissertation Advisor".

\newcommand\advisortitle[1]{\gdef\@advisortitle{#1}}
\advisortitle{\def@ult}
%
% This optional command sets the department of the student's primary thesis advisor, 
% 	which in very rare cases may not be the default, the student's own.
%
\newcommand\advisordepartment[1]{\gdef\@advisordepartment{#1}}
\advisordepartment{\def@ult}
%
% This internal command sets various formatted commands for signatories to the thesis.
%
\def\fau@setsignatory#1[#2]#3[#4]{\gdef#1{[#2][#3][#4]}}


%%% Co-Advisor (required only for the coadvisors class option)
% 
% This optional command sets the name and titles of the student's thesis co-advisor, when applicable.
% 	e.g., \coadvisor[Dr.]{Korey Sorge}[Ph.D.]
% The first and last arguments are optional, and the defaults are as shown here.
%
\newcommand\coadvisor[1]{\gdef\@coadvisor{#1}}

%
% This optional command sets the position title of the student's primary thesis advisor, 
% 	which may not always be the default that depends.
%
\newcommand\coadvisortitle[1]{\gdef\@coadvisortitle{#1}}
\coadvisortitle{Dissertation Co-Advisor}

%


%


%%% Program Department Chair
% 
% This required command sets the name and titles of the student's department chair.
% 	e.g., \chair[Dr.]{Warner A.~Miller}[Ph.D.]
% The first and last arguments are optional, and the defaults are as shown here.
\newcommand\chair[1]{\gdef\@chair{#1}}

\def\@chair{\ClassError{erauthesis}{\protect\chair\space undefined}
	{Please specify your \protect\chair\space for the signature page.}}
%
% This optional command sets the position title of the student's department chair, 
% 	which may not always be the default "Chair".
%	e.g., \chairtitle{Interim Chair} or \chairtitle{Director}
%
\newcommand\chairtitle[1]{\gdef\@chairtitle{#1}}
\chairtitle{Ph.D. Program Chair}


%%% Department Chair
% 
% This required command sets the name and titles of the student's department chair. 
\newcommand\depchair[1]{\gdef\@depchair{#1}}

\newcommand\depchairtitle[1]{\gdef\@depchairtitle{#1}}
\depchairtitle{Department Chair}

%%% Members
\newcommand\committememzero[1]{\gdef\@committememzero{#1}}


\newcommand\committememone[1]{\gdef\@committememone{#1}}


\newcommand\committememtwo[1]{\gdef\@committememtwo{#1}}

\newcommand\committememthree[1]{\gdef\@committememthree{#1}}


\newcommand\committememfour[1]{\gdef\@committememfour{#1}}


\newcommand\committememtitle[1]{\gdef\@committememtitle{#1}}
\committememtitle{Committee Member}


%%% College Dean
% 
% This required command sets the name and titles of the student's college dean.
% 	e.g., \dean[Dr.]{Gary W.~Perry}[Ph.D.]
% The first and last arguments are optional, and the defaults are as shown here.
\newcommand\dean[1]{\gdef\@dean{#1}}

\def\@dean{\ClassError{erauthesis}{\protect\dean\space undefined}
	{Please specify your \protect\dean\space for the signature page.}}

% This optional command sets the position title of the student's college dean, 
% 	which may not always be the default "Dean".
%	e.g., \deantitle{Interim Dean}
%
\newcommand\deantitle[1]{\gdef\@deantitle{#1}}
\deantitle{Dean, College of Engineering}


%%% Dean of the Graduate College
% 
% This required command sets the name and titles of the Dean of the Graduate College.
% 	e.g., \dgc[Dr.]{Deborah L.~Floyd}[Ed.D.]
% The first and last arguments are optional, and the defaults are as shown here.
\newcommand\dgc[1]{\gdef\@dgc{#1}}

\def\@dgc{\ClassError{erauthesis}{\protect\dgc\space undefined}
	{Please specify the Dean of the Graduate College for the signature page.}}
%
% This optional command sets the position title of the Dean of the Graduate College, 
% 	which may not always be the default "Dean".
%	e.g., \dgctitle{Interim Dean}
%
\newcommand\dgctitle[1]{\gdef\@dgctitle{#1}}
\dgctitle{\begin{tabular}{c}Senior Vice President for Academic\\Affairs and Provost\end{tabular}}



%%%
% 
% Front Matter Page Commands
%
% 	Every thesis should execute the following commands after the \begin{document}.
%	Each produces an entire formatted page from information specified in the preamble.
%
%	\maketitle									(Formatted title page.)
%	\makecopyright								(Formatted copyright page.)
%	\makesignature								(Formatted signatures page.)
%
%	Details for each command follow.
%
%%%


%%% Frontmatter Counter
%
% The preliminary pages in a thesis must appear in a specific order.
% This counter helps produce warnings if that order is not used.
%
\newcount\fau@frontstage
\fau@frontstage=0


%%% Title Page (required)
%
% This redefines the LaTeX title page to show the information required by ERAU.
%
\renewcommand\maketitle{\clearpage
	\ifnum\fau@frontstage=0\else  \ClassWarning{erauthesis}{\protect\maketitle\space out of order}%
	\noindent\raisebox{0pt}[0pt][0pt]{%
		\begin{minipage}[t]{\hsize}\singlespacingone
			\textbf{Warning:} The title page of an ERAU thesis \textit{must} appear 
			at the front of the document. 
			Please revise your \LaTeX\ source accordingly.
	\end{minipage}}\vskip-\baselineskip
	\fi
	\thispagestyle{titlepage}%
	\noindent\raisebox{-1.0in}{%
		\begin{minipage}[t]{\hsize}%
			\@titleblockstyle
			{\def\\{\protect\linebreak}\@titleformat}%
			\vspace{4em}
                 
			By
                 
			\vspace{4em}
			\@author
		\end{minipage}}\par%
	\vspace{2.0in}%
	\begin{center}%
		A \@Dissertation\ Submitted to the College of Engineering Department of Mechanical 
		Engineering in Partial Fulfillment of the Requirements for the Degree of
		\@degree in \@department
	\end{center}%
	\clearpage}

%
% Define a page style for the title page, putting the University address in the footer, exactly 1.0in from the bottom.
%
\newcommand\ps@titlepage{\let\@oddhead\@empty%
	\setlength\footskip{9.0in}%
	\addtolength\footskip{-\textheight}%
	\def\@oddfoot{\hfill
		\raisebox{0pt}[0pt][0pt]{\parbox[b]{6in}{\centering
  % \\Embry Riddle Aeronautical University\\
  Embry Riddle Aeronautical University\\
				Daytona Beach, FLorida\\
				% \@gradmonth\ \@gradyear\\
				\@gradmonth\ \@gradyear
				}}}\hfill}


%%% Signature Page (required)
%
% This sets a page for the signatures of the student's committee and University officials.
% It uses the information from the preamble.
%
\newcommand\makesignature{\clearpage
	\advance\fau@frontstage by 1
	\ifnum\fau@frontstage=1\else  \ClassWarning{erauthesis}{\protect\makesignature\space out of order}%
	\noindent\raisebox{0pt}[0pt][0pt]{%
		\begin{minipage}[t]{\hsize}\singlespacingone
			\textbf{Warning:} The signature page of an ERAU thesis \textit{must} appear 
			between the title and acknowledgements pages.
			Please revise your \LaTeX\ source accordingly.
	\end{minipage}}\vskip-\baselineskip
	\fi
	\noindent\raisebox{-0.3in}{%
		\begin{minipage}[t]{\hsize}%
			\@titleblockstyle
			{\def\\{\protect\linebreak}\@titleformat}
   
			\vspace{1em}
			By
   
			\vspace{1em}
			\@author
   
			\vspace{1em}			
	\end{minipage}}\par\null\par
	\noindent\begin{minipage}[t]{\hsize}\singlespacingone
		\ifx\@signatureblock\relax
  
    \ifdefined\@coadvisor
  This \expandafter{\@Dissertation} was prepared under the direction of the candidate's committee chair Dr. \expandafter{\@advisor} and Co-advisor Dr. \expandafter{\@coadvisor}, Daytona Beach Campus and Dissertation Committee Members, Dr. \expandafter{\@committememone}, Daytona Beach Campus, Dr. \expandafter{\@committememtwo}, Daytona Beach Campus,Dr. \expandafter{\@committememthree}, Daytona Beach Campus and Dr. \expandafter{\@committememfour}, Daytona Beach Campus, and has been approved by the Dissertation Committee. It was submitted to the Department of Mechanical Engineering in partial fulfillment of the requirements for the degree of Doctor of Philosophy in Mechanical Engineering.
\else
  This \expandafter{\@Dissertation} was prepared under the direction of the candidate's committee chair Dr. \expandafter{\@advisor}, Daytona Beach Campus and Dissertation Committee Members, Dr. \expandafter{\@committememzero}, Daytona Beach Campus, Dr. \expandafter{\@committememone}, Daytona Beach Campus, Dr. \expandafter{\@committememtwo}, Daytona Beach Campus,Dr. \expandafter{\@committememthree}, Daytona Beach Campus and Dr. \expandafter{\@committememfour}, Daytona Beach Campus, and has been approved by the Dissertation Committee. It was submitted to the Department of Mechanical Engineering in partial fulfillment of the requirements for the degree of Doctor of Philosophy in Mechanical Engineering.
\fi

  
	 \@signatureblock  \fi
	\end{minipage}\par\null\par\vspace{.5em}
 	\noindent\begin{minipage}[t]{\hsize}\singlespacingone\centering
		Dissertation Review Committee:\par
	\end{minipage}
 \begin{minipage}[t]{0.5\linewidth}
    \centering
    \noindent\showsignature{2.5in}{\@advisortitle}{\@advisor\vspace{-3ex}}\\
\end{minipage}%
\begin{minipage}[t]{0.5\linewidth}
    \centering
    \ifdefined\@coadvisor
        \noindent\showsignature{2.5in}{\@coadvisortitle}{\@coadvisor\vspace{-2.5ex}}
    \else
        \ifdefined\@committememzero
            \noindent\showsignature{2.5in}{\@committememtitle}{\@committememzero\vspace{-2.5ex}}
        \fi
    \fi
\end{minipage}%
 \vspace{.4in}
    \begin{minipage}[t]{0.5\linewidth}
        \centering
        \noindent\showsignature{2.5in}{\@committememtitle}{\@committememone\vspace{-2.5ex}}
    \end{minipage}%
    \begin{minipage}[t]{0.5\linewidth}
        \centering
        \noindent\showsignature{2.5in}{\@committememtitle}{\@committememtwo\vspace{-2.5ex}}
        
    \end{minipage}%
\vspace{.3in}
    \begin{minipage}[t]{0.5\linewidth}
        \centering
        \noindent\showsignature{2.5in}{\@committememtitle}{\@committememthree\vspace{-2.5ex}}
        
    \end{minipage}%
    \begin{minipage}[t]{0.5\linewidth}
        \centering
        \noindent\showsignature{2.5in}{\@committememtitle}{\@committememfour\vspace{-3ex}}
    \end{minipage}%
\vspace{.3in}
    \begin{minipage}[t]{0.5\linewidth}
        \centering
        \noindent\showsignature{2.5in}{\@chairtitle}{\@chair\vspace{-2.5ex}},
            \end{minipage}%
    \begin{minipage}[t]{0.5\linewidth}
        \centering
        \noindent\showsignature{2.5in}{\@depchairtitle}{\@depchair\vspace{-2.5ex}}       
    \end{minipage}%
  \vspace{.3in}
  \begin{center}
    \begin{minipage}[t]{0.5\linewidth}\singlespacingone%
        \centering
        \noindent\showsignature{2.5in}{\@deantitle}{\@dean\vspace{-2.5ex}}\\
            \end{minipage}%
    \begin{minipage}[t]{0.5\linewidth}
        \centering
        \noindent\showsignature{2.5in}{\@dgctitle}{\@dgc\vspace{-5ex}}\\
        \end{minipage}%
\end{center}
	}
%
% This command typesets a single signature box: 
%	of width #1, 
%	containing the signature of #2, 
%	whose title is #3, which is suppressed if #3 = \relax.
% This command is internal, and should not be called directly by the author.
%
\newcommand\showsignature[3]{%
    \begin{minipage}[t]{#1}\singlespacingone%\@signaturesize
        \centering % add \centering command
        \parbox[b]{\hsize}{\null\hrulefill\vskip-2.5ex}\par\vskip-10ex
        \ifx#3\relax\else
            \begin{center} % center the title
                #3%
            \end{center}
        \fi % end if statement
        \begin{center} % center the name
            #2\vspace{-1ex}% add negative vertical space
        \end{center}
    \end{minipage}}
 \newcommand\showsignatureone[3]{%
	\begin{minipage}[t]{#1}\singlespacingone%\@signaturesize
		\parbox[b]{\hsize}{\null\hrulefill}\par\vskip-3.5ex
		  \ifx#3\relax\else  #3  \fi 	% use \rlap{#3}\par instead of #3\par to allow title to overflow
		\expandafter\pretitle#2 
        \end{minipage}}
  
%
% This command pulls the first supervisor on the \@committee list into the command \@thissupervisor.
% This command is internal and should not be called directly by the author.
%
\newcommand\getthissupervisor{\expandafter\fau@getthissupervisor\the\@committee\st@p}
\def\fau@getthissupervisor[#1][#2][#3]#4\st@p{%
	\advance\@supervisors by -1%
	\@committee={#4}%
	\def\@thissupervisor{[#1][#2][#3]}}
%
% These commands set thesis signatories with titles either before (e.g., Dr.) or after (e.g., Ph.D.) the name.
%
\def\pretitle[#1][#2][#3]{#1~#2}
\def\posttitle[#1][#2][#3]{#2, #3{}}
%
% This optional environment overrides the default text above the signatures.
% It should be used in the preamble, and only if the default text is clearly incorrect.
%
\newenvironment{signaturetext}{\begingroup\@temptokena={}\@readblock}
	{\edef\@act{\noexpand\gdef\noexpand\@signatureblock{\the\@temptokena}}\@act\endgroup}
%
% This internal command supports the signaturetext environment.
% It reads the contents of the environment into a token list, which then is stored for later use.
%
\long\def\@readblock#1\end#2{%
	\edef\@test{\expandafter\noexpand\csname#2\endcsname}%
	\expandafter\ifx\@test\signaturetext
		\toks@={#1}%
		\def\n@xt{\end{signaturetext}}%
	\else
		\toks@={#1 \end{#2}}%
		\let\n@xt\@readblock%
	\fi
	\edef\@act{\noexpand\@temptokena={\the\@temptokena\the\toks@}}\@act\n@xt}
%
% This default value produces the default boilerplate text on the signature page.
%
\let\@signatureblock\relax
%
% This optional command modifies the vertical space between the two signature blocks: 
% 		the block on the upper right with committee signatures, 
% 		and the block on the lower left with administration signatures.
% 	The argument is a pure number.
% 	Positive values add whitespace, while negative values allow overlap.
\newcommand\signaturepush[1]{\gdef\@signaturepush{\vskip 0pt plus #1fill\relax}\relax}
%
% By default no space is added or subtracted.
%
\let\@signaturepush\relax


%%%
% 
% Front Matter Page Environments
%
% 	Every thesis should execute the following commands after the \begin{document}.
%	Each produces an entire formatted page from information specified in the preamble.
%
%	\begin{ackowledgements} 					(Author's acknowledgements.)
%		... 
%	\end{ackowledgements}
%	\begin{abstract} 							(Abstract for thesis.)
%		... 
%	\end{abstract}
%
%	Details for each environment follow.
%
%%%
			
%%% Acknowledgements (required)
%
% This sets a page for the student's acknowledgements.
% The title for the page may be specified as an optional argument, 
%	as in \begin{acknowledgements}[Acknowledgments] ...
%
\newenvironment{acknowledgements}[1][Acknowledgements]{\clearpage\setlength\parindent{0.5in}%
	\global\advance\fau@frontstage by 2
	\addcontentsline{toc}{chapter}{ACKNOWLEDGEMENTS}
	\ifnum\fau@frontstage=3\else  \ClassWarning{erauthesis}{acknowledgements environment out of order}%
	\noindent\raisebox{0pt}[0pt][0pt]{%
		\begin{minipage}[t]{\hsize}\singlespacingone
			\textbf{Warning:} The acknowledgements page of an ERAU thesis \textit{must} appear 
			between the signature and abstract pages.
			Please revise your \LaTeX\ source accordingly.
	\end{minipage}}\vskip-\baselineskip
	\fi
	\noindent\raisebox{-0.3in}{%
		\begin{minipage}[t]{\hsize}%
			\@titleblockstyle
			{\def\@title{#1}\bfseries\@titleformat}%
	\end{minipage}}\par
	\vspace{3.0ex}
}
{\clearpage}


%%% Abstract (required)
%
% This sets a page for the abstract of the thesis.
% It also uses information specified in the preamble.
% The title for the page may be specified as an optional argument, 
%	as in \begin{abstract}[Abstract] ...
% It is the student's responsibility to make sure the abstract complies with the University's word count limits.
%
\renewenvironment{abstract}{\clearpage\setlength\parindent{0.5in}%
		\global\advance\fau@frontstage by 8
		\addcontentsline{toc}{chapter}{ABSTRACT}
		\ifnum\fau@frontstage=11\else  \ClassWarning{erauthesis}{abstract environment out of order}%
			\noindent\raisebox{0pt}[0pt][0pt]{%
				\begin{minipage}[t]{\hsize}\singlespacingone
					\textbf{Warning:} The abstract page(s) of an ERAU thesis \textit{must} appear 
						between the acknowledgements page and the table of contents.
						Please revise your \LaTeX\ source accordingly.
				\end{minipage}}\vskip-\baselineskip
		\fi
		\noindent\raisebox{-0.3in}{%
		\begin{minipage}[t]{\hsize}%
			\@titleblockstyle
			{\def\@title{Abstract}\bfseries\@titleformat}%
	\end{minipage}}\par
	\vspace{3.0ex}}
{\clearpage}


%%%
% 
% Front Matter Document Information
%
% 	Every thesis should execute the following commands after the \begin{document}.
%	Each produces a formatted section from information extracted from the document.
%
%	\tableofcontents
% 	\listoffigures
% 	\listoftables
%
%	These are currently given a standard format by the class author, 
%		which is based on the format for chapter headings from the main matter.
% 	Options to allow more control to document authors may be included in subsequent versions of the class.
%
%%%


%%% Table of Contents (required)
%
% This modifies the default LaTeX \tableofcontents command to: 
% 	incorporate a check for the proper page ordering, and 
% 	use the thesis title in the title block style for the heading, 
% 		unless the chaptertables class option is in effect.
%
\RequirePackage{tocloft}
\newcommand{\pagetableofcontents}{\cleardoublepage
	\advance\fau@frontstage by 16
	\ifnum\fau@frontstage=27\else  \ClassWarning{erauthesis}{\protect\tableofcontents\space out of order}%
	\noindent\raisebox{0pt}[0pt][0pt]{%
		\begin{minipage}[t]{\hsize}\singlespacingone
			\textbf{Warning:} The table of contents of an ERAU thesis \textit{must} appear 
			between the abstract and the list of tables. 
			Please revise your \LaTeX\ source accordingly.
	\end{minipage}}\vskip-\baselineskip
	\fi
	\clearpage
	% \tableofcontents
    \begingroup
        \singlespacingone
        \tableofcontents
    \endgroup
    }
\renewcommand{\contentsname}{TABLE OF CONTENTS}
\renewcommand{\cftbeforetoctitleskip}{-0.in}
\renewcommand{\cfttoctitlefont}{\hfill\normalsize\bfseries}
\renewcommand{\cftaftertoctitle}{\hfill}
\renewcommand{\cftaftertoctitleskip}{-0.6em}
\renewcommand{\cftchapfont}{\normalfont}
\renewcommand{\cftdotsep}{0.3}
\renewcommand{\cftchapleader}{\cftdotfill{\cftdotsep}}
\renewcommand{\cftbeforesecskip}{.1em}
\renewcommand{\cftbeforesubsecskip}{.1em}
\renewcommand{\cftbeforesubsubsecskip}{.1em}
\renewcommand{\cftchappagefont}{\normalfont}
\renewcommand{\cftchapdotsep}{\cftdotsep}
\renewcommand{\cftsecdotsep}{\cftdotsep}
\renewcommand{\cftsubsecdotsep}{\cftdotsep}
\renewcommand{\cftsubsubsecdotsep}{\cftdotsep}
\renewcommand{\cftchapaftersnum}{.}
\renewcommand{\cftsecaftersnum}{.}
\renewcommand{\cftsubsecaftersnum}{.}
\renewcommand{\cftsubsubsecaftersnum}{.}

%%% List of Tables (required if there are tables)
%
% This modifies the default LaTeX \listoftables command to: 
% 	incorporate a check for the proper page ordering, and 
% 	use the title block style for the heading, 
% 		unless the chaptertables class option is in effect.
%
\newcommand{\pagelistoftables}{\cleardoublepage
	\advance\fau@frontstage by 64
	\ifnum\fau@frontstage=123\else  \ClassWarning{erauthesis}{\protect\listoftables\space out of order}%
	\noindent\raisebox{0pt}[0pt][0pt]{%
		\begin{minipage}[t]{\hsize}\singlespacingone
			\textbf{Warning:} The list of tables of an ERAU thesis \textit{must} appear 
			between the table of contents and the list of figures. 
			Please revise your \LaTeX\ source accordingly.
	\end{minipage}}\vskip-\baselineskip
	\fi
	\clearpage
	\listoftables}
\renewcommand{\listtablename}{LIST OF TABLES}
\renewcommand{\cftbeforelottitleskip}{-0.1in}
\renewcommand{\cftlottitlefont}{\hfill\normalsize\bfseries}
\renewcommand{\cftafterlottitle}{\hfill\mbox{}%
	\\{\hspace{1.5em}\normalfont Table}\hfill{\normalfont Page}}
\renewcommand{\cftafterlottitleskip}{-0.6em}
%
% This advances the frontmatter counter without including a list of tables for theses containing no tables.
%
\newcommand\nolistoftables{%
	\advance\fau@frontstage by 64
	\ifnum\fau@frontstage=123\else  \ClassWarning{erauthesis}{\protect\nolistoftables\space out of order}%
	\cleardoublepage
	\noindent\raisebox{0pt}[0pt][0pt]{%
		\begin{minipage}[t]{\hsize}\singlespacingone
			\textbf{Warning:} The list of tables in an ERAU thesis \textit{must} appear 
			between the table of contents and the list of figures.  
			The command to omit the list of tables must appear in the same position.  
			Please revise your \LaTeX\ source accordingly.
	\end{minipage}}\vskip-\baselineskip
	\cleardoublepage
	\fi}
%%% List of Figures (required if there are figures)
%
% This modifies the default LaTeX \listoffigures command to: 
% 	incorporate a check for the proper page ordering, and 
% 	use the title block style for the heading, 
% 		unless the chaptertables class option is in effect.
%
\newcommand{\pagelistoffigures}{\cleardoublepage
	\advance\fau@frontstage by 32
	\ifnum\fau@frontstage=59\else  \ClassWarning{erauthesis}{\protect\listoffigures\space out of order}%
	\noindent\raisebox{0pt}[0pt][0pt]{%
		\begin{minipage}[t]{\hsize}\singlespacingone
			\textbf{Warning:} The list of figures of an ERAU thesis \textit{must} appear 
			between the list of tables and the beginning of the manuscript. 
			Please revise your \LaTeX\ source accordingly.
	\end{minipage}}\vskip-\baselineskip
	\fi
	\clearpage
	\listoffigures}
\renewcommand{\listfigurename}{LIST OF FIGURES}
\renewcommand{\cftbeforeloftitleskip}{-0.1in}
\renewcommand{\cftloftitlefont}{\hfill\normalsize\bfseries}
\renewcommand{\cftafterloftitle}{\hfill\mbox{}%
	\\{\hspace{1.5em}\normalfont Figure}\hfill{\normalfont Page}}
\renewcommand{\cftafterloftitleskip}{-0.6em}
%
% This advances the frontmatter counter without including a list of figures for theses containing no figures.
%
\newcommand\nolistoffigures{%
	\advance\fau@frontstage by 32
	\ifnum\fau@frontstage=59\else  \ClassWarning{erauthesis}{\protect\nolistoffigures\space out of order}%
		\cleardoublepage
		\noindent\raisebox{0pt}[0pt][0pt]{%
			\begin{minipage}[t]{\hsize}\singlespacingone
				\textbf{Warning:} The list of figures of an ERAU thesis \textit{must} appear 
					between the list of tables and the beginning of the manuscript. 
					The command to omit the list of figures must appear in the same position.
					Please revise your \LaTeX\ source accordingly.
			\end{minipage}}\vskip-\baselineskip
		\cleardoublepage
	\fi}




	
%%%%%%
%%%%%%
%% 
%%		INTERNAL FORMATTING COMMANDS
%%
%%		The following commands are used to format section headings and so forth.
%%		Individual authors probably do not need to study these carefully...
%%
%%%%%%
%%%%%%


%%% Font Formatting
%
% Closest to Time New Roman
%
\RequirePackage{mathptmx}


%%% Title Block Formatting
%
% This command specifies how the title of the thesis is to be formatted.
% Definitely best not to change this.
%
\newcommand\titleheadformat[2]{%
	\gdef\@titleblockstyle{#1}%
	\gdef\@titleformat{#2}}
%
% The default title block style is bold and all caps, except for math.
% 
\titleheadformat
	{\centering}%
	{{\MakeTextUppercase{\@title}}}%
%
% This command converts text to all caps, excluding: 
% 	anything set in inline math mode, and 
% 	anything enclosed in a \FixCase command.
% 
\newcommand\MakeTextUppercase[1]{%
	\begingroup
	\def\({$}\let\)\(%
	\protected@edef\@act{\endgroup			
		\noexpand\@maketextuppercase#1$\noexpand\@stop$\noexpand\@endtextuppercase}%
	\@act}
%
\def\@maketextuppercase#1$#2#3$#4\@endtextuppercase{%
	\uppercase{#1}%
	\ifx\@stop#2\else%
		$#2#3$%
		\@maketextuppercase#4\@endtextuppercase%
	\fi}
%
\newcommand\FixCase[1]{#1}


%%% Chapter Heading and Header Formatting
%
% Define class options for various formats of the heading at the top of each chapter.  Default is simplechapters.
%
\RequirePackage{titlesec}
\titleformat{\chapter}{\normalfont\bf\centering}{\thechapter.}{5pt}{\normalsize}
\titlespacing{\chapter}{0pt}{0pt}{0.5em}
\titleformat{\section}{\normalfont\bf}{\thesection.}{5pt}{\normalsize}
\titlespacing{\section}{1.5em}{0.5em}{0.5em}
\titleformat{\subsection}{\normalfont\bf}{\thesubsection.}{5pt}{\normalsize}
\titlespacing{\subsection}{1.5em}{0.5em}{0.5em}
\titleformat{\subsubsection}{\normalfont\bf}{\thesubsubsection.}{5pt}{\normalsize}
\titlespacing{\subsubsection}{1.5em}{0.5em}{0.5em}

\usepackage{fancyhdr}
\fancyhf{}
\fancyfoot[C]{\thepage}
\renewcommand{\headrulewidth}{0pt}
\pagestyle{fancy}



%%% Section Heading Formatting
%
% The following commands will be executed to format the headings for sections, subsections, etc.
% Each, in principle, can end with a command that takes a single argument.
%
\newcommand\sectionstyle{\normalsize\bfseries}
\newcommand\subsectionstyle{\normalsize\bfseries}
\newcommand\subsubsectionstyle{\normalsize\bfseries}
\newcommand\paragraphstyle{\small\bfseries}
\newcommand\subparagraphstyle{\small\bfseries}


%%% Caption Formatting
%
% This modifies the default LaTeX format for figure and table captions.
% 	Single-line captions are set centered under the figure.
%
\RequirePackage{setspace}
\RequirePackage{caption}
\DeclareCaptionLabelSeparator{space}{\hspace{0.6em}}
\DeclareCaptionLabelSeparator{doublenewline}{\\\vspace{1.3em}}
\newcommand{\figurecatipn}[1]{%
	\captionsetup{labelfont=it,labelsep=space,singlelinecheck=true,textfont=normal,justification=raggedright}
	\caption{#1}}
\newcommand{\tablecaption}[1]{%
	\captionsetup{labelsep=doublenewline,textfont=normal,justification=raggedright}
	\caption{#1}}
\newcommand{\tablesource}[1]{\par%
	\vspace{0.2em}#1}


%%% Footnote Formatting
%
% Make footnotes single-spaced.
%
\renewcommand\@makefntext[1]{\singlespacingone%
	\footnotesize  \parindent 1em%
	\noindent\hb@xt@1.8em{\hss\@makefnmark}#1}


%%% Black Quote Formatting
%
% Make block quotes single-spaced.
%
\renewenvironment{quotation}
               {\par\list{}{\listparindent 1.5em%
                        \itemindent    \listparindent
                        \rightmargin   \leftmargin
                        \parsep        \z@ \@plus\p@}%
                \singlespacingone\item\relax}
               {\par\endlist\ignorespaces}


%%% Bibliography Formatting
%
% This modifies the default LaTeX thebibliography environment to: 
% 	appear in the table of contents, and 
% 	list individual items single-spaced.
%
\renewcommand\bibname{REFERENCES}
\RequirePackage[nottoc]{tocbibind}
% \RequirePackage[round, sort&compress, authoryear]{natbib}
\RequirePackage[numbers,square,sort&compress]{natbib}
