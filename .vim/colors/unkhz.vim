" UNKHZ SYNTAX & INTERFACE COLORSCHEME for GUI...............................
" ...........................................................................
" vim: tw=0 ts=28 sw=3
" Vim color file

" Maintainer:	Juhani Pelli
" Last Change:	2006 Mar 29


" Load the syntax highlighting defaults, if it's enabled.
if exists("syntax_on")
  syntax reset
endif

" Try to sense the background darkness
hi clear
set bg&

let colors_name = "unkhz"

if &background == 'light'
   " MAIN SYNTAX GROUPS LIGHT ...............................................
   hi Comment	gui=none guifg=#1184cc
   hi Constant	gui=none guifg=#225500
   hi Identifier	gui=none guifg=#993300
   hi Statement	gui=none guifg=#000055
   hi PreProc	gui=NONE guifg=#990099
   hi Type	gui=NONE guifg=#222299
   hi Special	gui=none guifg=#330099
   hi Underlined	gui=underline guifg=#0000cc
   hi Ignore	gui=none guifg=#605854
   hi Error	gui=NONE guibg=#ffcccc guifg=#cc8888
   hi Todo	gui=NONE guifg=#994400 guibg=white
   
   " SYNTAX SUBGROUPS LIGHT
   hi Tag	gui=bold guifg=#007777

   " INTERFACE GROUPS LIGHT .................................................
   hi Normal	gui=none guifg=#443933 guibg=bg
   hi Visual	gui=none guifg=#606050 guibg=#ccc4bb
   hi Search	gui=none guifg=#663300 guibg=#cc7711
   hi Cursor	gui=NONE guifg=white guibg=#664422
   hi StatusLine	gui=bold guifg=bg guibg=#554433
   hi TabLineFill	gui=bold guifg=bg guibg=#554433
   hi TabLine	gui=bold guifg=bg guibg=#554433
   hi TabLineSel	gui=bold guibg=bg guifg=#554433
   hi StatusLine	gui=bold guifg=bg guibg=#554433
   hi LineNr	gui=none guifg=#5a4028
   hi ModeMsg	gui=none guifg=#ff0000 guibg=bg
   hi ErrorMsg	gui=none guifg=#ee6600 guibg=#440000
   hi SpecialKey	gui=none guifg=#0000ff   
   hi MatchParen            gui=bold guifg=#664422 guibg=bg

else
   
   " MAIN SYNTAX GROUPS DARK ...................................
   hi Comment	gui=none guifg=#334055
   hi Constant	gui=none guifg=#668822
   hi Identifier	gui=none guifg=#a84411
   hi Statement	gui=none guifg=#746699
   hi PreProc	gui=NONE guifg=#944494
   hi Type	gui=none guifg=#746699
   hi Special	gui=none guifg=#944499
   hi Underlined	gui=underline guifg=#000099
   hi Ignore	gui=none guifg=#605854
   hi Error	gui=NONE guibg=#220000 guifg=#993300
   hi Todo	gui=bold guibg=#776655 guifg=black
   
   " SYNTAX SUBGROUPS DARK 
   hi Tag	gui=bold guifg=#009999
   
   " INTERFACE GROUPS DARK ..................................................
   hi Normal	gui=none guifg=#999488 guibg=bg
   hi Visual	gui=none guifg=#777066 guibg=#332822
   hi Search	gui=none guifg=#ee9433 guibg=#994400
   hi Cursor	gui=NONE guifg=black guibg=#554433
   hi StatusLine	gui=bold guifg=bg guibg=#554433
   hi LineNr	gui=none guifg=#887755
   hi ErrorMsg	gui=none guifg=#ee6600 guibg=#440000
   hi ModeMsg	gui=none guifg=#ccc0bb guibg=bg   
   hi SpecialKey	gui=none guifg=#0000bb
   hi MatchParen            gui=bold guifg=#554433 guibg=bg

endif

" LINKED INTERFACE GROUPS ...................................................
"
hi! link CursorIM	Cursor
hi! link Directory	Underlined
" DiffAdd
" DiffChange
" DiffDelete
" DiffText
hi! link VertSplit	StatusLine
" Folded
" FoldColumn
" SignColumn
hi! link IncSearch	Search
hi! link MoreMsg	LineNr
hi! link NonText	LineNr
hi! link Question	ErrorMsg
hi! link StatusLineNC 	StatusLine
" Title
hi! link VisualNOS	Visual
hi! link WarningMsg	ModeMsg
" WildMenu
" Menu
" Scrollbar
" Tooltip

" LINKED SYNTAX SUBGROUPS ...................................................
hi link String 	Constant
hi link Character 	Constant
hi link Number 	Constant
hi link Boolean 	Constant
hi link Float 	Constant
hi link Function	Identifier
hi link Conditional	Statement
hi link Repeat	Statement
hi link Label	Statement
hi link Operator	Statement
hi link Keyword	Statement
hi link Exception	Statement
hi link Include	PreProc
hi link Define	PreProc
hi link Macro	PreProc
hi link PreCondit	PreProc
hi link StorageClass	Type
hi link Structure	Type
hi link Typedef	Type
hi link SpecialChar	Special
hi link Tag	Special
hi link Delimiter	Special
hi link SpecialComment	Special
hi link Debug	Special
