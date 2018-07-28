#!/usr/bin/env bash
[[ $# -lt 1 ]] && echo "<filepath>" && exit 1

filepath="$1"
basename=${filepath##*/}
dirpath=$(dirname $filepath)

tmpfile=$(mktemp)
rm $tmpfile
trap "rm -f $tmpfile; exit 1" 1 2 3 15

# echo $filepath |
tmp_vimrc=$(mktemp)
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

syntax on

nnoremap qq :q<CR>
nnoremap q! :q!<CR>
nnoremap ww :w<CR>
nnoremap wq :wq<CR>
EOF

cmdcheck() { type >/dev/null 2>&1 "$@"; }
cmdcheck 'nvim' && alias vim='nvim'

vim -u $tmp_vimrc -c "e! $tmpfile" -c "call setline(1, \"$basename\")" -c "start"
code=$?
[[ ! -e $tmpfile ]] || [[ $code != 0 ]] && exit 1

newfilepath="$dirpath/$(cat $tmpfile)"
echo mv -i "$filepath" "$newfilepath"
mv -i "$filepath" "$newfilepath"