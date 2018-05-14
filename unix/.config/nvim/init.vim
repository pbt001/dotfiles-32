" init.vim
" Neovim configuration
" Maintainer: Faris Chugthai

set runtimepath^=~/.vim runtimepath+=~/.vim/after
let &packpath = &runtimepath
call plug#begin('~/.local/share/nvim/plugged')

Plug 'junegunn/fzf', { 'dir': '~/.fzf', 'do': './install --all' }
Plug 'scrooloose/nerdTree'
Plug 'jistr/vim-nerdtree-tabs'
Plug 'davidhalter/jedi-vim'
Plug 'airblade/vim-gitgutter'
Plug 'tpope/vim-fugitive'
Plug 'majutsushi/tagbar'
Plug 'nvie/vim-flake8'
Plug 'w0rp/ale'
Plug 'scrooloose/nerdcommenter'
Plug 'godlygeek/tabular'
Plug 'joshdick/onedark.vim'
Plug 'morhetz/gruvbox'
Plug 'itchyny/lightline.vim'
if executable('node')
    Plug  'suan/vim-instant-markdown', {'do': 'npm -g install instant-markdown-d' }
endif


call plug#end()

filetype plugin indent on    " required

" currently using the local file for colorschemes and powerline.
if filereadable(glob("~/.config/nvim/init.vim.local"))
    source ~/.config/nvim/init.vim.local
endif

" Common abbreviations / misspellings 
if filereadable(glob("~/.vim/autocorrect.vim"))
    source ~/.vim/autocorrect.vim
endif

" Filetype Specific Options:

" IPython:
au BufRead,BufNewFile *.ipy setlocal filetype=python

" Web Dev:
au filetype javascript,html,css setlocal shiftwidth=2 softtabstop=2 tabstop=2

au BufWritePre,FileWritePre *.js ks|call LastMod()|'s

" Markdown:
autocmd BufNewFile,BufFilePre,BufRead *.md setlocal filetype=markdown

" Global Options:
" Leader:
let mapleader = "\<Space>"

" Viminfo:
if !has('nvim')
    set viminfo='100,<200,s200,n$HOME/.vim/viminfo
endif
set viminfo+=!                 " Viminfo include !
set complete-=i                " Exclude files completion

" Pep8 Global Options: 
set tabstop=4
set shiftwidth=4
set expandtab
set softtabstop=4
let python_highlight_all = 1

" Spell Checker:
set encoding=utf-8             " Set default encoding
set spelllang=en
set spelllang+=$VIMRUNTIME/spell/en.utf-8.spl
set spelllang+=$HOME/.config/nvim/spell/en.utf-8.spl
set spelllang+=$HOME/.config/nvim/spell/en.utf-8.add.spl
set complete+=kspell 
set spellsuggest=5
map <Leader>s :setlocal spell!<CR>

" Other Global Options: 
set history=10000              " Maximum history record
set autoindent                 " Indent at the same level of the previous line
set autoread                   " Automatically read a file changed outside of vim
set hlsearch                   " Highlight search terms
set incsearch                  " Find as you type search
set mouse=a                    " Automatically enable mouse usage
set ttyfast                    " Faster redrawing

set cul
set colorcolumn=+1
set ch=2
set ruler
set backspace=indent,eol,start " Backspace for dummies
set showcmd
set number
set showmatch
set ignorecase
set smartindent
set noswapfile

" Use the system clipboard. From vim-better-default
if has('unnamedplus')
  set clipboard+=unnamedplus,unnamed
else
  set clipboard+=unnamed
endif

set wildmenu                   " Show list instead of just completing
set wildmode=longest,list:longest
set complete+=.,b,u,t
set fileignorecase
set sessionoptions-=options
set noerrorbells
set whichwrap+=<,>,h,l,[,]

if has('persistent_undo')
    set undodir=~/.config/nvim/undodir
    set undofile	" keep an undo file (undo changes after closing)
