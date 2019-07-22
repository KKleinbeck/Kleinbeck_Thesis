\RequirePackage{xparse}
\NeedsTeXFormat{LaTeX2e}
\ProvidesExplClass{kleinbeck_thesis}{2016/25/07}{a.1.00}{Kevin Kleinbeck's Thesis class -- Book Version}




%=================================================================
%=================================================================
%       PACKAGES AND OPTIONS
%=================================================================
%=================================================================


%-----------------------------------------------------------------
%	Options
%-----------------------------------------------------------------

\RequirePackage{kvoptions}

\SetupKeyvalOptions%
{%
	family=thesis,
	prefix=thesis@,
}

\DeclareStringOption[1in]{topspace}
\DeclareStringOption[0pt]{bindingoffset}

\DeclareStringOption[none]{style}
\DeclareStringOption[./]{fontpath}

\DeclareBoolOption[true]{print}
\DeclareComplementaryOption{display}{print}

\DeclareBoolOption[true]{draft}
\DeclareComplementaryOption{final}{draft}

\DeclareVoidOption{math}{\RequirePackage{kleinbeck_math}}

\DeclareDefaultOption{%
	\PassOptionsToClass{\CurrentOption}{scrbook}%
}

\ProcessKeyvalOptions{thesis}\relax


%-----------------------------------------------------------------
%	Packages
%-----------------------------------------------------------------

\ifthesis@print
	\PassOptionsToClass{openright}{scrbook}%
	\PassOptionsToClass{twoside}{scrbook}%
\else
	\PassOptionsToClass{oneside}{scrbook}%
\fi

\LoadClass[toc=bibliography]{scrbook}



%-----------------------------------------------------------------
%	Option Processing
%-----------------------------------------------------------------

% To prevent option clashes, make sure to load xcolor before other packages
\RequirePackage[a4paper]{geometry}
\ifthesis@print
	\RequirePackage[cmyk]{xcolor}
	\geometry{includehead=true,head=10pt,bindingoffset=6mm,top=1in,inner=0.618in,outer=1.618in,bottom=2.618in}
\else
	\RequirePackage[HTML]{xcolor}
	\geometry{includehead=true,head=10pt,top=1in,left=1.618in,right=1.618in,bottom=2.618in}
	% Gauged, such that the number of pages and the page content equals the print version
	% By accident this matches the golden ratio approach
\fi

\ifthesis@draft
	\RequirePackage[l2tabu,orthodox]{nag}
	\RequirePackage{blindtext}
	\RequirePackage{todonotes}
	\RequirePackage{draftwatermark}
	\SetWatermarkText{Draft}
	\SetWatermarkVerCenter{.5\pageheight}
	\SetWatermarkHorCenter{.5\pagewidth}
	\SetWatermarkColor{gray!20!white}
	\setlength{\overfullrule}{5pt}
	\PassOptionsToPackage{draft=false}{graphicx}
\else
	\newcommand{\blindtext}[1][]%
	{%
		\PackageWarning{kleinbeck_thesis}{Warning:~In~>final<~mode;~\blindtext[]~no~longer~defined.}
	}%
	\newcommand{\Blindtext}[1][]%
	{%
		\PackageWarning{kleinbeck_thesis}{Warning:~In~>final<~mode;~\Blindtext[]~no~longer defined.}
	}%
	\newcommand{\todo}[1][]%
	{%
		\PackageWarning{kleinbeck_thesis}{Warning:~In~>final<~mode;~\todo{}~no~longer~defined.}
	}%
\fi


%-----------------------------------------------------------------
%	blank commands --- to be set in style files
%-----------------------------------------------------------------

\providecommand{\heading@format}[1]{#1}
\providecommand{\emph@font}[1]{#1}


%-----------------------------------------------------------------
%	Styles
%-----------------------------------------------------------------

\clist_new:N \kleinbeck_thesis_styles
\clist_put_left:Nn \kleinbeck_thesis_styles {stuttgart,}

\tl_const:Nn \kleinbeck_thesis_font_list {Algeria,Times,}
\tl_new:N \kleinbeck_thesis_font
\tl_new:N \kleinbeck_thesis_font_path



\newif\if@styleset
\@stylesetfalse
% SetStyle should get a KeyVal list as argument.
% Possible argumetns are:
%   Style
%   Font
%   FeatureFiles (for the fonts)


\keys_define:nn {style_module}
{
	font .code:n =%
	{
		\exp_args:NNx \tl_if_in:NnTF \kleinbeck_thesis_font_list {\tl_use:N \l_keys_value_tl}%
			{\tl_use:N \l_keys_value_tl}
			{Bye}
	},
	font~path .code:n = {\tl_set_eq:NN \kleinbeck_thesis_font_path \l_keys_value_tl},
}

\DeclareDocumentCommand{\SetStyle}{o m}%
{
    \IfNoValueF{#1}{\keys_set:nn {style_module} { #1 } }
	
	
	\if@styleset
		\PackageWarning{thesis}{You~already~set~a~style.~Check~your~previous~code.}
	\else
		\exp_args:Nxx \str_if_eq:nnTF {none}{#2}
		{
		}
		{
			\@stylesettrue
			\exp_args:NNx \clist_if_in:NnTF \kleinbeck_thesis_styles {#2}%
			{%
				\RequirePackage{#2}
			}%
			{%
				\PackageWarning{thesis}{Style~class~"\thesis@style"~is~not~known.~I~will~ignore~your~input.}
			}
		}
	\fi
}

\SetStyle{\thesis@style}
