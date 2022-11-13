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
runtime! ftplugin/man.vim
nnoremap Y y$

# PLUGINS SETUP {{{
g:vim_markdown_folding_disabled = 1
g:Run_run_before = 'sp | wincmd J'
g:Run_compilewin_cur = 1
g:Run_runwin_cur = 1
g:sbline_dynamic_tabline = 1
g:sbline_show_bfnr = 0
# }}}

# PLUGINS {{{
plug#begin()
    # absolutely needed
    # Plug 'gboncoffee/run.vim'
    Plug '~/src/run.vim'
    Plug 'gboncoffee/lf.vim'
    Plug 'gboncoffee/statusbufferline.vim'
    Plug 'junegunn/fzf.vim'
    Plug 'andymass/vim-matchup'
    # editing
    Plug 'junegunn/vim-easy-align'
    Plug 'tpope/vim-commentary'
    # helpers
    Plug 'tpope/vim-eunuch'
    Plug 'tpope/vim-rsi'
    # git
    Plug 'tpope/vim-fugitive'
    # langs
    Plug 'kchmck/vim-coffee-script'
    Plug 'preservim/vim-markdown'
    # kawaii
    Plug 'ryanoasis/vim-devicons'
plug#end()
# }}}

# MINOR SETS {{{
g:sbline_ignore = [ "lf", "quickfix", "nofile", "fugitive" ]

def SetDefaultCompilers()
	g:Run_filetype_defaults["markdown"] = "mdcat $#"
	g:Run_filetype_defaults["lua"]      = "luajit $#"
enddef
augroup CompilerDefaults
	autocmd VimEnter * call SetDefaultCompilers()
augroup END
# }}}

# GREAT DEFAULTS {{{
# appearance/visual helpers
set nowrap
set signcolumn=no
set scrolloff=5
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

def Apropos2Man(entry: string = "")
    var page = entry
    var section = ''
    var page_ind = match(page, " ")
    var op_ind = match(page, "(")
    var cp_ind = match(page, ")")

    if page_ind > -1
        page = slice(page, 0, page_ind - 1)
    endif
    if (op_ind > -1) && (cp_ind > -1)
        section = slice(entry, op_ind + 1, cp_ind)
    endif

    if !empty(page)
        exe 'Man' section page
    endif
enddef

command! -nargs=1 OpenManFromApropos Apropos2Man(<q-args>)
command! -bang -nargs=* Rg
            \ fzf#vim#grep(
            \ 'rg --glob "!*.git*" --column --line-number --no-heading --color=always --smart-case --hidden -- ' .. shellescape(<q-args>), 1,
            \ fzf#vim#with_preview(), <bang>0)

var fzf_man_opts = {
    'source': 'man -k .',
    'sink': 'OpenManFromApropos',
    'options': "-e +i --tiebreak=begin,chunk --preview-window=\"hidden\""}
command! -nargs=0 FZFMan fzf#run(fzf#wrap(fzf_man_opts))
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
nnoremap <Space>m :FZFMan<CR>
nnoremap <Space>h :Helptags<CR>
nnoremap <Space>/ :Rg<CR>
# others
nmap ga <Plug>(EasyAlign)
xmap ga <Plug>(EasyAlign)
nnoremap <Space>g  :G<CR>
nnoremap <Space>f  :LfNoChangeCwd<CR>
nnoremap <Space>n  :LfChangeCwd<CR>
nnoremap <Space>s  :s//g<Left><Left>
nnoremap <Space>%s :%s//g<Left><Left>
nnoremap <Space>l  :setlocal nu! rnu!<CR>
nnoremap <C-n>     :nohl<CR>
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

# HIGHLIGHTS {{{

# checks my colorscheme
def IsIn(c: list<string>, i: string): number
    for item in c
        if item == i
            return 1
        endif
    endfor
    return 0
enddef

var light_schemes = [ 'Doom-One-Light.yml', 'Catppuccin-Latte.yml', 'VSCode-Light.yml' ]
var filepath = resolve($HOME .. "/.config/alacritty/colors.yml")
filepath = strpart(filepath, strridx(filepath, '/') + 1)
if !IsIn(light_schemes, filepath)
    set background=dark
endif

def HighlightOnEnter()
    if getwinvar(winnr(), "&t_Co") != "8"
        hi TabLineFill  NONE
        hi StatusLine   NONE
        hi VertSplit    NONE
        hi StatusLineNC NONE

        hi TabLineFill  ctermfg = DarkGrey
        hi StatusLine   ctermfg = White
        hi VertSplit    ctermfg = White
        hi StatusLineNC ctermfg = DarkGrey

        hi Comment      ctermfg = DarkGrey cterm = italic  
        hi Visual       ctermfg = Black    ctermbg = DarkGrey cterm = bold
    endif
enddef

augroup HighlightOnEnter
    autocmd!
    autocmd VimEnter * call HighlightOnEnter()
augroup END

hi LineNrAbove  ctermfg = DarkGrey
hi LineNrBelow  ctermfg = DarkGrey
# }}}
