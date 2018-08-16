" Inject and use Pathogen for loading plugins
execute pathogen#infect()

" Basic editor configuration
syntax on
filetype on
filetype plugin indent on
filetype plugin on
set omnifunc=syntaxcomplete#Complete

set hidden
set nowrap
set tabstop=4
set shiftwidth=4
set backspace=indent,eol,start
set autoindent
set copyindent
set number
set expandtab
set showmatch
set ignorecase
set smartcase
set smarttab
set hlsearch
set incsearch

" Increase history for UNDO and REDO commands
set history=1000
set undolevels=1000
set wildignore=*.swp,*.bak,*.pyc,*.class
set title
set visualbell
set noerrorbells

" Don't let VIM from writing a backup file
set nobackup
set noswapfile

" VIM Paste mode, use it to paste from system clipboard
set pastetoggle=<F2>

" Vim Color Scheme
let g:alduin_Shout_Become_Ethereal=1
colorscheme alduin

" Purescript specific configuration
if has('autocmd')
    autocmd filetype purescript set tabstop=2
    autocmd filetype purescript set shiftwidth=2
endif

" Airline plugin configuration
set laststatus=2

let g:airline#extensions#tabline#enabled=1
let g:airline_powerline_fonts=1
let g:airline_theme='dark'

" Python specific configuration
if has('autocmd')
    autocmd filetype python set tabstop=4
endif

" Clear the search with ,/
nmap <silent> ,/ :nohlsearch<CR>

" Easier split navigation
nnoremap <C-J> <C-W><C-J>
nnoremap <C-K> <C-W><C-K>
nnoremap <C-L> <C-W><C-L>
nnoremap <C-H> <C-W><C-H>

" Natural split opening
set splitbelow
set splitright

