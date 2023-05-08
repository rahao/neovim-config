" __  ____   __  _   ___     _____ __  __ ____   ____
"|  \/  \ \ / / | \ | \ \   / /_ _|  \/  |  _ \ / ___|
"| |\/| |\ V /  |  \| |\ \ / / | || |\/| | |_) | |
"| |  | | | |   | |\  | \ V /  | || |  | |  _ <| |___
"|_|  |_| |_|   |_| \_|  \_/  |___|_|  |_|_| \_\\____|

" Author: @ruahao

" ==================== Neovim 编辑器配置 ====================
let mapleader=" "
syntax on
:set scrolloff=12
set number
set relativenumber

set hlsearch
set wildmenu
set nosmartcase
set cursorline
exec "nohlsearch"
set ignorecase
set scrolloff
set nocompatible
"hi Normal ctermfg=252 ctermbg=none
filetype on
filetype indent on
filetype plugin on
filetype plugin indent on
set mouse=a
set encoding=utf-8
let &t_ut=''
set expandtab
set tabstop=4
set shiftwidth=2
set softtabstop=2
set list
set listchars=tab:▸\ ,trail:▫
set tw=0
set indentexpr=
set backspace=indent,eol,start
set foldmethod=indent
set foldlevel=99
set laststatus=2
set autochdir
" 关闭自动注释下一行
autocmd FileType * setlocal formatoptions-=cro
au BufReadPost * if line("'\"") > 1 && line("'\"") <= line("$") | exe "normal! g'\"" | endif
" ==================== Basic Mappings ====================
" Open the vimrc file anytime
nnoremap <LEADER>rc :e $HOME/.config/nvim/init.vim<CR>
noremap <LEADER><CR> :nohlsearch<>

" save the undo history after quit the vim
silent !mkdir -p $HOME/.config/nvim/tmp/backup
silent !mkdir -p $HOME/.config/nvim/tmp/undo

"silent !mkdir -p $HOME/.config/nvim/tmp/sessions
set backupdir=$HOME/.config/nvim/tmp/backup,.
set directory=$HOME/.config/nvim/tmp/backup,.
if has('persistent_undo')
  set undofile
  set undodir=$HOME/.config/nvim/tmp/undo,.
endif

" Compile function
noremap r :call CompileRunGcc()<CR>
func! CompileRunGcc()
  exec "w"
  if &filetype == 'c'
    set splitbelow
    :sp
    :res -5
    term gcc % -o build/%< && time ./build/%<
  elseif &filetype == 'cpp'
    if !isdirectory("build")
      :silent !mkdir build
    endif
    set splitbelow
    exec "!g++ -std=c++11 % -Wall -o build/%<"
    :sp
    :res -15
    :term ./build/%<
  elseif &filetype == 'cs'
  	set splitbelow
  	silent! exec "!mcs %"
  	:sp
  	:res -5
  	:term mono %<.exe
  elseif &filetype == 'java'
  	set splitbelow
  	:sp
  	:res -5
  	term javac % && time java %<
  elseif &filetype == 'sh'
  	:!time bash %
  elseif &filetype == 'python'
  	set splitbelow
  	:sp
  	:term python3 %
  elseif &filetype == 'html'
  	silent! exec "!".g:mkdp_browser." % &"
  elseif &filetype == 'markdown'
  	exec "InstantMarkdownPreview"
  elseif &filetype == 'tex'
  	silent! exec "VimtexStop"
  	silent! exec "VimtexCompile"
  	"let l:pdf_file = expand("%:p:r") . ".pdf"
  	"set splitright
  	":vsp
  	":execute "silent !zathura " . l:pdf_file . " &"
  	"wincmd p
  elseif &filetype == 'dart'
  	exec "CocCommand flutter.run -d ".g:flutter_default_device." ".g:flutter_run_args
  	silent! exec "CocCommand flutter.dev.openDevLog"
  elseif &filetype == 'javascript'
  	set splitbelow
  	:sp
  	:term export DEBUG="INFO,ERROR,WARNING"; node --trace-warnings .
  elseif &filetype == 'racket'
  	set splitbelow
  	:sp
  	:res -5
  	term racket %
  elseif &filetype == 'go'
  	set splitbelow
  	:sp
  	:term go run .
  endif
