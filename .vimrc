" Plugins with vim-plug
call plug#begin('~/.vim/plugged')
    Plug 'vim-airline/vim-airline'
    Plug 'vim-airline/vim-airline-themes'
    Plug 'tpope/vim-surround'
    Plug 'valloric/youcompleteme'
    Plug 'terryma/vim-multiple-cursors'
    "Plug 'garbas/vim-snipmate'
    Plug 'SirVer/ultisnips'
    Plug 'tomtom/tlib_vim'
    Plug 'MarcWeber/vim-addon-mw-utils'
    Plug 'honza/vim-snippets'
    Plug 'scrooloose/nerdtree'
    Plug 'vim-pandoc/vim-pandoc'
    Plug 'vim-pandoc/vim-pandoc-syntax'
    Plug 'takac/vim-hardtime'
    Plug 'lilydjwg/colorizer'
    Plug 'neovimhaskell/haskell-vim'
    Plug 'morhetz/gruvbox'
    Plug 'lervag/vimtex' "text objects, motions, word count, better syntax highlighting, indentation?
    Plug 'Konfekt/FastFold' "makes folding faster
    Plug 'majutsushi/tagbar' "outline viewer
    Plug 'vim-syntastic/syntastic' 
    Plug 'francoiscabrol/ranger.vim' "use ranger in vim with <leader>f
    Plug 'rbgrouleff/bclose.vim' "dependency for ranger.vim
    Plug 'tpope/vim-commentary' "comment stuff out
call plug#end()


" enable IndentGuides
"let g:indent_guides_enable_on_vim_startup=1

syntax enable
filetype plugin indent on
au FocusLost * :wa      " autosave on losing focus (does this work)
set hidden              " allows us to edit multiple buffers
set title               " set teriminal title
set visualbell
"set showmatch           " show matching bracket for short time
set ttyfast             " faster redrawing
set undofile
set cursorline          " highlight current line
set tabstop=4
set softtabstop=4
set shiftwidth=4
set smartindent
set autoindent
set expandtab           " spaces instead of real tabs
set scrolloff=4
set wrap                " display long lines as multiple lines
set linebreak           " soft wrapping - break line at breakpoint
set breakindent         " display wrapped lines with indent
set foldenable			" enable folding
set foldlevelstart=99	" open folds when opening a buffer
set foldnestmax=10
set foldmethod=indent
set clipboard=unnamedplus   " yank and paste register references the clipboard
set noesckeys " No delay when hitting Esc, but no function keys that start with Esc in insert mode

" jump to last cursor position at open
autocmd BufReadPost *
  \ if line("'\"") >= 1 && line("'\"") <= line("$") && &ft !~# 'commit'
  \ |   exe "normal! g`\""
  \ | endif

" auto-save and load folds
set viewoptions-=options
set sessionoptions-=options
augroup autosave_buffer
 autocmd!
 autocmd BufWinLeave *.* mkview
 autocmd BufWinEnter *.* silent loadview
augroup END

" set cursor shape
autocmd VimEnter * silent exec "! echo -ne '\e[1 q'"
let &t_SI = "\<Esc>[5 q"
let &t_SR = "\<Esc>[4 q"
let &t_EI = "\<Esc>[1 q"

" Line Numbers -------------------
set number relativenumber  " set hybrid line numbers
"augroup numbertoggle       " toggel to absolute line numbers in circumstances
"  autocmd!
"  autocmd BufEnter,FocusGained,InsertLeave * set relativenumber
"  autocmd BufLeave,FocusLost,InsertEnter   * set norelativenumber
"augroup END

"let g:hardtime_default_on = 1 " Stop repeating jjjjjj
set encoding=utf-8
set fileencoding=utf-8

let g:ycm_filetype_blacklist = {} " YouCompleteMe in allen Dateien nutzen

" when opening directories with vim start ranger instead of Netrw or NerdTree
let g:NERDTreeHijackNetrw = 0
let g:ranger_replace_netrw = 1

