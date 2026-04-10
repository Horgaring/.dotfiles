" --- Базовые настройки ---
syntax on                   " Включить подсветку синтаксиса
set number                  " Показать номера строк
set relativenumber          " Относительные номера (удобно для прыжков j/k)
set expandtab               " Использовать пробелы вместо табов
set shiftwidth=4            " Ширина отступа
set tabstop=4
set termguicolors           " Поддержка 24-битных цветов

call plug#begin()
" 1. Внешний вид и навигация
Plug 'morhetz/gruvbox'          " Популярная цветовая схема
Plug 'preservim/nerdtree'      " Дерево файлов слева
Plug 'vim-airline/vim-airline'  " Красивая статус-строка снизу

" 2. Работа с Rust
Plug 'rust-lang/rust.vim'       " Подсветка, форматирование и проверка синтаксиса
Plug 'neoclide/coc.nvim', {'branch': 'release'} " Движок для автодополнения (LSP)

" 3. Удобство редактирования
Plug 'tpope/vim-surround'      " Быстрая правка кавычек и скобок
Plug 'tpope/vim-commentary'    " Комментирование кода через `gcc`
Plug 'jiangmiao/auto-pairs'    " Автоматическое закрытие скобок

call plug#end()
" --- Настройки плагинов ---

" Цветовая схема
colorscheme gruvbox

" Настройка Rust: авто-форматирование при сохранении
let g:rustfmt_autosave = 1

" Настройка NERDTree (открыть/закрыть дерево файлов через Ctrl+n)
nnoremap <C-n> :NERDTreeToggle<CR>

" Настройка CoC (автодополнение)
" Нужно выполнить в Vim: :CocInstall coc-rust-analyzer coc-json
inoremap <silent><expr> <TAB> pumvisible() ? "\<C-n>" : "\<TAB>"
nnoremap <silent> gd <Plug>(coc-definition)
nnoremap <silent> gy <Plug>(coc-type-definition)
nnoremap <silent> gi <Plug>(coc-implementation)
nnoremap <silent> gr <Plug>(coc-references)
