
set nocompatible
filetype off

"""""""" Vundle
" set the runtime path to include Vundle and initialize
set rtp+=~/.vim/bundle/Vundle.vim
call vundle#begin()
" alternatively, pass a path where Vundle should install plugins
"call vundle#begin('~/some/path/here')

" let Vundle manage Vundle, required
Plugin 'VundleVim/Vundle.vim'
Plugin 'scrooloose/syntastic'
" All of your Plugins must be added before the following line
call vundle#end()            " required
""""""""""""""""""""""""""""""""

""""""" Syntastic
set statusline+=%#warningmsg#
set statusline+=%{SyntasticStatuslineFlag()}
set statusline+=%*

let g:syntastic_always_populate_loc_list = 1
let g:syntastic_auto_loc_list = 1
let g:syntastic_check_on_open = 1
let g:syntastic_check_on_wq = 0

set softtabstop=2
set tabstop=2
set shiftwidth=2
set expandtab

"
" general
"
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
let g:paste_mode = 1
" display
set nolist                    " show/hide tabs and EOL chars
set number                    " show/hide line numbers (nu/nonu)
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


" git blame in normal/visual mode
:vmap gb :<C-U>!git blame % -L<C-R>=line("'<") <CR>,<C-R>=line("'>") <CR><CR>
:nmap gb :!git blame %<CR>

set foldenable
set foldmethod=indent


function Pastebin() range
	" pipe selection to pastebin
	echo system('echo '.shellescape(join(getline(a:firstline, a:lastline), "\r")).'| pastebin')
endfunction

function Email() range
	" email selection
  echo system('echo '.shellescape(join(getline(a:firstline, a:lastline), "\r")).'| strings|mail -s "VIM output" adiab@hotmail.co.uk')
endfunction

function Detatch() range
  echo system('screen -d')
endfunction

let mapleader=","
silent !stty -ixon > /dev/null 2>/dev/null
nnoremap <C-Q> :call Detatch()<cr>
nmap <C-N> :tabnew<cr>
nmap <C-B> :ConqueTermTab bash<cr> " start bash term in new tab
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

" Show red column at 80-char limit
set colorcolumn=80
highlight ColorColumn ctermbg=blue
set tw=79

if match($TERM, "screen")!=-1
  set term=xterm
endif

colorscheme darkblue
set conceallevel=0
syntax on

" Show trailing white space in red
highlight ExtraWhitespace ctermbg=red guibg=red
match ExtraWhitespace /\s\+$/

" powerline: https://github.com/powerline/powerline
set rtp+=~/repos/powerline/powerline/bindings/vim
set laststatus=2
