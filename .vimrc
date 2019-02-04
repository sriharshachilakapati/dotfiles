" Inject and use Pathogen for loading plugins
execute pathogen#infect()

" Basic editor configuration
syntax on
filetype on
filetype plugin indent on
filetype plugin on

set mouse=a

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
set relativenumber
set autoread
set cursorline

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
set termguicolors
let ayucolor="dark"
colorscheme ayu

" Keep selection after changing indentation
vnoremap > >gv
vnoremap < <gv

" Use Ctrl-P to open FZF
nnoremap <C-P> :Files<CR>

" Use x to delete buffers
nnoremap x :BD<CR>

" Default Language Server configuration
let g:LanguageClient_autoStart=1
let g:LanguageClient_autoStop=1
let g:LanguageClient_serverCommands={}
let g:LanguageClient_windowLogMessageLevel="Log"
let g:LanguageClient_loggingLevel="INFO"
let g:LanguageClient_useVirtualText=0

let g:airline#extensions#ale#enabled=1
let g:airline#extensions#languageclient#enabled=1
let g:ale_set_quickfix=1

" Purescript specific configuration
if has('autocmd')
    autocmd filetype purescript set tabstop=2
    autocmd filetype purescript set shiftwidth=2

    " Configure LanguageClient to use purescript-language-server if it is installed and available in path.
    if executable("purescript-language-server")
        " See https://github.com/nwolverson/vscode-ide-purescript/blob/master/package.json#L80-L246 for list of properties to use
        let config =
            \ { 'purescript.autoStartPscIde': v:true
            \ , 'purescript.pscIdePort': v:null
            \ , 'purescript.autocompleteAddImport': v:true
            \ , 'purescript.pursExe': 'purs'
            \ , 'purescript.trace.server': 'verbose'
            \ }

        " Define the LanguageServer in the LanguageClient
        let g:LanguageClient_serverCommands.purescript = ['purescript-language-server', '--stdio', '--config', json_encode(config)]
        autocmd filetype purescript setlocal omnifunc=LanguageClient#complete

        " Commands for ease of use
        autocmd filetype purescript nm <buffer> <silent> <leader>a :call LanguageClient_textDocument_codeAction()<CR>
        autocmd filetype purescript nm <buffer> <silent> <leader>i :call LanguageClient_workspace_executeCommand(
            \ 'purescript.addCompletionImport', [ expand('<cword>'), v:null, v:null, 'file://' . expand('%:p') ])<CR>
        autocmd filetype purescript nm <buffer> <silent> <leader>g :call LanguageClient_textDocument_definition()<CR>
        autocmd filetype purescript nm <buffer> <silent> <leader>h :call LanguageClient_textDocument_hover()<CR>
        autocmd filetype purescript nm <buffer> <silent> <leader>l :call LanguageClient_workspace_executeCommand('purescript.build', [])<CR>

        " Functions for the rest of commands
        function! Pstart()
            call LanguageClient_workspace_executeCommand('purescript.startPscIde', [])
        endfunction

        function! Pend()
            call LanguageClient_workspace_executeCommand('purescript.stopPscIde', [])
        endfunction

        function! Prestart()
            call LanguageClient_workspace_executeCommand('purescript.restartPscIde', [])
        endfunction
    endif

    autocmd filetype purescript let &l:commentstring='--%s'
    autocmd filetype purescript let g:NERDCommentEmptyLines=1
    autocmd filetype purescript let g:NERDDefaultAlign='left'
    autocmd filetype purescript let g:NERDSpaceDelims=1
endif

" JavaScript specific configuration
if has('autocmd')
    autocmd filetype javascript set tabstop=2
    autocmd filetype javascript set shiftwidth=2

    autocmd filetype javascript nm <buffer> <silent> <leader>a :ALEFix<CR>
    autocmd filetype javascript nm <buffer> <silent> <leader>g :ALEGoToDefinition<CR>

    autocmd filetype javascript let &l:commentstring='//%s'
endif

" Vim Pencil configuration
let g:pencil#wrapModeDefault='soft'

" Markdown specific configuration
if has('autocmd')
    let g:polyglot_disabled = ['markdown']
    let g:vim_markdown_conceal = 0
    let g:vim_markdown_folding_disabled = 1
    let g:tex_conceal = ""
    let g:vim_markdown_math = 1
    let g:vim_markdown_frontmatter=1
    let g:vim_markdown_fenced_languages=["c","c++=cpp","cpp","java","javascript","js=javascript","purescript","purs=purescript","python","csharp","cs=csharp","html","php"]

    autocmd BufNewFile,BufReadPost *.md set filetype=markdown
    autocmd filetype markdown,mkd call pencil#init()
end

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

" Easier buffer navigation
nnoremap <S-J> :bp<CR>
nnoremap <S-K> :bn<CR>

" Use Ctrl-B to toggle Git Blame
nnoremap <C-B> :Gblame<CR>

" Natural split opening
set splitbelow
set splitright

" Reload the configuration with ,r
nmap <silent> ,r :source $MYVIMRC<CR> <bar> :echom "Reloaded VIMRC file"<CR>

" Syntastic configuration
let g:syntastic_always_populate_loc_list=1
let g:syntastic_check_on_open=0
let g:syntastic_check_on_wq=0

" Indent Line configuration
let g:indentLine_showFirstIndentLevel=1
let g:indentLine_setColors=0
let g:indentLine_concealcursor=0

" GitGutter configuration
set signcolumn=yes
set updatetime=100

" NERDTree configuration
map <C-n> :NERDTreeToggle<CR>

" Deoplete configuration
let g:deoplete#enable_at_startup=1

" vim-json configuration
let g:vim_json_syntax_conceal=0
