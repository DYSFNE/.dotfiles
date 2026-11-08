" ============================================================
"   Last change: 11 - 07 - 2026
"   .vimrc  ::  configuration for DYSFNE
" ============================================================

set nocompatible
let mapleader = " "

set guifont=Iosevka:h12                 " Setting the font and font size for the editor

" ------------------------------------------------------------
" 1. WINDOWS TOOLCHAIN PATH
" ------------------------------------------------------------

" Configure Windows paths and shell behavior
" 'noshellslash is the default on Windows and uses backslashes in filenames
" Prepend MSYS2 UCRT64 and Git to PATH so their executables can be invoked
" from Vim without modifying the system-wide PATH 
"
" Example:
"   :!gcc main.c -o main.exe 
"

if has('win32')
    set noshellslash

    let $PATH = 'C:\msys64\ucrt64\bin;' .
          \ 'C:\Program Files\Git\cmd;' . $PATH
endif

" ------------------------------------------------------------
" 2. PLUGINS
" ------------------------------------------------------------

call plug#begin('~/vimfiles/plugged')

Plug 'dense-analysis/ale'
Plug 'morhetz/gruvbox'
Plug 'airblade/vim-gitgutter'
Plug 'tpope/vim-commentary'
Plug 'tpope/vim-surround'
Plug 'tpope/vim-fugitive'
Plug 'preservim/nerdtree'

call plug#end()

" ------------------------------------------------------------
" 3. APPEARANCE
" ------------------------------------------------------------

syntax enable
filetype plugin indent on

set background=dark

let g:gruvbox_contrast_dark = 'hard'

if !empty(globpath(&runtimepath, 'colors/gruvbox.vim'))
    colorscheme gruvbox
endif

set number                  " Show absolute line numbers for the current line
set relativenumber          " Show line numbers relative to the cursor
set cursorline              " Highlight the line containing the cursor
set signcolumn=yes          " Always show the sign column to prevent text shifting

set laststatus=2            " Always display the status line
set showcmd                 " Display partially entered commands
set ruler                   " Display the cursor's line and column position
set showmatch               " Briefly jump to the matching open bracket

set colorcolumn=101         " Highlight column 101
set nowrap                  " Disable line wrapping
set scrolloff=5             " Keep at least 5 lines visable above and below the cursor

set list                    " Display normally invisible characters
set listchars=tab:>-,trail:.,extends:>,precedes:<

" ------------------------------------------------------------
" 4. INDENTATION
" ------------------------------------------------------------

set expandtab               " Insert spaces instead of tab characters
set tabstop=4               " Display tab characters as 4-column tab stops
set shiftwidth=4            " Use 4 spaces for each level of identation
set softtabstop=4           " Use 4-column tab stops when inserting and deleting

set autoindent              " Copy indentation from the previous line
set smartindent             " Automatically indent based on C-like syntax

" ------------------------------------------------------------
" 5. SEARCH AND NAVIGATION
" ------------------------------------------------------------

set incsearch                   " Highlight matches while typing a search pattern
set hlsearch                    " Highlight all matches of the last search

set ignorecase                  " Ignore case when searching
set smartcase                   " Match case when the search contains uppercase letters

set wildmenu                    " Display an enhanced command-line completion menu
set wildmode=longest:full,full  " Complete the common prefix, then cycle through matches

set splitbelow                  " Open horizontal splits below the current window
set splitright                  " Open vertical splits to the right of the current window
set hidden                      " Allow switching buffers without saving changes

" ------------------------------------------------------------
" 6. EDITING AND FILE HANDLING
" ------------------------------------------------------------

set encoding=utf-8                  " Use UTF-8 for Vim's internal character encoding
set backspace=indent,eol,start      " Allow Backspace over autoindent, line breaks, and insert start

set undofile                        " Preserve undo history across editing sessions
set undodir=~/vimfiles/undo//       " Store persistent undo files in this directory

set autoread                        " Reload externally modified files when the buffer is unchanged
set confirm                         " Prompt to save when operation would discard changes

set updatetime=350                  " Update the swap file after 350 ms of inactivity 

set clipboard=unnamedplus           " Use the system clipboard for unnamed register operations

" ------------------------------------------------------------
" 7. COMPLETION
" ------------------------------------------------------------

set completeopt=menuone,noinsert,noselect   " Show completions without automatically selecting or inserting

" ------------------------------------------------------------
" 8. ALE: LANGUAGE SERVER AND DIAGNOSTICS
" ------------------------------------------------------------

" Only enable the linters explicitly listed here
let g:ale_linters_explicit = 1

let g:ale_linters = {
\   'c': ['clangd'],
\   'cpp': ['clangd'],
\}

" Use clangd for live parsing and static analysis.
" Allow clangd to query the UCRT64 GCC installations.
let s:query_drivers =
\ 'C:/msys64/ucrt64/bin/gcc.exe,' .
\ 'C:/msys64/ucrt64/bin/g++.exe'

let g:ale_c_clangd_options =
\ '--background-index --clang-tidy --query-driver=' .
\ s:query_drivers

let g:ale_cpp_clangd_options = g:ale_c_clangd_options

" Completion
let g:ale_completion_enabled = 1
let g:ale_completion_autoimport = 0

" Check diagnostics as we work
let g:ale_lint_on_text_changed = 'normal'
let g:ale_lint_on_insert_leave = 1
let g:ale_lint_on_save = 1

" Display diagnostics
let g:ale_echo_cursor = 1
let g:ale_sign_error = 'E'
let g:ale_sign_warning = 'W'

" ------------------------------------------------------------
" 9. AUTOMATIC FORMATTING
" ------------------------------------------------------------

let g:ale_fixers = {
\   'c': ['clang-format'],
\   'cpp': ['clang-format'],
\}

let g:ale_fix_on_save = 1

" ------------------------------------------------------------
" 10. GIT SETTINGS
" ------------------------------------------------------------

let g:gitgutter_map_keys = 0

" ------------------------------------------------------------
" 11. COMPILATION
" ------------------------------------------------------------

" Native Windows GNU Make from MSYS2 UCRT64
set makeprg=mingw32-make

" ------------------------------------------------------------
" 12. KEYBOARD SHORTCUTS
" ------------------------------------------------------------

" Go to definition
nnoremap <silent> gd :ALEGoToDefinition<CR>

" Find references
nnoremap <silent> gr :ALEFindReferences<CR>

" Show symbol information
nnoremap <silent> K :ALEHover<CR>

" Navigate diagnostics
nnoremap <silent> ]d :ALENext<CR>
nnoremap <silent> [d :ALEPrevious<CR>

" Format source code
nnoremap <silent> <leader>f :ALEFix<CR>

" Save
nnoremap <silent> <leader>w :write<CR>

" Compile current project
nnoremap <silent> <leader>b :update<CR>:make<CR>:cwindow<CR>

" Clear search highlighting
nnoremap <silent> <leader>h :nohlsearch<CR>

" ------------------------------------------------------------
" 13. C-SPECIFIC EDITING
" ------------------------------------------------------------

augroup my_c_settings
    autocmd!
    autocmd FileType c setlocal shiftwidth=4 tabstop=4
    autocmd FileType c setlocal expandtab
    autocmd FileType c setlocal colorcolumn=101
augroup END
