" Use Vim settings, rather then Vi settings (much better!).
" This must be first, because it changes other options as a side effect.
set nocompatible


" These settings will not be set more than once
if !exists("g:vimrc_already_sourced")
	let g:vimrc_already_sourced = 1

	" Windows compatibility settings
	"source $VIMRUNTIME/mswin.vim

	" Switch syntax highlighting on, when the terminal has colors
	" Also switch on highlighting the last used search pattern.
	if &t_Co > 2 || has("gui_running")
		syntax on
		set hlsearch
	endif

	if has("autocmd")
		" Enable file type detection.
		filetype plugin indent on
		" Put these in an autocmd group, so that we can delete them easily.
		augroup vimrcEx
		au!
		" When editing a file, always jump to the last known cursor position.
		" Don't do it when the position is invalid or when inside an event handler
		" (happens when dropping a file on gvim).
		autocmd BufReadPost *
			\ if line("'\"") > 0 && line("'\"") <= line("$") |
			\   exe "normal g`\"" |
			\ endif
		augroup END
	endif " has("autocmd")

	set diffexpr=MyDiff()
	function MyDiff()
		let opt = ""
		if &diffopt =~ "icase"
	let opt = opt . "-i "
		endif
		if &diffopt =~ "iwhite"
	let opt = opt . "-b "
		endif
		silent execute "!diff -a --binary " . opt . v:fname_in . " " . v:fname_new .
	\  " > " . v:fname_out
	endfunction


	" LOCAL SETTINGS ················································

	" Filetypes ...
	au BufRead,BufNewFile *.txt,*.nfo,*.text setlocal filetype=text
	au FileType text setlocal wrap
	au FileType text setlocal nonu
	au FileType text setlocal tabstop=20
	au FileType text setlocal formatoptions=wtcrqn
	au FileType text setlocal textwidth=78

	au BufRead,BufNewFile *.style setlocal filetype=bbstyle
	au FileType bbstyle setlocal nowrap
	au FileType bbstyle setlocal nu
	au FileType bbstyle setlocal tabstop=40

	au BufRead,BufNewFile *.log setlocal filetype=logfile
	au FileType logfile setlocal wrap
	au FileType logfile setlocal nonu
	au FileType logfile setlocal autoread

	au BufRead,BufNewFile *.bbi,*.bit,*.bo setlocal filetype=bbinterface
	au FileType BBInterface setlocal nowrap
	au FileType BBInterface setlocal nonu

	au BufRead,BufNewFile *.as,*.asc,*.aso setlocal filetype=actionscript
	au FileType actionscript setlocal nowrap
	au FileType actionscript setlocal nu
	au FileType actionscript setlocal smartindent
	au FileType actionscript setlocal pvh=8
	au FileType actionscript noremap <F6> :w!<cr>:!start mtasc.cmd -main -swf streamplayer.swf % Streamplayer.asc>result.log 2>&1 0>&1<cr>:ped result.log<cr>
	au FileType actionscript inoremap <F6> <esc>:w!<cr>:!start mtasc.cmd -main -swf streamplayer.swf Streamplayer.asc>result.log 2>&1 0>&1<cr>:ped result.log<cr>

	au BufRead,BufNewFile *.rc setlocal autoread
	au Filetype aspvbs setlocal nowrap
	au Filetype aspvbs setlocal nu
	au Filetype aspvbs setlocal smartindent

	au Filetype php setlocal nowrap
	au Filetype php setlocal nu

endif " end setonce


noremap <f3> <esc>:tab ball<cr>
inoremap <f3> <esc>:tab ball<cr>


" Default options {{{
set autoindent						" indenting
set backspace=indent,eol,start		" allow backspacing over everything in insert mode
set winaltkeys=no					" don't let windows hog the alt keys
set history=512						" keep n lines of command line history
set ruler							" show the cursor position all the time
set showcmd							" display incomplete commands
set incsearch						" do incremental searching
set nonu							" no line numbering
set nowrap							" no line wrapping
set lbr								" .. but if it's switched on, word wrap
set formatoptions=q					" no autoformatting of text
set laststatus=2					" statusline always
set showtabline=2					" tabline always
set shiftwidth=4					" indent size
set tabstop=4						" tab size
set noexpandtab						" no spaces, just tabs
set viminfo+=!						" save some vars to .viminfo
set virtualedit=onemore				" move one column after eol
set tabpagemax=256					" open unlimited number of tabs
set selectmode=						" Same select with mouse and visual
set statusline=%f\ %m\ %r\ %h\ %w\ %y\ %=<%b>\ <0x%B>\ %c,%l\ %P
set mouse=a							" Enable scrolling with mouse/touchpad

