"vim: fdm=marker

" {{{ Vundle
" set the runtime path to include Vundle and initialize
set rtp+=~/.vim/bundle/Vundle.vim
call vundle#begin()
" alternatively, pass a path where Vundle should install plugins
"call vundle#begin('~/some/path/here')

" let Vundle manage Vundle, required
Plugin 'VundleVim/Vundle.vim'
Plugin 'davidhalter/jedi-vim'
" All of your Plugins must be added before the following line
call vundle#end()            " required
" }}}

" {{{ Tab complete
function Smart_TabComplete()
  let line = getline('.')                         " current line

  let substr = strpart(line, -1, col('.')+1)      " from the start of the current
                                                  " line to one character right
                                                  " of the cursor
  let substr = matchstr(substr, "[^ \t]*$")       " word till cursor
  if (strlen(substr)==0)                          " nothing to match on empty string
    "return "\<tab>"
    return "\<C-X>\<C-P>"
  endif
  let has_period = match(substr, '\.') != -1      " position of period, if any
  let has_slash = match(substr, '\/') != -1       " position of slash, if any
  if (!has_period && !has_slash)
    return "\<C-X>\<C-P>"                         " existing text matching
  elseif ( has_slash )
    return "\<C-X>\<C-F>"                         " file matching
  else
    return "\<C-X>\<C-O>"                         " plugin matching
  endif
endfunction
" }}}

" {{{Syntastic
set statusline+=%#warningmsg#
set statusline+=%{SyntasticStatuslineFlag()}
set statusline+=%*

let g:syntastic_always_populate_loc_list = 1
let g:syntastic_auto_loc_list = 1
let g:syntastic_check_on_open = 1
let g:syntastic_check_on_wq = 0
let g:syntastic_python_checkers = ['pylint']
let g:syntastic_sh_checkers = ['shellcheck']
let g:syntastic_sh_shellcheck_args = ['-x']
let g:syntastic_perl_checkers = ['perl']
let g:syntastic_cgi_checkers = ['perl']
let g:syntastic_javascript_checkers = ['jslint']

let g:syntastic_enable_cgi_checker = 1
let g:syntastic_enable_perl_checker = 1
" }}}

" {{{ More vundle
set nocompatible
filetype off

set rtp+=~/.vim/bundle/vundle/
call vundle#rc()

Plugin 'scrooloose/nerdtree'
Plugin 'kchmck/vim-coffee-script'
Plugin 'scrooloose/syntastic'
Plugin 'Lokaltog/vim-powerline'
syntax enable
filetype plugin indent on
" }}}

" {{{general

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
" }}}

" {{{ Auto Paste mode
let &t_SI .= "\<Esc>[?2004h"
let &t_EI .= "\<Esc>[?2004l"

inoremap <special> <expr> <Esc>[200~ XTermPasteBegin()

function! XTermPasteBegin()
   set pastetoggle=<Esc>[201~
   set paste
return ""
endfunction
" }}}

" {{{ Modes
set backspace=2
set nolist                    " show/hide tabs and EOL chars
set number                    " show/hide line numbers (nu/nonu)
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
" }}} 

" {{{ git blame in normal/visual mode
:vmap gb :<C-U>!git blame % -L<C-R>=line("'<") <CR>,<C-R>=line("'>") <CR><CR>
:nmap gb :!git blame %<CR>
" }}}

" {{{ Functions
function Pastebin() range
	" pipe selection to pastebin
	echo system('echo '.shellescape(join(getline(a:firstline, a:lastline), "\r")).'| pastebin')
endfunction

function Email() range
"""""""" email selection
  echo system('echo '.shellescape(join(getline(a:firstline, a:lastline), "\r")).'| strings|mail -s "VIM output" adiab@hotmail.co.uk')
endfunction

function Detatch() range
  echo system('screen -d')
endfunction

function! Setup_ExecNDisplay()
  " prompt for arguments and execute current script with them
  " view output in new tab
  execute "w"
  execute "silent !chmod +x %:p"
  let name=expand('%:t')
  let arguments = input('Enter arguments:')
  execute "silent !%:p " . arguments . " 2>&1 | tee /tmp/output_" . name
  "execute "split /tmp/output_" . name
  execute "tabnew /tmp/output_" . name
  execute "redraw!"
  set autoread
endfunction

" }}}

" {{{ Key mappings
let mapleader=","
silent !stty -ixon > /dev/null 2>/dev/null
nnoremap <C-Q> :call Detatch()<cr>
nmap <C-E> :call Setup_ExecNDisplay()<CR>
nmap <C-n> :tabnew<cr>
nmap <C-B> :ConqueTermTab bash<cr>
nmap <C-T> :NERDTreeToggle<cr>
inoremap <tab> <c-r>=Smart_TabComplete()<cr>
nmap <C-Right> :tabnext<cr>
nmap <C-Left> :tabprevious<cr>
vmap <C-P> :call Pastebin()<cr>
vnoremap <C-C> "+y
vmap <C-E> :call Email()<cr>
set mouse=a
set background=light
nmap <silent> <A-Up> :wincmd k<CR>
nmap <silent> <A-Down> :wincmd j<CR>
nmap <silent> <A-Left> :wincmd h<CR>
nmap <silent> <A-Right> :wincmd l<CR>
vmap <Leader>s :sort<cr>
nmap <C-S> :SyntasticToggleMode<CR>
vnoremap < <gv
vnoremap > >gv
" }}}

" {{{ other
" Show red column at 80-char limit
let g:jedi#popup_on_dot = 1
set colorcolumn=80
highlight ColorColumn ctermbg=blue
set tw=80
autocmd BufRead,BufNewFile *.md setlocal spell

set foldenable
set foldmethod=indent

" use fdm=marker when no filetype
filetype plugin on
au BufNewFile,BufRead * if &ft == '' | set fdm=marker | endif

set nocompatible
filetype off
set t_Co=256

set tabstop=2
set shiftwidth=2
set expandtab


if match($TERM, "screen")!=-1
  set term=xterm
endif

colorscheme darkblue
set conceallevel=0
syntax on

" Show trailing white space in red
highlight ExtraWhitespace ctermbg=red guibg=red
match ExtraWhitespace /\s\+$/

highlight UnwantedTab  guibg=blue ctermbg=darkblue
2match UnwantedTab /\t/

set rtp+=./.local/lib/python2.7/site-packages/powerline/bindings/vim
set laststatus=2

" }}}
