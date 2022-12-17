vim9script
var data_dir = '~/.vim'
if empty(glob(data_dir .. '/autoload/plug.vim'))
    silent execute '!curl -fLo '.data_dir.'/autoload/plug.vim --create-dirs  https://raw.githubusercontent.com/junegunn/vim-plug/master/plug.vim'
    autocmd VimEnter * PlugInstall --sync | source ~/.vim/vimrc
endif
# just the basics
set viminfo+=n~/.vim/viminfo
filetype on
syntax on
set nocompatible
set clipboard^=unnamedplus
set path+=**
set hidden
set conceallevel=2
set ttimeoutlen=100
set background=dark
runtime! ftplugin/man.vim
nnoremap Y y$

# PLUGINS SETUP {{{
g:Run_run_before = 'sp | wincmd J'
g:Run_compilewin_cur = 1
g:Run_runwin_cur = 1
# }}}

# PLUGINS {{{
plug#begin()
    # absolutely needed
    Plug 'gboncoffee/run.vim'
    Plug 'junegunn/fzf.vim'
    # editing
    Plug 'junegunn/vim-easy-align'
    Plug 'tpope/vim-commentary'
    # helpers
    Plug 'tpope/vim-rsi'
    # langs
    Plug 'kchmck/vim-coffee-script'
plug#end()
# }}}

# GREAT DEFAULTS {{{
# appearance/visual helpers
set nowrap
set signcolumn=no
set scrolloff=10
set showcmd
set hlsearch
# editor
set splitbelow
set splitright
set foldmethod=marker
set tw=80
set ignorecase
set tabstop=4
set shiftwidth=4
set expandtab
# complete/search
set wildmenu
set wildmode=full
set completeopt=menu
set incsearch
# }}}

# FZF {{{
g:fzf_layout = { 
    'down': '30%' 
}

command! -bang -nargs=* Rg
            \ fzf#vim#grep(
            \ 'rg --glob "!*.git*" --column --line-number --no-heading --color=always --smart-case --hidden -- ' .. shellescape(<q-args>), 1,
            \ fzf#vim#with_preview(), <bang>0)

# }}}

# MAPPINGS {{{
nnoremap <Space><Space> /<++><CR>4xi

command! Mit  read ~/.vim/LICENSE
command! Head source ~/.vim/header.vim

# buffers
nnoremap <Tab>    :bn<CR>
nnoremap <S-Tab>  :bp<CR>
# run.vim
nnoremap <Space>b :Compile<CR>
nnoremap <Space>a :CompileAuto<CR>
nnoremap <Space>r :CompileReset<CR>
# run.vim :Run
nnoremap <Space><CR> :Run<CR>
nnoremap <Space>cp   :Run python<CR>
nnoremap <Space>co   :Run coffee<CR>
nnoremap <Space>cl   :Run lua<CR>
nnoremap <Space>cc   :Run julia<CR>
nnoremap <Space>cj   :Run node<CR>
nnoremap <Space>ch   :Run ghci<CR>
nnoremap <Space>cs   :Run btm<CR>
nnoremap <Space>cm   :Run ncmpcpp<CR>
# fzf
nnoremap <Space>. :FZF<CR>
nnoremap <Space>h :Helptags<CR>
nnoremap <Space>/ :Rg<CR>
# others
nnoremap <C-l>     :nohl<CR>
nnoremap <C-d>     <C-d>zz
nnoremap <C-u>     <C-u>zz
# }}}

# AUTOCMDS {{{
#
augroup FiletypeSettings
    autocmd!
    autocmd FileType python,shell,sh set formatoptions-=t
    autocmd FileType fzf set laststatus=0 | autocmd BufLeave <buffer> set laststatus=1
    autocmd FileType qf,fugitive,git,gitcommit,run-compiler nnoremap <buffer> q :bd<CR>
augroup END
# }}}