" }}}

" KEY MAPPINGS ····················································

" Saving ··················
nnoremap <C-S> :w!<CR>
inoremap <C-S> <esc>:w!<CR>

" backup ...
set backupdir=/tmp,./_backup
set backupskip=*.txt,*.nfo

" <tab> to <esc> ...
inoremap <s-`> `
nnoremap ` i
vnoremap ` <esc>
onoremap ` <esc>
inoremap ` <esc>

" Cursor Movement ································
noremap i k
noremap j h
noremap k j
noremap h ^
noremap ö $
noremap <a-i> <up>
noremap <a-j> <left>
noremap <a-k> <down>
noremap <a-l> <right>
noremap <a-h> <home>
noremap <a-ö> <end>
inoremap <a-i> <up>
inoremap <a-j> <left>
inoremap <a-k> <down>
inoremap <a-l> <right>
inoremap <a-h> <home>
inoremap <a-ö> <end>
inoremap <a-s-i> <s-up>
inoremap <a-s-j> <s-left>
inoremap <a-s-k> <s-down>
inoremap <a-s-l> <s-right>
inoremap <a-s-h> <s-home>
inoremap <a-s-Ö> <s-end>

noremap gi gk
noremap gk gj
noremap gö g$
noremap gh g^
noremap gs gh

" MultiWindow Movement ······························
noremap <C-W>I <C-W>i
noremap <C-W>k <C-W>j
noremap <C-W>i <C-W>k
noremap <C-W>j <C-W>h
noremap <C-W><C-k> <C-W>j
noremap <C-W><C-i> <C-W>k
noremap <C-W><C-j> <C-W>h

" Fast buffer switching
noremap <A-down> <esc>:tabnext<CR>
noremap <A-up> <esc>:tabprevious<CR>
inoremap <A-down> <esc>:tabnext<CR>
inoremap <A-up> <esc>:tabprevious<CR>
inoremap <a-n> <esc>:tabnext<cr>
inoremap <a-p> <esc>:tabprevious<cr>
noremap <a-n> <esc>:tabnext<cr>
noremap <a-p> <esc>:tabprevious<cr>
noremap <a-`> <esc>:tabnext<cr>
noremap <a-~> <esc>:tabprevious<cr>
noremap <c-`> <esc>:bnext!<cr>
noremap <c-~> <esc>:bprevious!<cr>

" Fast Settings
noremap <f1> :set nu!<cr>
inoremap <f1> <esc>:set nu!<cr>a
noremap <f2> :set wrap!<cr>
inoremap <f2> <esc>:set wrap!<cr>a

" Visual mode repeated indenting & fast clear
vnoremap < <gv
vnoremap > >gv
vnoremap <space> <esc>

" Explorer settings
let g:explVertical=1	" Split vertically
let g:explWinSize=20
command! E :Sexplore

let g:AutoExploreState = 0
if has("vertsplit")
	noremap <f5> <esc>:call ToggleAutoExplore()<CR>
	inoremap <f5> <esc>:call ToggleAutoExplore()<CR>
	"au BufWinEnter * call AutoExplore()
	fun! AutoExplore()
		silent exe 'on'
		if	g:AutoExploreState == 1
			if @% == ""
				20vsp .
			else
				exe "20vsp " . expand("%:p:h")
			endif
			"wincmd w
		endif
	endfun
	fun! ToggleAutoExplore()
		if	g:AutoExploreState == 1
			let g:AutoExploreState = 0
			echo 'not exploring'
			silent exe 'on'
		else
			let g:AutoExploreState = 1
			echo 'exploring'
			call AutoExplore()
		endif
	endfun
endif

" Load colors
if has("gui_running")
	gui
endif
colorscheme unkhz
"noremap <f5> <esc>:colo unkhz<cr>
"inoremap <f5> <esc>:colo unkhz<cr>a

