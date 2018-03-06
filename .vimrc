" Requires Vim 7.4+, eslint, tern-config, and The Silver Searcher

" Vundle boilerplate and plugins
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
Plugin 'tomasiser/vim-code-dark'
Plugin 'joshdick/onedark.vim'
Plugin 'kien/ctrlp.vim'

call vundle#end()
filetype plugin indent on

" Automatically enters NERDTree on vim command
autocmd vimenter * NERDTree

" Basic Setup - colors, tabs, line numbers
syntax on
set t_Co=256
set t_ut=
colorscheme onedark
set tabstop=4
set softtabstop=4
set shiftwidth=4
set expandtab
set number
filetype indent on

" Config for new splits opening to the right and bottom
set splitright
set splitbelow

" Make the active split more obvious by making the status bar lighter
hi StatusLine   ctermfg=15  guifg=#ffffff ctermbg=239 guibg=#4e4e4e cterm=bold gui=bold

" Set relative filepath in status bar
set statusline+=%f

" Search config, highlighting, show match as I'm typing
set showmatch
set incsearch
set hlsearch

" Config to search current working dir and ignore node_modules
set path+=**
set wildignore+=**/node_modules/**
set wildmenu

" The Silver Searcher
if executable('ag')
    " Use ag over grep
    set grepprg=ag\ --nogroup\ --nocolor

    " Bind K to grep word under cursor (only works w/ TSS)
    nnoremap K :grep! "\b<C-R><C-W>\b"<CR>:cw<CR>

    " Enable Ag command to search project for string
    command -nargs=+ -complete=file -bar Ag silent! grep! <args>|cwindow|redraw!

    " Use ag in CtrlP for listing files
    let g:ctrlp_user_command = 'ag %s -l --nocolor -g ""'

    " ag is fast enough that CtrlP doesnt need to cache
    let g:ctrlp_use_caching = 0
endif

" Cleanup netrw default vim file browser
let g:netrw_banner=0 "disable banner
let g:netrw_browse_split=4
let g:netrw_altv=1
let g:netrw_liststyle=3

" for jsx linting to be enabled in regular .js files
let g:jsx_ext_required = 0

" Syntastic basic recommended config
set statusline+=%#warningmsg#
set statusline+=%{SyntasticStatuslineFlag()}
set statusline+=%*
let g:syntastic_always_populate_loc_list = 1
let g:syntastic_auto_loc_list = 1
let g:syntastic_check_on_open = 1
let g:syntastic_check_on_wq = 0
let g:syntastic_javascript_checkers = ['eslint']
