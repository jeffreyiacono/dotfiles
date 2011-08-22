" Required setup for pathogen.vim
filetype on  " vim does not like `filetype off` if it isn't on
filetype off " force reload just in case (for pathogen.vim)
call pathogen#helptags()
call pathogen#runtime_append_all_bundles()

" General
set nocompatible
set history=1000
set autoread                          " reload files (no local changes only)
set modeline                          " make sure modeline support is enabled
filetype plugin indent on             " load filetype plugin
set isk+=_,$,@,%,#,-                  " non word dividers

" UTF-8 default encoding
set enc=utf-8

" ----------------------------------------------------------------------------
"  Platform detection
" ----------------------------------------------------------------------------

let s:platform = system("uname")
let s:on_linux = s:platform =~? "linux"
let s:on_mac   = has('macunix') || s:platform =~? "Darwin"

" ----------------------------------------------------------------------------
" Custom filetypes
" ----------------------------------------------------------------------------

autocmd BufNewFile,BufRead *.mxml set filetype=mxml
autocmd BufNewFile,BufRead *.as set filetype=actionscript

autocmd BufNewFile,BufRead *.mxml compiler flex
autocmd BufNewFile,BufRead *.as compiler flex


" ----------------------------------------------------------------------------
"  Folding
" ----------------------------------------------------------------------------
set nofoldenable
set foldmethod=syntax
set foldlevel=1
set foldnestmax=5

" Don't screw up folds when inserting text that might affect them, until
" leaving insert mode. Foldmethod is local to the window. Protect against
" screwing up folding when switching between windows.
" Source: http://vim.wikia.com/wiki/Keep_folds_closed_while_inserting_text
autocmd InsertEnter * if !exists('w:last_fdm') | let w:last_fdm=&foldmethod | setlocal foldmethod=manual | endif
autocmd InsertLeave,WinLeave * if exists('w:last_fdm') | let &l:foldmethod=w:last_fdm | unlet w:last_fdm | endif

" ----------------------------------------------------------------------------
"  Tabularize
" ----------------------------------------------------------------------------

if exists(":Tabularize")
  nmap <Leader>a=> :Tabularize /=><CR>
  vmap <Leader>a=> :Tabularize /=><CR>
  nmap <Leader>a= :Tabularize /=<CR>
  vmap <Leader>a= :Tabularize /=<CR>
  nmap <Leader>a: :Tabularize /:\zs<CR>
  vmap <Leader>a: :Tabularize /:\zs<CR>
endif

" ----------------------------------------------------------------------------
"  GUI
" ----------------------------------------------------------------------------

if has("gui_running")
  set background=dark
  color ir_black

  if has("gui_macvim")
    set guifont=Menlo:h12
  else
    set guifont=Droid\ Sans\ Mono\ 9
  endif

  " Hide the toolbar
  set go-=T

  " Default window size
  set lines=59
  set columns=110
endif

" ----------------------------------------------------------------------------
"  UI
" ----------------------------------------------------------------------------

set ruler                  " show the cursor position all the time
set nolazyredraw           " turn off lazy redraw
set number                 " line numbers
set ch=1                   " command line height
set backspace=2            " allow backspacing over everything in insert mode
set whichwrap+=<,>,h,l,[,] " backspace and cursor keys wrap to
set shortmess=filtIoOA     " shorten messages
set report=0               " tell us about changes
set nostartofline          " don't jump to the start of line when scrolling

set wildmenu               " turn on wild menu
set wildmode=list:longest,full
set infercase
set completeopt=longest,menu,menuone
set wildignore+=*.o,*.obj,*.pyc,*.DS_STORE,*.sqlite3

" ----------------------------------------------------------------------------
" Visual Cues
" ----------------------------------------------------------------------------

set showmatch              " brackets/braces that is
set mat=5                  " duration to show matching brace (1/10 sec)
set laststatus=2           " always show the status line
set nohlsearch             " don't highlight searches
set novisualbell           " don't blink
set noerrorbells           " shut the fuck up