" LaTeX ----------------------------------
" - alle tex files als latex files erkennen, egal ob preamble existiert oder nicht
let g:tex_flavor = "latex"
" - indentation for tex files
autocmd BufRead,BufNewFile *.sty setl filetype=tex
autocmd FileType tex setl sw=2
autocmd FileType tex setl tabstop=2
autocmd FileType tex setl softtabstop=2
autocmd FileType tex setl softtabstop=2
"autocmd FileType tex let g:ycm_auto_trigger=0
" Spellcheck
autocmd FileType tex,markdown,rst,mail setl spell spelllang=de
autocmd FileType tex,markdown,rst,mail setl linebreak
" folding
au FileType tex,markdown setl foldmethod=syntax
au FileType tex,markdown setl foldcolumn=5
" ignore LaTeX temporary files
set wildignore+=*.aux,*.bbl,*.bcf,*.blg,*.fls,*.idx,*.ilg,*.ind,*.log,*.out,*.run.xml,*synctex.gz,*.fdb_latexmk,*.nav,*.snm,*.toc,*.vrb,*.cut,*.lo,*.brf
"
" custom mappings -------------------------
"
"let mapleader="-"
"
" buffers
nnoremap gB :ls<CR>:b<Space>
nnoremap gb :b#<CR>
nnoremap <leader>b :buffer *
" use :bufdo to do identical edits on every listed buffer
"   z.B. :bufdo %s/foo/bar/g
" use :bw to close a buffer
"
" files
set wildmenu
set wildignorecase
set path=.,/home/me/FH/mitschrift/**,/home/me/Work/**,/home/me
set wildignore+=*.pdf
nnoremap <leader>f :find *
"
" windows
" - natural splitting
set splitbelow
set splitright
" - navigation
nnoremap <C-J> <C-W><C-J>
nnoremap <C-K> <C-W><C-K>
nnoremap <C-L> <C-W><C-L>
nnoremap <C-H> <C-W><C-H>
"
" session management
let g:sessions_dir = '~/.vim/sessions'
exec 'nnoremap <Leader>ss :mks! ' . g:sessions_dir . '/'
exec 'nnoremap <Leader>sr :so ' . g:sessions_dir . '/'
"
" searching
set hlsearch        	" highlight matches
set incsearch       	" search as characters are entered
set ignorecase
set smartcase           " case sensitive only if uppercase letter is in search string
" very magic searching (regex)
nnoremap / /\v
vnoremap / /\v
" - clear search highlights with Return
nnoremap <Enter> :noh<CR>
"
" - map spellchecking to F6
let g:myLang = 0
let g:myLangList = ['nospell', 'de', 'en_us']
let g:spellfile_URL = 'http://ftp.vim.org/vim/runtime/spell'
function! MySpellLang()
  "loop through languages
  if g:myLang == 0 | setlocal nospell | endif
  if g:myLang == 1 | let &l:spelllang = g:myLangList[g:myLang] | setlocal spell | endif
  if g:myLang == 2 | let &l:spelllang = g:myLangList[g:myLang] | setlocal spell | endif
  echomsg 'language:' g:myLangList[g:myLang]
  let g:myLang = g:myLang + 1
  if g:myLang >= len(g:myLangList) | let g:myLang = 0 | endif
endfunction
map <F6> :<C-U>call MySpellLang()<CR>
"map <F6> :setlocal spell! spelllang=en_us<CR>
"
" - scroll the viewport faster
nnoremap <C-e> 3<C-e>
nnoremap <C-y> 3<C-y>
" etc
" - remap ultisnip
let g:UltiSnipsExpandTrigger="<C-Space>"
let g:UltiSnipsJumpForwardTrigger="<C-Space>"
let g:UltiSnipsJumpBackwardTrigger="<C-b>"
" let :UltiSnipsEdit split the window
let g:UltiSnipsEditSplit="vertical"
let g:UltiSnipsEnableSnipMate=0
let g:tex_indent_items=0
"
" FastFold
let g:markdown_folding = 1
let g:tex_fold_enabled = 1
let g:vimsyn_folding = 'af'
"
" tagbar
nmap <F8> :TagbarToggle<CR>
"
" syntastic
set statusline+=%#warningmsg#
set statusline+=%{SyntasticStatuslineFlag()}
set statusline+=%*
let g:syntastic_always_populate_loc_list = 1
let g:syntastic_auto_loc_list = 1
let g:syntastic_check_on_open = 1
let g:syntastic_check_on_wq = 0
"
" Build Markdown
nnoremap <Leader>p :!pandoc -t latex -V papersize:a4 -o output.pdf % --include-in-header ~/.vim/mdheader.tex<CR>
map <leader>c :w! \| !compiler <c-r>%<CR>
" Compile Haskell
nnoremap <Leader>h :!ghc -dynamic %<CR>

so ~/.config/vim/colorgruvbox
so ~/.config/vim/autocmds
