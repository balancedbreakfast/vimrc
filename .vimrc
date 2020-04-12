" Requires Vim 7.4+, eslint, tern-config, and The Silver Searcher
"
" brew install the_silver_searcher

" Vundle boilerplate and plugins
set nocompatible
filetype off

set rtp+=~/.vim/bundle/Vundle.vim
call vundle#begin()

" Plugin Manager
Plugin 'VundleVim/Vundle.vim'

" File System Sidebar
Plugin 'scrooloose/nerdtree'

" Git commands within vim
Plugin 'tpope/vim-fugitive'

" Dark color scheme
Plugin 'joshdick/onedark.vim'

" Ctrl-p file fuzzy search
Plugin 'kien/ctrlp.vim'

" Linting Engine
Plugin 'w0rp/ale'

" Lean status bar
Plugin 'vim-airline/vim-airline'

" Shows symbols for git diffs in the gutter (where the line numbers are)
Plugin 'airblade/vim-gitgutter'

" Automatically opens autocomplete popup menu (easy to forget this is a thing
" that needs to be configured)
Plugin 'vim-scripts/AutoComplPop'

" Intuitive commands for quoting/parenthesizing/surrounding some word/text
" with something else
Plugin 'tpope/vim-surround'

" Syntax highlighting for like all languages
Plugin 'sheerun/vim-polyglot'

call vundle#end()
filetype plugin indent on

" ======================================
" = Environment Specific Configuration =
" ======================================

" Change cursor shape between insert and normal mode in iTerm2.app
if $TERM_PROGRAM =~ "iTerm"
    let &t_SI = "\<Esc>]50;CursorShape=1\x7" " Vertical bar in insert mode
    let &t_EI = "\<Esc>]50;CursorShape=0\x7" " Block in normal mode
endif

" ======================================
" ======= User Interface/Style  ========
" ======================================

" Basic Setup - colors, tabs, line numbers
syntax on
set t_Co=256
set t_ut=
colorscheme onedark
set tabstop=2
set softtabstop=2
set shiftwidth=2
set expandtab
set number
filetype indent on
set relativenumber
set linebreak

" Show whitespace characters
set listchars=eol:¬,tab:>·,trail:~,extends:>,precedes:<,space:␣
set list

" Make the active split more obvious by making the status bar lighter
hi StatusLine   ctermfg=15  guifg=#ffffff ctermbg=239 guibg=#4e4e4e cterm=bold gui=bold

" Set relative filepath in status bar
set statusline+=%f

" Search config, highlighting, show match as I'm typing
set showmatch
set incsearch
set hlsearch


" ======================================
" ==== Quality of Life/Ease of Use =====
" ======================================

" Automatically enters NERDTree on vim command
autocmd vimenter * NERDTree

" autosave
set autowriteall

" Spell check on markdown files
autocmd FileType markdown setlocal spell spelllang=en_us

" Make backspace work as intended
set backspace=indent,eol,start

" Config for new splits opening to the right and bottom
set splitright
set splitbelow

" Opens buffers from quickfix in a new tab by default or switches to the
" existing tab if it is already open
set switchbuf+=usetab,newtab

" Config to search current working dir and ignore node_modules
set path+=**
set wildignore+=**/node_modules/**
set wildmenu

" Cleanup netrw default vim file browser
let g:netrw_banner = 0
let g:netrw_liststyle = 3
let g:netrw_browse_split = 4
let g:netrw_altv = 1
let g:netrw_winsize = 25



" ======================================
" ==== Custom Commands and Hotkeys =====
" ======================================

" Ctrl hjkl to move between splits
noremap <C-h> <C-w>h
noremap <C-j> <C-w>j
noremap <C-k> <C-w>k
noremap <C-l> <C-w>l

" Jump to CSS definition using :CSS
function! JumpToCSS()
  set iskeyword+=-
  let id_pos = searchpos("id", "nb", line('.'))[1]
  let class_pos = searchpos("class", "nb", line('.'))[1]

  if class_pos > 0 || id_pos > 0
    if class_pos < id_pos
      execute ":vim '#".expand('<cword>')."' **/*.css"
      execute ":normal zz"
    elseif class_pos > id_pos
      execute ":vim '.".expand('<cword>')."' **/*.css"
      execute ":normal zz"
    endif
  endif
endfunction
:command CSS :call JumpToCSS()

" Ctrl-C copies selection to the system clipboard
vnoremap <C-c> :w !pbcopy<CR><CR>



" ======================================
" ========= Plugin Enhancements =========
" ======================================

" The Silver Searcher
if executable('ag')
    " Use ag over grep
    set grepprg=ag\ --nogroup\ --nocolor

    " Bind K to grep word under cursor (only works w/ TSS)
    nnoremap K :grep! "\b<C-R><C-W>\b"<CR>:cw<CR>

    " Enable Search command to search project for string
    command -nargs=+ -complete=file -bar Search silent! grep! <args>|cwindow|redraw!

    " Use ag in CtrlP for listing files
    " let g:ctrlp_user_command = 'ag %s -l --nocolor -g ""'

    " ag is fast enough that CtrlP doesnt need to cache. Also not caching
    " allows you to find newly created files without restarting vim
    let g:ctrlp_use_caching = 0
endif

" ignore node_modules and other files when using ctrl-p
let g:ctrlp_custom_ignore = 'node_modules\|DS_Store\|git'

" Ale linting QoL settings
let g:ale_sign_error = '●' " Less aggressive than the default '>>'
let g:ale_sign_warning = '.'

" Set this to config Ale with Airline.
let g:airline#extensions#ale#enabled = 1


" ======================================
" ========Javascript Specific ==========
" ======================================

" Javascript Folding
augroup javascript_folding
    au!
    au FileType javascript setlocal foldmethod=indent " This line causes lag when foldmethod-syntax
    " Set folds to be auto opened
    autocmd FileType javascript normal zR
augroup END

" for jsx linting to be enabled in regular .js files
let g:jsx_ext_required = 0