" ----------------------------------------------------------------------------
" Text Formatting
" ----------------------------------------------------------------------------

set autoindent             " automatic indent new lines
set smartindent            " be smart about it
set nowrap                 " do not wrap lines
set softtabstop=2          " yep, two
set shiftwidth=2           " ..
set shiftround             " ... + > = .... (4) instead of ..... (5)
set tabstop=4
set expandtab              " expand tabs to spaces
set nosmarttab             " fuck tabs
set formatoptions+=n       " support for numbered/bullet lists
set textwidth=80           " wrap at 80 chars by default
set virtualedit=block      " allow virtual edit in visual block ..

" Use hard tabs when absolutely necessary
autocmd FileType make   set noexpandtab
autocmd FileType python set noexpandtab

" Syntax highlighting
syntax on

" Highlight trailing whitespace
set list listchars=trail:.,tab:>.

" Search & Replace
set ignorecase
set smartcase
set incsearch

" ----------------------------------------------------------------------------
"  Navigation
" ----------------------------------------------------------------------------

" Tab navigation
map <D-S-]> gt
map <D-S-[> gT
map <D-S-1> 1gt
map <D-S-2> 2gt
map <D-S-3> 3gt
map <D-S-4> 4gt
map <D-S-5> 5gt
map <D-S-6> 6gt
map <D-S-7> 7gt
map <D-S-8> 8gt
map <D-S-9> 9gt
map <D-S-0> :tablast<CR>

" Split-screen navigation
map <C-J> <C-W>j
map <C-K> <C-W>k
map <C-H> <C-W>h
map <C-L> <C-W>l
set wmh=0 " Allow splits to be zero-height

" , is easier to reach than backspace
let mapleader=","

" ----------------------------------------------------------------------------
"  .vimrc editing
" ----------------------------------------------------------------------------

" Automatically reload .vimrc after save
autocmd! BufWritePost .vimrc source %
nmap <leader>v :tabedit $MYVIMRC<CR>

" ----------------------------------------------------------------------------
"  Gist
" ----------------------------------------------------------------------------

let g:gist_detect_filetype = 1

if s:on_mac
  let g:gist_clip_command = 'pbcopy'
elseif s:on_linux
  let g:gist_clip_command = 'xclip -selection clipboard'
endif

" ----------------------------------------------------------------------------
"  Relative :edit shortcuts
" ----------------------------------------------------------------------------

map <leader>ew :e <C-R>=expand("%:p:h") . "/" <CR>
map <leader>es :sp <C-R>=expand("%:p:h") . "/" <CR>
map <leader>ev :vsp <C-R>=expand("%:p:h") . "/" <CR>
map <leader>et :tabe <C-R>=expand("%:p:h") . "/" <CR>

" FuzzyFinder/FuzzyFinder TextMate
let g:fuzzy_ignore="*.log"
let g:fuzzy_matching_limit=70
map <leader>t :FuzzyFinderTextMate<CR>
map <leader>b :FuzzyFinderBuffer<CR>

" NERD_tree drawer toggle
map <leader>d :execute 'NERDTreeToggle ' . getcwd()<CR>

" Scratch toggle (scratch.vim)
function! ToggleScratch()
  if expand('%') == g:ScratchBufferName
    quit
  else
    Sscratch
  endif
endfunction

map <leader>s :call ToggleScratch()<CR>

" use ghc functionality for haskell files
au Bufenter *.hs compiler ghc

" Configure browser for haskell_doc.vim
let g:haddock_browser = "open"
let g:haddock_browser_callformat = "%s %s"


" ---------------------------------------------------------------------------
"  Strip all trailing whitespace in file
" ---------------------------------------------------------------------------

function! StripWhitespace()
    exec ':%s/ \+$//gc'
endfunction
map <leader>w :call StripWhitespace()<CR>

" Use ack for grep
set grepprg=ack
set grepformat=%f:%l:%m

" Backup
set backupdir=~/.vim/backup
set directory=~/.vim/swap
set backup

