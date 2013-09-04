"-------------------------------------------------------------------------------
" vim initial setup
"-------------------------------------------------------------------------------

" init vim-pathogen
execute pathogen#infect()

set nocompatible
filetype off

" whitespace stuff
set nowrap
set tabstop=4
set shiftwidth=4
set softtabstop=4
set expandtab
set number

" store swap/backup files in one folder
set backupdir=~/.vim/.backup,/tmp
set directory=~/.vim/.backup,/tmp

filetype plugin indent on     " required!

" replace default leader backslash with comma
let mapleader = ","

"-------------------------------------------------------------------------------
" color scheme & syntax highlighting 
"-------------------------------------------------------------------------------

set background=dark
colorscheme base16-default
syntax on

"-------------------------------------------------------------------------------
" customizations
"-------------------------------------------------------------------------------

" disable arrow keys in normal mode
noremap <up> <nop>
noremap <down> <nop>
noremap <left> <nop>
noremap <right> <nop>

" navigate splits with the arrow keys
nnoremap <right> <c-w>l
nnoremap <left> <c-w>h
nnoremap <up> <c-w>k
nnoremap <down> <c-w>j

" highlight trailing spaces
set list listchars=tab:\ \ ,trail:·

" split-it mapping
nmap <leader>-  :new<cr>
nmap <leader>\|  :vnew<cr>
nmap <leader>\  :rightbelow vnew<cr>
nmap <leader>_  :rightbelow new<cr>

" fix tmux arrow key mappings
if &term =~ '^screen'
    " tmux will send xterm-style keys when its xterm-keys option is on
    execute "set <xup>=\e[1;*a"
    execute "set <xdown>=\e[1;*b"
    execute "set <xright>=\e[1;*c"
    execute "set <xleft>=\e[1;*d"
endif

" resize split w/ shift+arrow
nmap <silent> <s-down> :resize -5<cr>
nmap <silent> <s-up> :resize +5<cr>
nmap <silent> <s-left> :vertical resize -5<cr>
nmap <silent> <s-right> :vertical resize +5<cr>

" allow backspace to delete end-of-line in insert mode
set backspace=indent,eol,start

"-------------------------------------------------------------------------------
" plugin configs
"-------------------------------------------------------------------------------

" ctrlp
""""""""
" open buffer list on
nnoremap <c-b> :ctrlpbuffer<cr>
" clear ctrlp cache then open ctrlp
nnoremap <silent> <c-l> :clearctrlpcache<cr>\|:ctrlp<cr>
" search .* files/folders
let g:ctrlp_show_hidden = 1
" custom file/folder ignores
let g:ctrlp_custom_ignore = {
  \ 'dir':  '\v[\/]\.(git|hg|svn)$',
  \ 'file': '\v\.(exe|so|dll|pyc)$',
  \ 'link': 'some_bad_symbolic_links',
  \ }
" add wildignores for python projects
set wildignore+=*/.ve/*,*/.venv/*
set wildignore+=*/*.egg-info/*,*/.tox/*


" easymotion
"""""""""""""
let g:easymotion_leader_key = '<leader>' 


" nerdtree
"""""""""""
map <leader>n :nerdtreetoggle<cr>
let nerdtreeshowhidden=1
let nerdtreeignore = ['\.pyc$']


" powerline
""""""""""""
let g:powerline_symbols = 'fancy'
set laststatus=2   " always show the statusline
set encoding=utf-8 " necessary to show unicode glyphs


" zoomwin
""""""""""
"map <leader>\ <c-w>o
map <leader><leader> <c-w>o


" tabularize
"""""""""""""
nmap <leader>a+ :tabularize /=<cr>
vmap <leader>a+ :tabularize /=<cr>
nmap <leader>a= :tabularize /^[^=]*\zs=/<cr>
vmap <leader>a= :tabularize /^[^=]*\zs=/<cr>
nmap <leader>a; :tabularize /:<cr>
vmap <leader>a; :tabularize /:<cr>
nmap <leader>a: :tabularize /:\s*\zs/l0r1<cr>
vmap <leader>a: :tabularize /:\s*\zs/l0r1<cr>
nmap <leader>ap :tabularize /import<cr>
vmap <leader>ap :tabularize /import<cr>


"-------------------------------------------------------------------------------
" custom filetype settings
"-------------------------------------------------------------------------------

" coffeescript, html, htmldjango, jade, less, stylus
au filetype coffee,html,htmldjango,jade,less,stylus,json
    \ set shiftwidth=2 softtabstop=2 tabstop=2 textwidth=239

"-------------------------------------------------------------------------------
" load os specific config files
"-------------------------------------------------------------------------------

if has('win32')
    source ~/.vim/.vimrc.win
elseif has('unix')
    source ~/.vim/.vimrc.linux
endif