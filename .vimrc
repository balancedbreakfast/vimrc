
set nocompatible
filetype off

set rtp+=~/.vim/bundle/Vundle.vim
call vundle#begin()

Plugin 'VundleVim/Vundle.vim'
Plugin 'scrooloose/nerdtree'
Plugin 'vim-syntastic/syntastic'
Plugin 'pangloss/vim-javascript'
Plugin 'mxw/vim-jsx'
Plugin 'tpope/vim-fugitive'

call vundle#end()
filetype plugin indent on

autocmd vimenter * NERDTree

syntax enable
set t_Co=256
set t_ut=
set tabstop=4
set softtabstop=4
set shiftwidth=4
set expandtab
set number
filetype indent on

set splitright
set splitbelow
set showmatch
set incsearch
set hlsearch

set path+=**
set wildignore+=**/node_modules/**
map <c-p> :find 
set wildmenu

let g:netrw_banner=0 "disable banner
let g:netrw_browse_split=4
let g:netrw_altv=1
let g:netrw_liststyle=3

let g:jsx_ext_required = 0

set statusline+=%#warningmsg#
set statusline+=%{SyntasticStatuslineFlag()}
set statusline+=%*

let g:syntastic_always_populate_loc_list = 1
let g:syntastic_auto_loc_list = 1
let g:syntastic_check_on_open = 1
let g:syntastic_check_on_wq = 0
let g:syntastic_javascript_checkers = ['eslint']
