set nocompatible " Use Vim defaults (much better!)
filetype off " required!
set tabstop=2
set expandtab
syntax on
set shiftwidth=2
set number

autocmd FileType js setlocal ts=2 sts=2 sw=2 expandtab

autocmd FileType yaml setlocal ts=2 sts=2 sw=2 expandtab
autocmd FileType yml setlocal ts=2 sts=2 sw=2 expandtab

autocmd FileType php setlocal ts=4 sts=4 sw=4 expandtab

autocmd FileType scala setlocal ts=4 sts=4 sw=4 expandtab
let g:netrw_bufsettings = 'noma nomod nu nobl nowrap ro'

call plug#begin()
Plug 'roxma/nvim-completion-manager'
Plug 'SirVer/ultisnips'
Plug 'honza/vim-snippets'
Plug 'ervandew/supertab'

" assuming your using vim-plug: https://github.com/junegunn/vim-plug
Plug 'roxma/nvim-yarp'

Plug 'tpope/vim-vinegar'

" fzf
Plug 'junegunn/fzf', { 'dir': '~/.fzf', 'do': './install --all' }
Plug 'junegunn/fzf.vim'

Plug 'itchyny/lightline.vim'
Plug 'tpope/vim-eunuch'
Plug 'tpope/vim-surround'
Plug 'editorconfig/editorconfig-vim'
"
"Plug 'w0rp/ale'
Plug 'airblade/vim-gitgutter'

Plug 'ensime/ensime-vim', { 'do': ':UpdateRemotePlugins' }

" Language plugins
" Scala plugins
if executable('scalac')
  Plug 'derekwyatt/vim-scala', { 'for': 'scala' }
endif

Plug 'roxma/nvim-yarp'
Plug 'roxma/vim-hug-neovim-rpc'
Plug 'cloudhead/neovim-fuzzy'
Plug 'neomake/neomake'

"Code completion with Deoplete - enabled by ensime
if has('nvim')
  Plug 'Shougo/deoplete.nvim', { 'do': ':UpdateRemotePlugins' }
else
  Plug 'Shougo/deoplete.nvim'
  Plug 'roxma/nvim-yarp'
  Plug 'roxma/vim-hug-neovim-rpc'
endif
let g:deoplete#enable_at_startup = 1
let g:deoplete#sources={}
let g:deoplete#sources._=['buffer', 'member', 'tag', 'file', 'omni', 'ultisnips']
let g:deoplete#omni#input_patterns={}
let g:deoplete#omni#input_patterns.scala='[^. *\t]\.\w*'
" Initialize plugin system

call plug#end()


" Use deoplete
let g:deoplete#enable_at_startup = 1
" fuzzy finder with ctrl-p
nnoremap <C-p> :FuzzyOpen<CR>

"Linting with neomake
let g:neomake_sbt_maker = {
      \ 'exe': 'sbt',
      \ 'args': ['-Dsbt.log.noformat=true', 'compile'],
      \ 'append_file': 0,
      \ 'auto_enabled': 1,
      \ 'output_stream': 'stdout',
      \ 'errorformat':
          \ '%E[%trror]\ %f:%l:\ %m,' .
            \ '%-Z[error]\ %p^,' .
            \ '%-C%.%#,' .
            \ '%-G%.%#'
     \ }
let g:neomake_enabled_makers = ['sbt']
let g:neomake_verbose=3

let g:SuperTabDefaultCompletionType = '<c-n>'

" Neomake on text change
autocmd InsertLeave,TextChanged * update | Neomake! sbt

function! QualifiedTagJump() abort
  let l:plain_tag = expand("<cword>")
  let l:orig_keyword = &iskeyword
  set iskeyword+=\.
  let l:word = expand("<cword>")
  let &iskeyword = l:orig_keyword

  let l:splitted = split(l:word, '\.')
  let l:acc = []
  for wo in l:splitted
    let l:acc = add(l:acc, wo)
    if wo ==# l:plain_tag
      break
    endif
  endfor

  let l:combined = join(l:acc, ".")
  try
    execute "ta " . l:combined
  catch /.*E426.*/ " Tag not found
    execute "ta " . l:plain_tag
  endtry
endfunction

nnoremap <C-a> :<C-u>call QualifiedTagJump()<CR>
