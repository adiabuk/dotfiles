
set nocompatible

set softtabstop=2
set tabstop=2
set shiftwidth=2
set expandtab

"
" general
"

set nocompatible

set tags=tags;/

" searching
set incsearch                 " incrimental search
set hlsearch                  " highlighting when searching

" this should get best indenting for most common filetypes
filetype indent plugin on
" note: cindent and smartindent do the wrong thing with e.g. indented lines
" starting with # in certain files.
" so i think autoindent is more minimal and good default for all filetypes.
" again, most files will be covered by the previous line.
set autoindent

set backspace=2
set paste
let g:paste_mode = 1
" display
set nolist                    " show/hide tabs and EOL chars
set number                  " show/hide line numbers (nu/nonu)
set paste
set scrolloff=5               " scroll offsett, min lines above/below cursor
set scrolljump=5              " jump 5 lines when running out of the screen
set sidescroll=10             " minumum columns to scroll horizontally
set showcmd                   " show command status
set showmatch                 " flashes matching paren when one is typed
set showmode                  " show editing mode in status (-- INSERT --)
set ruler                     " show cursor position

" other
set noerrorbells              " no bells in terminal
set undolevels=1000           " number of undos stored
set viminfo='50,"50           " '=marks for x files, "=registers for x files

"
" things you may be interested in for your .vimrc
"

" highlight literal tabs
" (but don't highlight trailing whitespace; it's annoying as you type)
" actually even tabs are annoying since they are in e.g. git commit msgs
" could make it just for php but i'm not sure it's even needed
"match Error '\t'

" make split windows easier to navigate
"map <C-j> <C-w>j
"map <C-k> <C-w>k
"map <C-h> <C-w>h
"map <C-l> <C-w>l
"map <C-m> <C-w>_

" bind "gb" to "git blame" for visual and normal mode.
:vmap gb :<C-U>!git blame % -L<C-R>=line("'<") <CR>,<C-R>=line("'>") <CR><CR>
:nmap gb :!git blame %<CR>

set foldenable
set foldmethod=indent

function Pastebin() range
    echo system('echo '.shellescape(join(getline(a:firstline, a:lastline), "\r")).'| pastebin')
endfunction

function Email() range
  echo system('echo '.shellescape(join(getline(a:firstline, a:lastline), "\r")).'| strings|mail -s "VIM output" adiab@hotmail.co.uk')
endfunction

function Detatch() range
  echo system('screen -d')
endfunction

let mapleader=","
silent !stty -ixon > /dev/null 2>/dev/null
nnoremap <C-Q> :call Detatch()<cr>
nmap <C-N> :tabnew<cr>
nmap <C-B> :ConqueTermTab bash<cr>
nmap <C-T> :NERDTree<cr>
nmap <C-Right> :tabnext<cr>
nmap <C-Left> :tabprevious<cr>
vmap <C-P> :call Pastebin()<cr>
"vmap <C-C> :call Clipboard()<cr>
vnoremap <C-C> "+y
vmap <C-E> :call Email()<cr>
set mouse=a
set background=light
nmap <silent> <A-Up> :wincmd k<CR>
nmap <silent> <A-Down> :wincmd j<CR>
nmap <silent> <A-Left> :wincmd h<CR>
nmap <silent> <A-Right> :wincmd l<CR>
vmap <Leader>s :sort<cr>

vnoremap < <gv
vnoremap > >gv

highlight UnwanttedTab ctermbg=red guibg=darkred
highlight TrailSpace guibg=red ctermbg=darkred
match UnwanttedTab /\t/
match TrailSpace / \+$/

set colorcolumn=80
highlight ColorColumn ctermbg=blue
set tw=79
call pathogen#infect()

if match($TERM, "screen")!=-1
  set term=xterm
endif

" let g:PyLintCWindow = 1
"let g:PyLintSigns = 1
" let g:PyLintSigns = 1
nmap <C-P> :PyLint<CR>
colorscheme darkblue
set conceallevel=0