endfunc
" New cursor movement (the default arrow keys are used for resizing windows)
"     ^
"     i
" < j   l >
"     k
"     v
noremap <silent> i k
noremap <silent> j h
noremap <silent> k j
noremap <silent> h i
noremap <silent> J 0
noremap <silent> L $
noremap <silent> I 5k
noremap <silent> K 5j
"快速查找当前光标下的单词
nnoremap <leader>f *N
noremap = nzz
noremap - Nzz
noremap <C-j> I
noremap <C-l> A
map <S-q> :q<CR>
map <S-s> :w<CR>
map s <nop>
map <S-r> :source $MYVIMRC<CR>
map sl :set splitright<CR>:vsplit<CR>
map sj :set nosplitright<CR>:vsplit<CR>
map sk :set splitbelow<CR>:split<CR>
map si :set nosplitbelow<CR>:split<CR>
map <C-a> 0ggvG
map <LEADER>l <C-w>l
map <LEADER>j <C-w>h
map <LEADER>i <C-w>k
map <LEADER>k <C-w>j
"修改删除操作，删除但不剪切
noremap <leader>d "_d
vnoremap <C-y> "+y
nnoremap <C-p> "*p
map <up> :res +5<CR>
map <down> :res -5<cR>>
map <right> :vertical resize-5<CR>
map <left> :vertical resize+5<CR>
" Place the two screens up and down
noremap sik <C-w>t<C-w>K
" Place the two screens side by side"
noremap sjl <C-w>t<C-w>H
map st :tabe<CR>
map tj :-tabnext<CR>
map tl :tabnext<CR>
" 导出 .md 为 .pdf
nnoremap <leader>md :silent !pandoc % -o %:p:h/%:r.pdf<CR>
" ==================== 插件配置 ====================
call plug#begin('$HOME/.config/nvim/plugged')
Plug 'preservim/nerdcommenter'
Plug 'majutsushi/tagbar', { 'on': 'TagbarOpenAutoClose' }
Plug 'neoclide/coc.nvim', {'branch': 'release'}
Plug 'jiangmiao/auto-pairs'
Plug 'morhetz/gruvbox'
Plug 'sonph/onehalf', { 'rtp': 'vim' }
Plug 'scrooloose/nerdtree', { 'on': 'NERDTreeToggle' }
Plug 'vim-airline/vim-airline'
Plug 'RRethy/vim-illuminate'
Plug 'Yggdroot/indentLine'
" Latex
Plug 'lervag/vimtex'
" MarkDown
Plug 'suan/vim-instant-markdown', {'for': 'markdown'}
Plug 'dhruvasagar/vim-table-mode', { 'on': 'TableModeToggle', 'for': ['text', 'markdown', 'vim-plug'] }
Plug 'mzlogin/vim-markdown-toc', { 'for': ['gitignore', 'markdown', 'vim-plug'] }
Plug 'dkarter/bullets.vim'
call plug#end()
"==================================================
"


" ==================== vim-instant-markdown ====================
let g:instant_markdown_slow = 0
let g:instant_markdown_autostart = 0
" let g:instant_markdown_open_to_the_world = 1
" let g:instant_markdown_allow_unsafe_content = 1
" let g:instant_markdown_allow_external_content = 0
" let g:instant_markdown_mathjax = 1
let g:instant_markdown_autoscroll = 1

" ==================== vim-markdown-toc ====================
"let g:vmt_auto_update_on_save = 0
"let g:vmt_dont_insert_fence = 1
let g:vmt_cycle_list_item_markers = 1
let g:vmt_fence_text = 'TOC'
let g:vmt_fence_closing_text = '/TOC'
" 显示缩进:indentLine
let g:indent_guides_guide_size  = 1  " 指定对齐线的尺寸
let g:indent_guides_start_level = 4  " 从第4层开始可视化显示缩进

" ==================== Bullets.vim ====================
" let g:bullets_set_mappings = 0
let g:bullets_enabled_file_types = [
      \ 'markdown',
      \ 'text',
      \ 'gitcommit',
      \ 'scratch'
\]

