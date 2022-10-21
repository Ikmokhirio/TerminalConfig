call plug#begin()
Plug 'neoclide/coc.nvim', {'branch': 'release'}
Plug 'jackguo380/vim-lsp-cxx-highlight'
Plug 'gruvbox-community/gruvbox'

Plug 'vim-airline/vim-airline'
Plug 'vim-airline/vim-airline-themes'

Plug 'rhysd/vim-clang-format'

Plug 'preservim/nerdtree'

Plug 'mfussenegger/nvim-dap'

Plug 'akinsho/toggleterm.nvim', {'tag' : '*'}
Plug 'cdelledonne/vim-cmake'
call plug#end()

" Some servers have issues with backup files, see #649.
set nobackup
set nowritebackup

" Having longer updatetime (default is 4000 ms = 4 s) leads to noticeable
" delays and poor user experience.
set updatetime=300

" Always show the signcolumn, otherwise it would shift the text each time
" diagnostics appear/become resolved.
set signcolumn=yes

" Use tab for trigger completion with characters ahead and navigate.
" NOTE: There's always complete item selected by default, you may want to enable
" no select by `"suggest.noselect": true` in your configuration file.
" NOTE: Use command ':verbose imap <tab>' to make sure tab is not mapped by
" other plugin before putting this into your config.
inoremap <silent><expr> <TAB>
      \ coc#pum#visible() ? coc#pum#next(1) :
      \ CheckBackspace() ? "\<Tab>" :
      \ coc#refresh()
inoremap <expr><S-TAB> coc#pum#visible() ? coc#pum#prev(1) : "\<C-h>"

" Make <CR> to accept selected completion item or notify coc.nvim to format
" <C-g>u breaks current undo, please make your own choice.
inoremap <silent><expr> <CR> coc#pum#visible() ? coc#pum#confirm()
                              \: "\<C-g>u\<CR>\<c-r>=coc#on_enter()\<CR>"

function! CheckBackspace() abort
  let col = col('.') - 1
  return !col || getline('.')[col - 1]  =~# '\s'
endfunction

" GoTo code navigation.
nmap <silent> gd <Plug>(coc-definition)
nmap <silent> gy <Plug>(coc-type-definition)
nmap <silent> gi <Plug>(coc-implementation)
nmap <silent> gr <Plug>(coc-references)

" Use K to show documentation in preview window.
nnoremap <silent> K :call ShowDocumentation()<CR>

function! ShowDocumentation()
  if CocAction('hasProvider', 'hover')
    call CocActionAsync('doHover')
  else
    call feedkeys('K', 'in')
  endif
endfunction

" Highlight the symbol and its references when holding the cursor.
autocmd CursorHold * silent call CocActionAsync('highlight')

" Symbol renaming.
nmap <leader>rn <Plug>(coc-rename)

augroup mygroup
  autocmd!
  " Update signature help on jump placeholder.
  autocmd User CocJumpPlaceholder call CocActionAsync('showSignatureHelp')
augroup end

" Applying codeAction to the selected region.
" Example: `<leader>aap` for current paragraph
xmap <leader>a  <Plug>(coc-codeaction-selected)
nmap <leader>a  <Plug>(coc-codeaction-selected)

" Remap keys for applying codeAction to the current buffer.
nmap <leader>ac  <Plug>(coc-codeaction)
" Apply AutoFix to problem on the current line.
nmap <leader>qf  <Plug>(coc-fix-current)

" Run the Code Lens action on the current line.
nmap <leader>cl  <Plug>(coc-codelens-action)

" Add `:Fold` command to fold current buffer.
command! -nargs=? Fold :call     CocAction('fold', <f-args>)

" Add (Neo)Vim's native statusline support.
" NOTE: Please see `:h coc-status` for integrations with external plugins that
" provide custom statusline: lightline.vim, vim-airline.
set statusline^=%{coc#status()}%{get(b:,'coc_current_function','')}

" c++ syntax highlighting
let g:cpp_class_scope_highlight = 1
let g:cpp_member_variable_highlight = 1
let g:cpp_class_decl_highlight = 1

" Theme Setup
set termguicolors
colo gruvbox

" Default styling
" https://neovim.io/doc/user/options.html
" Tab stop=2 soft tab stop = 2 shift width = 2
set ts=2 sts=2 sw=2 et si ai rnu

" Auto format
let g:clang_format#detect_style_file = 1
nnoremap <Leader>f :<C-u>ClangFormat<CR>

" Nerd tree
inoremap <c-b> <Esc>:NERDTreeToggle<cr>
nnoremap <c-b> <Esc>:NERDTreeToggle<cr>

" Debuger configuration
" ADAPTER
lua << EOF
local dap = require('dap')
dap.adapters.lldb = {
  type = 'executable',
  command = 'W:/BuildTools/llvm-project/Release/bin/lldb-vscode', -- adjust as needed, must be absolute path
  name = 'lldb'
}
EOF
" CONFIGURATION
lua << EOF
local dap = require('dap')
dap.configurations.cpp = {
  {
    name = 'Launch',
    type = 'lldb',
    request = 'launch',
    program = function()
      return vim.fn.input('Path to executable: ', vim.fn.getcwd() .. '/', 'file')
    end,
    cwd = '${workspaceFolder}',
    stopOnEntry = false,
    args = {},
  },
}

dap.configurations.c = dap.configurations.cpp
vim.fn.sign_define('DapBreakpoint', {text='🔴', texthl='', linehl='', numhl=''})
vim.fn.sign_define('DapStopped', {text='🟢', texthl='', linehl='', numhl=''})
vim.fn.sign_define('DapBreakpointRejected', {text='❌', texthl='', linehl='', numhl=''})
EOF

"Example at https://github.com/David-Kunz/vim/blob/master/init.lua
nnoremap <F9> :lua require('dap').continue()<CR>
nnoremap <F7> :lua require('dap').step_into()<CR>
nnoremap <F8> :lua require('dap').step_over()<CR>
nnoremap <leader>br :lua require('dap').toggle_breakpoint()<CR>
nnoremap <leader>brl :lua require('dap').set_breakpoint(nil, nil, vim.fn.input('Log point message: '))<CR>
nnoremap <silent> <Leader>dr :lua require"dap".repl.toggle({}, "vsplit")<CR><C-w>l

nnoremap <leader>di :lua local widgets=require'dap.ui.widgets';widgets.sidebar(widgets.scopes).open()<CR>
vnoremap <leader>di :lua require"dap.ui.widgets".hover()<CR>


" CMAKE CONFIG
let g:cmake_command = 'cmake'
let g:cmake_default_config = 'Debug'
let g:cmake_generate_options = ['-DCMAKE_EXPORT_COMPILE_COMMANDS=ON','-G Ninja']
let g:cmake_root_markers = ['.git', '.svn', '.clang-format']
set statusline=%{cmake#GetInfo().cmake_version.string}

nmap <c-f5> <Plug>(CMakeBuildTarget)
nmap <f5> <Plug>(CMakeBuild)

"Terminal
lua << EOF
require("toggleterm").setup{
  open_mapping = [[<c-\>]],
}
EOF
autocmd TermEnter term://*toggleterm#*
      \ tnoremap <silent><c-t> <Cmd>exe v:count1 . "ToggleTerm"<CR>
nnoremap <silent><c-t> <Cmd>exe v:count1 . "ToggleTerm"<CR>
inoremap <silent><Esc><Cmd>exe v:count1 . "ToggleTerm"<CR>
