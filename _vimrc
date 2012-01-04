set nocompatible
source $VIMRUNTIME/vimrc_example.vim
source $VIMRUNTIME/mswin.vim
"behave mswin
behave xterm

set diffexpr=MyDiff()
function! MyDiff()
	let opt = '-a --binary '
	if &diffopt =~ 'icase' | let opt = opt . '-i ' | endif
	if &diffopt =~ 'iwhite' | let opt = opt . '-b ' | endif
	let arg1 = v:fname_in
	if arg1 =~ ' ' | let arg1 = '"' . arg1 . '"' | endif
	let arg2 = v:fname_new
	if arg2 =~ ' ' | let arg2 = '"' . arg2 . '"' | endif
	let arg3 = v:fname_out
	if arg3 =~ ' ' | let arg3 = '"' . arg3 . '"' | endif
	let eq = ''
	if $VIMRUNTIME =~ ' '
		if &sh =~ '\<cmd'
			let cmd = '""' . $VIMRUNTIME . '\diff"'
			let eq = '"'
		else
			let cmd = substitute($VIMRUNTIME, ' ', '" ', '') . '\diff"'
		endif
	else
		let cmd = $VIMRUNTIME . '\diff'
	endif
	silent execute '!' . cmd . ' ' . opt . arg1 . ' ' . arg2 . ' > ' . arg3 . eq
endfunction

if has("gui_running")
	set guifont=Consolas:h11:cANSI
	set anti
endif

colorscheme molokai 
set hlsearch
set cindent
set vb t_vb=
set nocp
filetype plugin on
set nobackup
set nu
set tabstop=2
set shiftwidth=2
set tags=tags;/
set cursorline
set confirm
set expandtab
set browsedir=current
set path=.,,;

let g:netrw_cygwin = 0
let g:netrw_ssh_cmd = '"c:\~\Linux\plink.exe" -batch -T -ssh'
let g:netrw_scp_cmd = '"c:\~\Linux\pscp.exe" -batch -q -scp'
let g:netrw_sftp_cmd = '"c:\~\Linux\pscp.exe" -batch -q -sftp'

map <C-F12> :!ctags -R --c++-kinds=+p --fields=+iaS --extra=+q .<CR>

set makeprg=g++\ %\ -o\ %<
map <F2> :call SaveCurrentFile()<CR>
map <silent> <F3> :call CompileCurrentFile()<CR> 
map <F4> :call ViewCompiledOutput()<CR>
map <F5> :!type input \| %< <CR>
map <F6> :call CreateFromTemplate()<CR>
map <F10> :exec "!start cmd"<CR>
map <F11> :silent call system('explorer /select,' . substitute(expand('%:p'),'/','\','g'))<CR>
map <F12> :NERDTreeToggle<CR>
"Comment/uncomment lines
map ,c :s/^/\/\/ /<CR>:noh<CR>
map ,x :s/^\s*\/\/\s*//<CR>==:noh<CR>

function! SaveCurrentFile()
	if expand('%') == ''
		exec 'browse saveas ' . getcwd()
	else
		exec 'w'
	endif
endfunction

let g:gcc_compiler = 'g++'
let g:gcc_flags = '-O2 -Werror -Wall -Wextra -pedantic -Wshadow -Wpointer-arith -Wcast-qual -Weffc++ -Wno-variadic-macros'
function! CompileCurrentFile()
	let ext = expand('%:e')
	
	if ext=='tex'
		call Tex_CompileLatex()
	elseif (ext=='c') || (ext=='cpp')
		let gcc_command = g:gcc_compiler . ' ' . g:gcc_flags . ' ' . expand('%') . ' -o ' . expand('%<')
		echo "Compiling: " . gcc_command
		cexpr system(gcc_command)
		cwindow 5
	endif
endfunction

function! ViewCompiledOutput()
	let ext = expand('%:e')
	
	if ext == 'tex'
		call Tex_ViewLaTeX()
	elseif (ext == 'c') || (ext == 'cpp')
		exec '!' . expand('%<')
	endif
endfunction

function! CreateFromTemplate()
	let template_file='c:\~\code\contests\template.cpp'
	echo template_file
	if filereadable(template_file)
		exec 'read ' . template_file
	else
		echo 'Cannot read from ' . template_file
	endif
endfunction

"Search using id-utils:
map <C-F> :call g:IDSearchCurrentWord()<CR>
map <C-G> :call g:IDSearchCustom()<CR>

"Hide toolbars
map <silent> <C-F2> :if &guioptions =~# 'T' <Bar>
			\set guioptions-=T <Bar>
			\set guioptions-=m <bar>
			\else <Bar>
			\set guioptions+=T <Bar>
			\set guioptions+=m <Bar>
			\endif<CR>

" Remap the tab key to do autocompletion or indentation depending on the
" context (from http://www.vim.org/tips/tip.php?tip_id=102)
function! InsertTabWrapper()
    let col = col('.') - 1
    if !col || getline('.')[col - 1] !~ '\k'
        return "\<tab>"
    else
        return "\<c-p>"
    endif
endfunction
inoremap <tab> <c-r>=InsertTabWrapper()<cr>
inoremap <s-tab> <c-n>

" Highlight all instances of word under cursor, when idle.
" Type z/ to toggle highlighting on/off.
nnoremap z/ :if AutoHighlightToggle()<Bar>set hls<Bar>endif<CR>
function! AutoHighlightToggle()
  let @/ = ''
  if exists('#auto_highlight')
    au! auto_highlight
    augroup! auto_highlight
    setl updatetime=4000
    echo 'Highlight current word: off'
    return 0
  else
    augroup auto_highlight
      au!
      au CursorHold * let @/ = '\V\<'.escape(expand('<cword>'), '\').'\>'
    augroup end
    setl updatetime=500
    echo 'Highlight current word: ON'
    return 1
  endif
endfunction

" Always cd to the directory containing the file being edited
autocmd BufEnter * :silent lcd %:p:h

" Set shell to cygwin
"set shell=c:/cygwin/bin/bash
"set shellcmdflag=-c
"set shellxquote=\"

let $TMP="c:\\vimtmp"

" LaTeX settings
set shellslash
set grepprg=grep\ -nH\ $*
let g:tex_flavor='latex'
let g:Tex_DefaultTargetFormat='pdf'

" Navigation in wrapped mode
noremap  <buffer> <silent> <Up>   gk
noremap  <buffer> <silent> <Down> gj
noremap  <buffer> <silent> <Home> g<Home>
noremap  <buffer> <silent> <End>  g<End>
inoremap <buffer> <silent> <Up>   <C-o>gk
inoremap <buffer> <silent> <Down> <C-o>gj
inoremap <buffer> <silent> <Home> <C-o>g<Home>
inoremap <buffer> <silent> <End>  <C-o>g<End>

