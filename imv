#!/usr/bin/env bash

setup_tmp_vimrc() {
	local tmp_vimrc=$(mktemp)
	trap "rm -f $tmp_vimrc; exit 1" 1 2 3 15
	cat >$tmp_vimrc <<EOF
set nocompatible
set autoindent
set expandtab
set incsearch
set number
set shiftwidth=4
set showmatch
set smartcase
set smartindent
set smarttab
set tabstop=4
set whichwrap=b,s,h,l,<,>,[,]
set backspace=indent,eol,start
set t_Co=256
set list
set ruler
set showcmd
set shortmess+=I
set laststatus=2
set encoding=utf-8
set fileencodings=utf-8,iso-2022-jp,cp932,sjis,euc-jp
set listchars=tab:»-,trail:-,extends:»,precedes:«,nbsp:%,eol:↲ " 不可視文字を表示
set wildmenu wildmode=list:full "入力補完機能
set ambiwidth=double

colorscheme desert

if ! has('nvim')
	cnoremap <Tab> <Up>
	cnoremap <S-Tab> <Down>
endif

au InsertEnter,VimEnter  * hi StatusLine term=reverse ctermbg=5 gui=undercurl guisp=Magenta | execute "set statusline=INSERT"
au InsertLeave,VimEnter  * hi StatusLine term=reverse ctermfg=0 ctermbg=2 gui=bold,reverse  | execute "set statusline=NORMAL"

syntax on

nnoremap qq :q<CR>
nnoremap q! :q!<CR>
nnoremap ww :w<CR>
nnoremap wq :wq<CR>

inoremap <C-d> <Delete>
inoremap <C-f> <BS>
vnoremap <C-d> <Delete>
vnoremap <C-f> <BS>
cnoremap <C-d> <Delete>
cnoremap <C-f> <BS>

inoremap <C-h> <Left>
inoremap <C-j> <ESC>:call <SID>Down()<CR>i
inoremap <C-k> <ESC>:call <SID>Up()<CR>i
inoremap <C-l> <Right>
EOF
}

function main() {
	[[ $# -lt 1 ]] && echo "<filepath>" && exit 1

	local filepath="$1"
	[[ ! -e "$filepath" ]] && echo "$0: $filepath: No such file or directory" && exit 1

	local target_basename="$(basename "$filepath")"
	local dirpath="$(dirname "$filepath")"

	local tmpfile=$(mktemp)
	rm $tmpfile
	trap "rm -f $tmpfile; exit 1" 1 2 3 15

	type >/dev/null 2>&1 'nvim' && alias vim='nvim'

	setup_tmp_vimrc
	vim -i NONE -u "$tmp_vimrc" -c "e! $tmpfile" -c "call setline(1, \"$target_basename\")" -c "start"
	local exit_code=$?
	[[ ! -e $tmpfile ]] || [[ $exit_code != 0 ]] && exit 1

	local newfilepath="$dirpath/$(cat $tmpfile)"
	echo mv -i "$filepath" "$newfilepath"
	mv -i "$filepath" "$newfilepath"
}
main "$@"
