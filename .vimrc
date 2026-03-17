" Plugins with vim-plug
call plug#begin('~/.vim/plugged')
    Plug 'vim-airline/vim-airline'
    Plug 'vim-airline/vim-airline-themes'
    Plug 'tpope/vim-surround'
    Plug 'neoclide/coc.nvim', {'branch': 'release'}
    Plug 'SirVer/ultisnips'
    Plug 'tomtom/tlib_vim'
    Plug 'MarcWeber/vim-addon-mw-utils'
    Plug 'honza/vim-snippets'
    Plug 'scrooloose/nerdtree'
    Plug 'vim-pandoc/vim-pandoc'
    Plug 'vim-pandoc/vim-pandoc-syntax'
    Plug 'takac/vim-hardtime'
    Plug 'lilydjwg/colorizer'
    Plug 'morhetz/gruvbox'
    Plug 'Konfekt/FastFold' "makes folding faster
    Plug 'majutsushi/tagbar' "outline viewer
    Plug 'vim-syntastic/syntastic'
    Plug 'francoiscabrol/ranger.vim' "use ranger in vim with <leader>f
    Plug 'rbgrouleff/bclose.vim' "dependency for ranger.vim
    Plug 'tpope/vim-commentary' "comment stuff out
    Plug 'github/copilot.vim'
call plug#end()


syntax enable
filetype plugin indent on
set hidden              " allows us to edit multiple buffers
set title               " set teriminal title
set visualbell
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
set updatetime=300
set signcolumn=yes " always show sign column to avoid text shifting

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
set encoding=utf-8
set fileencoding=utf-8

" Copilot -------------------
" use CTRL-J instead of TAB to accept suggestions
let g:copilot_no_tab_map = v:true
imap <silent><script><expr> <C-J> copilot#Accept("\<CR>")
" use CTRL-SPACE to accept one word of the current suggestion
inoremap <C-Space> <Plug>(copilot-accept-word)
inoremap <C-@> <Plug>(copilot-accept-word)
imap <C-L> <Plug>(copilot-accept-line)
imap <leader>] <Plug>(copilot-next)
imap <leader>[ <Plug>(copilot-previous)

" Coc ----------------------
" Use tab for trigger completion with characters ahead and navigate
inoremap <silent><expr> <TAB>
      \ coc#pum#visible() ? coc#pum#next(1) :
      \ CheckBackspace() ? "\<Tab>" :
      \ coc#refresh()
inoremap <expr><S-TAB> coc#pum#visible() ? coc#pum#prev(1) : "\<C-h>"

function! CheckBackspace() abort
  let col = col('.') - 1
  return !col || getline('.')[col - 1]  =~# '\s'
endfunction

" Coding zeug: Ich hab derzeit keinen language server installiert, deswegen geht das hier nicht. Aber geniale sachen - siehe Wiki vom plugin
"" GoTo code navigation
"nmap <silent><nowait> gd <Plug>(coc-definition)
"nmap <silent><nowait> gy <Plug>(coc-type-definition)
"nmap <silent><nowait> gi <Plug>(coc-implementation)
"nmap <silent><nowait> gr <Plug>(coc-references)

" -----------------------------

" when opening directories with vim start ranger instead of Netrw or NerdTree
let g:NERDTreeHijackNetrw = 0
let g:ranger_replace_netrw = 1

let g:pandoc#spell#enabled = 0
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
set path=.,/home/me/Work/**,/home/me
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
"
" - scroll the viewport faster
nnoremap <C-e> 3<C-e>
nnoremap <C-y> 3<C-y>
" etc
" - remap ultisnip
"   only deactivated, because of conflict with copilot
let g:UltiSnipsExpandTrigger="<C-g>"
let g:UltiSnipsJumpForwardTrigger="<C-g>"
let g:UltiSnipsJumpBackwardTrigger="<C-b>"
" let :UltiSnipsEdit split the window
let g:UltiSnipsEditSplit="vertical"
let g:UltiSnipsEnableSnipMate=0
"
" FastFold
let g:markdown_folding = 1
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
set background=dark
let g:gruvbox_italic=1
colorscheme gruvbox
let g:airline_solarized_dark_text = 1
let g:airline_theme='gruvbox'
let g:airline#extensions#tabline#enabled = 1
let g:airline#extensions#tabline#fnamemod = 1
let g:airline_powerline_fonts = 1
if !exists('g:airline_symbols')
    let g:airline_symbols = {}
endif
let g:airline_symbols.linenr = ''
let g:airline_symbols.maxlinenr = ''
