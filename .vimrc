" noch zu lösen
" - verhalten von zeilenwechsel in markdown und anderen textfiles vereinheitlichen
" - kein spellcheck standardmäßig
" Plugins with vim-plug
call plug#begin('~/.vim/plugged')
    Plug 'valloric/youcompleteme'
    Plug 'vim-airline/vim-airline'
    Plug 'vim-airline/vim-airline-themes'
    Plug 'tpope/vim-surround'
    Plug 'terryma/vim-multiple-cursors'
    Plug 'SirVer/ultisnips'
    Plug 'tomtom/tlib_vim'
    Plug 'MarcWeber/vim-addon-mw-utils'
    Plug 'honza/vim-snippets'
    Plug 'scrooloose/nerdtree'
    Plug 'vim-pandoc/vim-pandoc'
    Plug 'vim-pandoc/vim-pandoc-syntax'
    "Plug 'neovimhaskell/haskell-vim'
    Plug 'morhetz/gruvbox'
    Plug 'lervag/vimtex' "text objects, motions, word count, better syntax highlighting, indentation?
    Plug 'majutsushi/tagbar' "outline viewer
    Plug 'vim-syntastic/syntastic' 
    Plug 'francoiscabrol/ranger.vim' "use ranger in vim with <leader>f (mapped to <leader>r)
    Plug 'rbgrouleff/bclose.vim' "dependency for ranger.vim
    Plug 'tpope/vim-commentary' "comment stuff out
    Plug 'hashivim/vim-terraform'
    Plug 'mattn/emmet-vim' " htmls (z.b. .classname#idname<C-y>,
    "Plug 'Yggdroot/indentLine' meh
    "Plug 'valloric/MatchTagAlways' " match enclosing xml/html tags (geht
    "nicht, weil braucht python2 support
    "Plug 'nvie/vim-flake8' " Python syntax and style checker
    "Plug 'tweekmonster/django-plus.vim' " Sets Django file type etc.
    "Plug 'fatih/vim-go'
call plug#end()

set encoding=utf-8
set fileencoding=utf-8
syntax enable
filetype plugin indent on
au FocusLost * :wa      " autosave on losing focus (does this work)
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
set scrolloff=7
set wrap                " display long lines as multiple lines
set linebreak           " soft wrapping - break line at breakpoint
set breakindent         " display wrapped lines with indent
set foldenable			" enable folding
set foldlevelstart=99	" open folds when opening a buffer
set foldnestmax=10
set foldmethod=indent
set clipboard=unnamedplus   " yank and paste register references the clipboard
set noesckeys           " No delay when hitting Esc, but no function keys that start with Esc in insert mode
"set autoread            " funktioniert nicht richtig (einfach :e verwenden) -> automatically read a file that has been changed outside but not inside of vim
set shortmess-=S        " show search count message, e.g. [1/5]

" jump to last cursor position at open
autocmd BufReadPost *
  \ if line("'\"") >= 1 && line("'\"") <= line("$") && &ft !~# 'commit'
  \ |   exe "normal! g`\""
  \ | endif

" auto-save and load folds
"set viewoptions-=options
"set sessionoptions-=options
"augroup autosave_buffer
" autocmd!
" autocmd BufWinLeave * mkview
" autocmd BufWinEnter * silent loadview
"augroup END

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


" YouCompleteMe ----------------------
let g:ycm_filetype_blacklist = {} " YouCompleteMe in allen Dateien nutzen
let g:ycm_autoclose_preview_window_after_completion=1 " Preview-Fenster nach der vervollständigung wieder schließen
map <leader>gd  :YcmCompleter GoToDefinitionElseDeclaration<CR>

" when opening directories with vim start ranger instead of Netrw or NerdTree
let g:NERDTreeHijackNetrw = 0
let g:ranger_replace_netrw = 1
nnoremap <leader>r :Ranger<Cr>

" html ------------------------
"
autocmd FileType html setl sw=2
autocmd FileType html setl tabstop=2
autocmd FileType html setl softtabstop=2

" Pandoc -----------------------------------
" folding slows down vim
let g:pandoc#modules#disabled = ["folding"]

let g:pandoc#filetypes#handled = ["pandoc", "markdown"]
let g:pandoc#filetypes#pandoc_markdown = 0


" LaTeX ----------------------------------
" - alle tex files als latex files erkennen, egal ob preamble existiert oder nicht
let g:tex_flavor = "latex"
" - indentation for tex files
autocmd BufRead,BufNewFile *.sty setl filetype=tex
autocmd FileType tex setl sw=2
autocmd FileType tex setl tabstop=2
autocmd FileType tex setl softtabstop=2
" Spellcheck
"autocmd FileType tex,rst,mail setl spell spelllang=de
"autocmd FileType tex,markdown,rst,mail setl linebreak
" ignore LaTeX temporary files
set wildignore+=*.aux,*.bbl,*.bcf,*.blg,*.fls,*.idx,*.ilg,*.ind,*.log,*.out,*.run.xml,*synctex.gz,*.fdb_latexmk,*.nav,*.snm,*.toc,*.vrb,*.cut,*.lo,*.brf
"open pdf in zathura
let g:vimtex_view_general_viewer = 'zathura'
let g:vimtex_compiler_engine = 'lualatex'
if !exists('g:ycm_semantic_triggers')
    let g:ycm_semantic_triggers = {}
endif
au VimEnter * let g:ycm_semantic_triggers.tex=g:vimtex#re#youcompleteme


" Python ------------------------------
" Make code look pretty
let python_highlight_all=1
let g:ycm_collect_identifiers_from_tags_files = 1 " Let YCM read tags from Ctags file
let g:ycm_use_ultisnips_completer = 1 " Default 1, just ensure
let g:ycm_seed_identifiers_with_syntax = 1 " Completion for programming language's keyword
let g:ycm_complete_in_comments = 1 " Completion in comments
let g:ycm_complete_in_strings = 1 " Completion in string

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
" use :bw or :bd to close a buffer
"
" files
set wildmenu
set wildignorecase
set wildignore+=*.pdf
"
" windows
" - natural splitting
set splitbelow
set splitright
" - navigation (kollidiert anscheinend nicht mit UltiSnips - sonst löschen)
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
set smartcase
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
let g:UltiSnipsExpandTrigger="<C-g>"
let g:UltiSnipsJumpForwardTrigger="<C-j>"
let g:UltiSnipsJumpBackwardTrigger="<C-k>"
" let :UltiSnipsEdit split the window
let g:UltiSnipsEditSplit="vertical"
let g:UltiSnipsEnableSnipMate=0
let g:tex_indent_items=0
"
" tagbar
nmap <F8> :TagbarToggle<CR>
let g:tagbar_type_pandoc = {
    \ 'ctagstype': 'pandoc',
    \ 'ctagsbin' : '/bin/markdown2ctags',
    \ 'ctagsargs' : '-f - --sort=yes',
    \ 'kinds' : [
        \ 's:sections',
        \ 'i:images'
    \ ],
    \ 'sro' : '|',
    \ 'kind2scope' : {
        \ 's' : 'section',
    \ },
    \ 'sort': 0,
\ }
"
" syntastic
set statusline+=%#warningmsg#
set statusline+=%{SyntasticStatuslineFlag()}
set statusline+=%*
let g:syntastic_always_populate_loc_list = 1
"let g:syntastic_auto_loc_list = 1
let g:syntastic_check_on_open = 1
let g:syntastic_check_on_wq = 0
let g:syntastic_tex_checkers = ['lacheck'] "no warnings for wrong length of dash
"
" Build Markdown
nnoremap <Leader>p :!pandoc -t latex -V papersize:a4 -o %:r.pdf %<CR>
"
" Edit file under cursor
nnoremap <Leader>gf "zyiw:exe "e ".@z.".".expand('%:e')<CR>

" noch zu überarbeiten (vorgehen war: Visual line; Esc; /\v%V<pattern>; :CopyMatches; p)
function! CopyMatches(reg)
  let hits = []
  %s//\=len(add(hits, submatch(0))) ? submatch(0) : ''/gne
  let reg = empty(a:reg) ? '+' : a:reg
  execute 'let @'.reg.' = join(hits, "\n") . "\n"'
endfunction
command! -register CopyMatches call CopyMatches(<q-reg>)

" search next ", ', [, ], {, }, (, ), <, > and replace inside pair
nnoremap c" /"<cr>:noh<CR>ci"
nnoremap c' /'<cr>:noh<CR>ci'
nnoremap c[ /[<cr>:noh<CR>ci[
nnoremap c] /]<cr>:noh<CR>ci]
nnoremap c{ /{<cr>:noh<CR>ci{
nnoremap c} /}<cr>:noh<CR>ci}
nnoremap c( /(<cr>:noh<CR>ci(
nnoremap c) /)<cr>:noh<CR>ci)
nnoremap c< /<<cr>:noh<CR>ci<
nnoremap c> /><cr>:noh<CR>ci>

so ~/.config/vim/colorgruvbox
