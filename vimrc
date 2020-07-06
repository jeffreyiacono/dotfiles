" General
set nocompatible
set hidden                            " allow unsaved background buffers
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
  if has("gui_macvim")
    set guifont=Fira\ Code:h12
    set linespace=1
  else
    set guifont=DejaVu\ Sans\ Mono\ 9
  endif

  " Hide the toolbar
  set go-=T

  " Hide the scrollbar
  set go-=r

  " Default window size
  if &lines < 50
    set lines=50
  endif

  if &columns < 80
    set columns=80
  endif
else
  " Enable true color support
  if has("termguicolors")
    set termguicolors

    " Set escapes manually, so they work in tmux (see ':h xterm-true-color')
    let &t_8f = "[38;2;%lu;%lu;%lum"
    let &t_8b = "[48;2;%lu;%lu;%lum"
  endif

  " Highlight current line in console mode
  set cursorline
endif

" ----------------------------------------------------------------------------
"  Color scheme
" ----------------------------------------------------------------------------

set background=dark
color base16-oceanicnext

" ----------------------------------------------------------------------------
"  UI
" ----------------------------------------------------------------------------

set ruler                  " show the cursor position all the time
set nolazyredraw           " turn off lazy redraw
set relativenumber         " relative line numbers
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
set formatoptions-=t       " never wrap code
set textwidth=80           " wrap at 80 chars by default
set virtualedit=block      " allow virtual edit in visual block ..

" Wrap text sometimes
autocmd BufRead *.{md,markdown,txt} set formatoptions+=t

" Handlebars is HTML
autocmd BufRead *.{hjs,handlebars} set ft=html

" Use hard tabs when absolutely necessary
autocmd FileType make set noexpandtab

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
" Help
" ----------------------------------------------------------------------------

autocmd FileType typescript nnoremap <silent><buffer> K :ALEHover<CR>

" ----------------------------------------------------------------------------
" Lightline
" ----------------------------------------------------------------------------

let g:lightline = {
      \ 'colorscheme': 'base16',
      \ 'active': {
      \   'left': [ [ 'mode', 'paste' ],
      \             [ 'gitbranch', 'readonly', 'filename', 'modified' ] ]
      \ },
      \ 'component_function': {
      \   'gitbranch': 'fugitive#head'
      \ },
      \ }

function! LightlineReload()
  runtime autoload/lightline/colorscheme/base16.vim
  call lightline#init()
  call lightline#colorscheme()
  call lightline#update()
endfunction

" ----------------------------------------------------------------------------
"  fzf.vim
" ----------------------------------------------------------------------------

nmap <leader>f :GFiles<CR>
nmap <leader>r :Tags<CR>
nmap <leader>b :Buffers<CR>

" ----------------------------------------------------------------------------
"  .vimrc editing
" ----------------------------------------------------------------------------

" Automatically reload .vimrc after save
autocmd! BufWritePost .vimrc source % | call LightlineReload()
nmap <leader>v :e $MYVIMRC<CR>

" ----------------------------------------------------------------------------
"  ALE
" ----------------------------------------------------------------------------

let g:ale_fixers = {
  \ 'css': ['prettier'],
  \ 'javascript': ['prettier', 'eslint'],
  \ 'typescript': ['prettier', 'eslint'],
  \ 'typescriptreact': ['prettier', 'eslint'],
  \ }
let g:ale_fix_on_save = 1
let g:ale_sign_error = '❌'
let g:ale_sign_warning = '⚠️'

" Remove this line if you adopt another completion plugin, like Deoplete
let g:ale_completion_enabled = 1

nnoremap <silent> <C-]> :ALEGoToDefinition<CR>
nnoremap <silent> gd :ALEGoToDefinition<CR>
nnoremap <silent> gr :ALEFindReferences -relative<CR>

" ----------------------------------------------------------------------------
"  Git (Fugitive)
" ----------------------------------------------------------------------------

" Auto-clean fugitive buffers
autocmd BufReadPost fugitive://* set bufhidden=delete

nnoremap <leader>gd :Gdiff<cr>
nnoremap <leader>gD :diffoff!<cr><c-w>h:bd<cr>

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
"  Golang
" ----------------------------------------------------------------------------

autocmd FileType go setlocal nolist noexpandtab ts=4 sw=4 sts=0 tw=0

" ----------------------------------------------------------------------------
"  Relative :edit shortcuts
" ----------------------------------------------------------------------------

" Scratch toggle (scratch.vim)
function! ToggleScratch()
  if expand('%') == g:ScratchBufferName
    quit
  else
    Sscratch
  endif
endfunction

map <leader>s :call ToggleScratch()<CR>

" ---------------------------------------------------------------------------
"  Haskell
" ---------------------------------------------------------------------------

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

" The Silver Searcher
if executable('ag')
  " Use ag over grep
  set grepprg=ag\ --nogroup\ --nocolor

  " Use ag in CtrlP for listing files. Lightning fast and respects .gitignore
  let g:ctrlp_user_command = 'ag %s -l --nocolor -g ""'

  " ag is fast enough that CtrlP doesn't need to cache
  let g:ctrlp_use_caching = 0
endif

" Backup
set backupdir=~/.vim/backup
set directory=~/.vim/swap
set backup

" ---------------------------------------------------------------------------
"  Rename current file (hat tip @garybernhardt)
" ---------------------------------------------------------------------------

function! RenameFile()
    let old_name = expand('%')
    let new_name = input('New file name: ', expand('%'), 'file')
    if new_name != '' && new_name != old_name
        exec ':saveas ' . new_name
        exec ':silent !rm ' . old_name
        redraw!
    endif
endfunction
map <leader>n :call RenameFile()<cr>

" ---------------------------------------------------------------------------
"  Multipurpose tab key: (hat tip @garybernhardt, again)
"    Indent if we're at the beginning of a line. Else, do completion.
" ---------------------------------------------------------------------------

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
