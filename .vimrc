" Requires Vim 8.1+, vim-plug, node, and The Silver Searcher
"
" brew install the_silver_searcher

" Plugin Manager
" vim-plug config. Specify a directory for plugins
" - Avoid using standard Vim directory names like 'plugin'

" Install vim-plug
let data_dir = has('nvim') ? stdpath('data') . '/site' : '~/.vim'
if empty(glob(data_dir . '/autoload/plug.vim'))
  silent execute '!curl -fLo '.data_dir.'/autoload/plug.vim --create-dirs  https://raw.githubusercontent.com/junegunn/vim-plug/master/plug.vim'
  autocmd VimEnter * PlugInstall --sync | source $MYVIMRC
endif

call plug#begin('~/.vim/plugged')

" File System Sidebar
Plug 'scrooloose/nerdtree'
" Dark color scheme
Plug 'joshdick/onedark.vim'
" Ctrl-p file fuzzy search
Plug 'kien/ctrlp.vim'
" Lean status bar
Plug 'vim-airline/vim-airline'
" Shows symbols for git diffs in the gutter (where the line numbers are)
Plug 'airblade/vim-gitgutter'
" Intuitive commands for quoting/parenthesizing/surrounding some word/text
Plug 'tpope/vim-surround'
" Syntax highlighting for like all languages
Plug 'pangloss/vim-javascript'
" Typescript
Plug 'leafgarland/typescript-vim'
" React jsx/tsx indentation
Plug 'maxmellon/vim-jsx-pretty'

" Language Server (Intellisense) Engine
" Need to install language servers if on a new machine. For example - :CocInstall coc-tsserver coc-json coc-html coc-css coc-eslint coc-prettier
Plug 'neoclide/coc.nvim', {'branch': 'release'}

" Plugin system end
call plug#end()

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
set redrawtime=10000
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

" Turn off auto-indent when pasting in insert mode
let &t_SI .= "\<Esc>[?2004h"
let &t_EI .= "\<Esc>[?2004l"

inoremap <special> <expr> <Esc>[200~ XTermPasteBegin()

function! XTermPasteBegin()
  set pastetoggle=<Esc>[201~
  set paste
  return ""
endfunction

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

" ===== CoC.nvim Config =====
" Always show the signcolumn, otherwise it would shift the text each time
" diagnostics appear/become resolved.
set signcolumn=yes

" Faster buffer update time, for gitgutter, coc.nvim, but affects the whole
" environment
set updatetime=300

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

" Typescript Syntax on tsx files
augroup SyntaxSettings
  autocmd!
  autocmd BufNewFile,BufRead *.tsx set filetype=typescriptreact
augroup END

" Syntax on jsx files
augroup SyntaxSettings
  autocmd!
  autocmd BufNewFile,BufRead *.jsx set filetype=javascriptreact
augroup END

" for jsx linting to be enabled in regular .js files
let g:jsx_ext_required = 0

" gf commmand (go to file) working for node_module ES6 imports... Amazing...
" Careful that it could break other languages, but unlikely because I think it
" just works as a fallback mechanism, so at worst doing gf in python if it's
" not importing from a proper relative path for example would come back as 'file not found'.
set path=.,src,node_nodules
set suffixesadd=.js,.jsx
function! LoadMainNodeModule(fname)
    let nodeModules = "./node_modules/"
    let packageJsonPath = nodeModules . a:fname . "/package.json"

    if filereadable(packageJsonPath)
        return nodeModules . a:fname . "/" . json_decode(join(readfile(packageJsonPath))).main
    else
        return nodeModules . a:fname
    endif
endfunction
set includeexpr=LoadMainNodeModule(v:fname)
