syntax on

set number
set smartindent
set incsearch
set ignorecase
set smartcase 
set showcmd
set showmatch
set wildmenu
set nobackup
set nowritebackup
set noswapfile
call plug#begin()
Plug 'vim-airline/vim-airline'
Plug 'vim-airline/vim-airline-themes'
Plug 'preservim/nerdtree'
Plug 'morhetz/gruvbox'
Plug 'neoclide/coc.nvim', {'branch': 'release'}
Plug 'preservim/nerdcommenter'
Plug 'alx741/vim-rustfmt'
Plug 'jiangmiao/auto-pairs'
call plug#end()

set termguicolors 
set background=dark
colorscheme gruvbox

nnoremap <C-n> :NERDTreeToggle<CR>
autocmd BufEnter * if (winnr("$") == 1 && exists("b:NERDTree") && b:NERDTree.isTabTree()) | q | endif

nnoremap <C-p> :Files<CR>
nnoremap <C-f> :Rg<CR>

let g:NERDSpaceDelims = 1 " Добавлять пробел после комментария
let g:NERDDefaultAlign = 'left'

inoremap <silent><expr> <TAB>
      \ pumvisible() ? "\<C-n>" :
      \ <SID>check_back_space() ? "\<TAB>" :
      \ coc#refresh()
inoremap <expr><S-TAB> pumvisible() ? "\<C-p>" : "\<C-h>"

function! s:check_back_space() abort
  let col = col('.') - 1
  return !col || getline('.')[col - 1]  =~# '\s'
endfunction

" gd - перейти к определению
nmap <silent> gd <Plug>(coc-definition)
" gy - перейти к типу
nmap <silent> gy <Plug>(coc-type-definition)
" gi - перейти к реализации
nmap <silent> gi <Plug>(coc-implementation)
" gr - найти использования (references)
nmap <silent> gr <Plug>(coc-references)
" K - показать документацию при наведении
nnoremap <silent> K :call <SID>show_documentation()<CR>
function! s:show_documentation()
  if (index(['vim','help'], &filetype) >= 0)
    execute 'h '.expand('<cword>')
  else
    call CocAction('doHover')
  endif
endfunction