endif
set nojoinspaces

" Syntax Highlighting:
"if we can have syntax recognition,this has to come after the colorscheme
if has("syntax")
    syntax on
endif
set modeline

" Buffers Windows Tabs:
try
  set switchbuf=useopen,usetab,newtab
  set stal=2
catch
endtry
set hidden
set splitbelow
set splitright
set tabpagemax=50
set smarttab                   " Smart tab
set laststatus=2               " Always show status line
set display=lastline           " Show as much as possible of the last line

" Mappings:
noremap <C-h> <C-w>h
noremap <C-j> <C-w>j
noremap <C-k> <C-w>k
noremap <C-l> <C-w>l
tnoremap <Esc> <C-W>N
map <Leader>a ggVG
map <Leader>n <plug>NERDTreeMirrorToggle<CR>


" Plugin Configuration:
" Builtin:
"
runtime! ftplugin/man.vim
let g:ft_man_folding_enable = 0
set keywordprg=:Man

" NERDTree:
autocmd Vimenter * NERDTree
autocmd VimEnter * wincmd w
autocmd StdinReadPre * let s:std_in=1
autocmd VimEnter * if argc() == 0 && !exists("s:std_in") | NERDTree | endif
autocmd StdinReadPre * let s:std_in=1
autocmd VimEnter * if argc() == 1 && isdirectory(argv()[0]) && !exists("s:std_in") | exe 'NERDTree' argv()[0] | wincmd p | ene | endif
autocmd bufenter * if (winnr("$") == 1 && exists("b:NERDTree") && b:NERDTree.isTabTree()) | q | endif
let NERDTReeQuitOnOpen = 1
let NERDTreeDirArrows = 1
let g:NERDTreeWinPos = "right"
let NERDTreeShowHidden = 1
let NERDTreeShowBookmarks = 1
let NERDTreeNaturalSort = 1
let NERDTreeChDirMode = 2
let NERDTreeShowLineNumbers=1


" NERDTree Tabs:
let g:nerdtree_tabs_no_startup_for_diff = 1
let g:nerdtree_tabs_smart_startup_focus = 1
let g:nerdtree_tabs_meaningful_tab_names = 1
let g:nerdtree_tabs_autoclose = 1
let g:nerdtree_tabs_open_on_console_startup = 1 
let g:nerdtree_tabs_startup_cd = 1

" Jedi:
" adds the 'import' statement and displays the autocomplete pop-up.
let g:jedi#smart_auto_mappings = 0
let g:jedi#popup_on_dot = 0

map <Leader>u *@:call jedi#usages()<CR>

" Fugitive:
if exists('g:loaded_fugitive')
   set statusline=%f\ %m\ (%L\ lines)\ %r\ %=%{fugitive#statusline()}\ (%l,%c)\ %y
else
   set statusline=%f\ %m\ (%L\ lines)\ %r\ %=(%l,%c)\ %y
endif

" Tagbar:
" https://github.com/majutsushi/tagbar
nmap <F8> :TagbarToggle<CR>

" Flake8:
" https://github.com/nvie/vim-flake8
let g:flake8_show_quickfix=0
let g:flake8_show_in_gutter=1

" Ale:
" https://github.com/w0rp/ale
" <Leader>a is already mapped so use l for lint
nmap <Leader>l <Plug>(ale_toggle_buffer)

" May not be necessary if matchit stops trying to load
" However this is an easy way to get nvim and vim more synced up
if isdirectory('/usr/share/vim/vim80')
    set packpath+=/usr/share/vim/vim80
endif


" Gruvbox:
"https://github.com/morhetz/gruvbox/wiki/Configuration#ggruvbox_contrast_dark
let g:gruvbox_contrast_dark = 'hard'

" Markdown
if executable('node')
  let g:instant_markdown_slow = 1
  let g:instant_markdown_autostart = 0
  map <leader>md :InstantMarkdownPreview<CR>
endif
