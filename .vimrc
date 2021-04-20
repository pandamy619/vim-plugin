call plug#begin()
    " python
    Plug 'preservim/nerdtree'
    Plug 'junegunn/fzf', { 'do': { -> fzf#install() } }
    Plug 'junegunn/fzf.vim'
    Plug 'preservim/nerdcommenter'
    Plug 'liuchengxu/vista.vim'
    Plug 'zxqfl/tabnine-vim'
    " theme
    Plug 'morhetz/gruvbox'
    Plug 'gruvbox-material/vim', {'as': 'gruvbox-material'}
    " /theme
    Plug 'Vimjas/vim-python-pep8-indent'
    Plug 'jiangmiao/auto-pairs'
    Plug 'davidhalter/jedi-vim'
    Plug 'majutsushi/tagbar'
    " golang
    Plug 'fatih/vim-go', { 'do': ':GoUpdateBinaries' }
    Plug 'vim-airline/vim-airline'
    Plug 'vim-airline/vim-airline-themes'
call plug#end()

" Start NERDTree and leave the cursor in it.
autocmd VimEnter * NERDTree

" Create default mappings
let g:NERDCreateDefaultMappings = 1

" Add spaces after comment delimiters by default
let g:NERDSpaceDelims = 1

" Use compact syntax for prettified multi-line comments
let g:NERDCompactSexyComs = 1

" Align line-wise comment delimiters flush left instead of following code indentation
let g:NERDDefaultAlign = 'left'

" Set a language to use its alternate delimiters by default
let g:NERDAltDelims_java = 1

" Add your own custom formats or override the defaults
let g:NERDCustomDelimiters = { 'c': { 'left': '"""', 'right': '#' } }

" Allow commenting and inverting empty lines (useful when commenting a region)
let g:NERDCommentEmptyLines = 1

" Enable trimming of trailing whitespace when uncommenting
let g:NERDTrimTrailingWhitespace = 1

" Enable NERDCommenterToggle to check all selected lines is commented or not
let g:NERDToggleCheckAllLines = 1

let NERDTreeShowHidden = 1

map <C-z> :NERDTreeToggle<CR> “ Toggle side window with `CTRL+z`.
let g:NERDTreeDirArrowExpandable = '▸'
let g:NERDTreeDirArrowCollapsible = '▾'
let NERDTreeShowHidden=1 "Show hidden files

function! NearestMethodOrFunction() abort
  return get(b:, 'vista_nearest_method_or_function', '')
endfunction

set statusline+=%{NearestMethodOrFunction()}

" By default vista.vim never run if you don't call it explicitly.
"
" If you want to show the nearest function in your statusline automatically,
" you can add the following line to your vimrc
autocmd VimEnter * call vista#RunForNearestMethodOrFunction()

"autocmd vimenter * ++nested colorscheme gruvbox
"let g:gruvbox_contrast_dark = "hard"
let g:gruvbox_material_disable_italic_comment = 1
let g:gruvbox_material_background = "hard"

autocmd vimenter * ++nested colorscheme gruvbox-material

au BufNewFile,BufRead *.py
    \ set expandtab       |" replace tabs with spaces
    \ set autoindent      |" copy indent when starting a new line
    \ set tabstop=4
    \ set softtabstop=4
    \ set shiftwidth=4

au BufNewFile,BufRead *.py set foldmethod=indent

nnoremap <space> za

let g:ale_linters = {
      \   'python': ['flake8', 'pylint'],
      \   'ruby': ['standardrb', 'rubocop'],
      \   'javascript': ['eslint'],
      \}

nmap <F8> :TagbarToggle<CR>
autocmd FileType python,c,cpp,go TagbarOpen

let g:airline#extensions#tabline#enabled = 1

" let g:go_fmt_command = "goimports"    
" let g:go_auto_type_info = 1          

" au filetype go inoremap <buffer> . .<C-x><C-o>
        	
" filetype plugin on

filetype plugin indent on

set autowrite

"Go syntax highlighting
let g:go_highlight_fields = 1
let g:go_highlight_functions = 1
let g:go_highlight_function_calls = 1
let g:go_highlight_extra_types = 1
let g:go_highlight_operators = 1

"Auto formatting and importing
let g:go_fmt_autosave = 1
let g:go_fmt_command = "goimports"

" Status line types/signatures
let g:go_auto_type_info = 1

" Run :GoBuild or :GoTestCompile based on the go file
function! s:build_go_files()
  let l:file = expand('%')
  if l:file =~# '^\f\+_test\.go$'
    call go#test#Test(0, 1)
  elseif l:file =~# '^\f\+\.go$'
    call go#cmd#Build(0)
  endif
endfunction

"Map keys for most used commands.
"Ex: `\b` for building, `\r` for running and `\b` for running test.
autocmd FileType go nmap <leader>b :<C-u>call <SID>build_go_files()<CR>
autocmd FileType go nmap <leader>r  <Plug>(go-run)
autocmd FileType go nmap <leader>t  <Plug>(go-test)

au filetype go inoremap <buffer> . .<C-x><C-o>

set rtp+=$GOPATH/src/golang.org/x/lint/misc/vim
autocmd BufWritePost,FileWritePost *.go execute 'Lint' | cwindow 