" gruvbox
"autocmd vimenter * ++nested colorscheme gruvbox
"set bg=dark
colorscheme gruvbox
set termguicolors
highlight Normal guibg=NONE ctermbg=NONE
highlight NonText guibg=NONE ctermbg=NONE

" vimtex
let g:vimtex_compiler_latexmk = {
    \ 'executable': 'latexmk',
    \ 'options': [
    \   '-pdf',
    \   '-verbose',
    \   '-file-line-error',
    \   '-synctex=1',
    \   '-interaction=nonstopmode',
    \ ],
    \}
" 启用自动编译和查看 PDF
let g:vimtex_view_method = 'zathura'
let g:vimtex_auto_compile = 1


"" nerdtree
map ff :NERDTreeToggle<CR>
let NERDTreeMapOpenExpl = ""
let NERDTreeMapUpdir = ""
let NERDTreeMapUpdirKeepOpen = "u"
let NERDTreeMapOpenSplit = ""
let NERDTreeOpenVSplit = ""
let NERDTreeMapActivateNode = "a"
let NERDTreeMapOpenInTab = "o"
let NERDTreeMapPreview = ""
let NERDTreeMapCloseDir = "n"
let NERDTreeMapChangeRoot = ""
let g:NERDTreeMapJumpNextSibling = get(g:, 'NERDTreeMapJumpNextSibling', '<C-k>')
let g:NERDTreeMapJumpPrevSibling = get(g:, 'NERDTreeMapJumpPrevSibling', '<C-i>')
" coc.nvim
let g:coc_global_extensions = [
      \ 'coc-marketplace',
      \ 'coc-vimlsp',
      \ 'coc-json',
      \ 'coc-yaml',
      \ 'coc-css',
      \ 'coc-python',
      \ 'coc-tsserver',
      \ 'coc-html',
      \ 'coc-snippets',
      \ 'coc-vetur']

" coc
" Use tab for trigger completion with characters ahead and navigate
" NOTE: There's always complete item selected by default, you may want to enable
" no select by `"suggest.noselect": true` in your configuration file
" NOTE: Use command ':verbose imap <tab>' to make sure tab is not mapped by
" other plugin before putting this into your config
inoremap <silent><expr> <TAB>
      \ coc#pum#visible() ? coc#pum#next(1) :
      \ CheckBackspace() ? "\<Tab>" :
      \ coc#refresh()
inoremap <expr><S-TAB> coc#pum#visible() ? coc#pum#prev(1) : "\<C-h>"

" Make <CR> to accept selected completion item or notify coc.nvim to format
" <C-g>u breaks current undo, please make your own choice
inoremap <silent><expr> <CR> coc#pum#visible() ? coc#pum#confirm()
                              \: "\<C-g>u\<CR>\<c-r>=coc#on_enter()\<CR>"

function! CheckBackspace() abort
  let col = col('.') - 1
  return !col || getline('.')[col - 1]  =~# '\s'
endfunction

" Use <c-o> to trigger completion
if has('nvim')
  inoremap <silent><expr> <c-space> coc#refresh()
else
  inoremap <silent><expr> <c-@> coc#refresh()
endif

" Use `[g` and `]g` to navigate diagnostics
" Use `:CocDiagnostics` to get all diagnostics of current buffer in location list
nmap <silent> <LEADER>- <Plug>(coc-diagnostic-prev)
nmap <silent> <LEADER>+ <Plug>(coc-diagnostic-next)

" GoTo code navigation
nmap <silent> gd <Plug>(coc-definition)
nmap <silent> gy <Plug>(coc-type-definition)
nmap <silent> gi <Plug>(coc-implementation)
nmap <silent> gr <Plug>(coc-references)

" Use K to show documentation in preview window
nnoremap <silent> <LEADER>h :call ShowDocumentation()<CR>

" Symbol renaming
nmap <leader>rn <Plug>(coc-rename)

" Formatting selected code
xmap <leader>f  <Plug>(coc-format-selected)
nmap <leader>f  <Plug>(coc-format-selected)









