call plug#begin()

Plug 'matveyt/vim-modest'

Plug 'itchyny/vim-gitbranch'

Plug 'nvim-treesitter/nvim-treesitter'

"Plug 'neoclide/coc.nvim', {'branch': 'release'}

Plug 'neovim/nvim-lspconfig'

Plug 'hrsh7th/nvim-cmp'
Plug 'hrsh7th/cmp-nvim-lsp'
Plug 'hrsh7th/cmp-buffer'
Plug 'hrsh7th/cmp-path'
Plug 'hrsh7th/cmp-cmdline'

"Plug 'hrsh7th/cmp-vsnip'
"Plug 'hrsh7th/vim-vsnip'
"
Plug 'ray-x/lsp_signature.nvim'

Plug 'lmintmate/blue-mood-vim'

Plug 'morhetz/gruvbox'

Plug 'altercation/vim-colors-solarized'

Plug 'noahfrederick/vim-hemisu'

Plug 'lifepillar/vim-solarized8'

Plug 'NLKNguyen/papercolor-theme'

Plug 'junegunn/seoul256.vim'

"Plug 'jackguo380/vim-lsp-cxx-highlight'

Plug 'arzg/vim-colors-xcode'

Plug 'fxn/vim-monochrome'

Plug 'tomasiser/vim-code-dark'

Plug 'zekzekus/menguless'

Plug 'danishprakash/vim-yami'

Plug 'marcopaganini/mojave-vim-theme'

Plug 'semibran/vim-colors-synthetic'

Plug 'andreypopp/vim-colors-plain'

Plug 'ulwlu/elly.vim'

call plug#end()

set completeopt=menu,menuone,noselect

lua << EOF

    local opts = { noremap=true, silent=true }
    vim.keymap.set('n', 'FD', vim.diagnostic.goto_prev, opts)
    vim.keymap.set('n', 'BD', vim.diagnostic.goto_next, opts)
    vim.keymap.set('n', '<space>q', vim.diagnostic.setloclist, opts)

    local on_attach = function(client, bufnr)
        vim.api.nvim_buf_set_option(bufnr, 'omnifunc', 'v:lua.vim.lsp.omnifunc')

        -- Mappings.
        -- See `:help vim.lsp.*` for documentation on any of the below functions
        local bufopts = { noremap=true, silent=true, buffer=bufnr }
        vim.keymap.set('n', 'CD', vim.lsp.buf.declaration, bufopts)
        vim.keymap.set('n', 'CT', vim.lsp.buf.definition, bufopts)
        vim.keymap.set('n', 'K', vim.lsp.buf.hover, bufopts)
        vim.keymap.set('n', 'CF', vim.lsp.buf.implementation, bufopts)
        vim.keymap.set('n', 'RE', vim.lsp.buf.rename, bufopts)
        vim.keymap.set('n', 'CR', vim.lsp.buf.references, bufopts)
    end

    require'nvim-treesitter.configs'.setup {
      highlight = {enable = true}
    }

    require'lspconfig'.clangd.setup{
        on_attach = on_attach,
        --cmd = { "clangd", "--completion-style=detailed" },
        cmd = { "clangd", "--function-arg-placeholders" },
    }

    local servers = {'clangd'}
    local root_dir =  {'compile_commands.json'}

    local cmp = require'cmp'
    cmp.setup({

        window = {
          completion = cmp.config.window.bordered(),
          documentation = cmp.config.window.bordered(),
        },

        mapping = cmp.mapping.preset.insert({
           ['<C-b>'] = cmp.mapping.scroll_docs(-4),
           ['<C-f>'] = cmp.mapping.scroll_docs(4),
           ['<C-k>'] = cmp.mapping.select_prev_item(),
           ['<C-j>'] = cmp.mapping.select_next_item(),
           ['<C-Space>'] = cmp.mapping.complete(),
           ['<C-e>'] = cmp.mapping.abort(),
           ['<CR>'] = cmp.mapping.confirm({ select = true }), -- Accept currently selected item. Set `select` to `false` to only confirm explicitly selected items.
         }),

        sources = cmp.config.sources({
          { name = 'nvim_lsp' },
        }, {
          { name = 'buffer' },
        })
    })

    local my_format = function(diagnostic)
        if(diagnostic.severity == vim.diagnostic.severity.WARN)
            then return string.format("%s: %s", diagnostic.source, "Warning") 
        elseif(diagnostic.severity == vim.diagnostic.severity.ERROR)
            then return string.format("%s: %s", diagnostic.source, "Error") 
        end
    end

    vim.diagnostic.config({
        virtual_text = {
            format = my_format,
            spacing = 0,
            prefix = "@",
        },
    })

    vim.cmd([[autocmd CursorHold,CursorHoldI * lua vim.diagnostic.open_float(nil, {focus=false, source = "always", border = 'single'})]])

    cfg = {
      debug = false, -- set to true to enable debug logging
      log_path = vim.fn.stdpath("cache") .. "/lsp_signature.log", -- log dir when debug is on
      -- default is  ~/.cache/nvim/lsp_signature.log
      verbose = false, -- show debug line number
    
      bind = true, -- This is mandatory, otherwise border config won't get registered.
                   -- If you want to hook lspsaga or other signature handler, pls set to false
      doc_lines = 10, -- will show two lines of comment/doc(if there are more than two lines in doc, will be truncated);
                     -- set to 0 if you DO NOT want any API comments be shown
                     -- This setting only take effect in insert mode, it does not affect signature help in normal
                     -- mode, 10 by default
    
      max_height = 12, -- max height of signature floating_window
      max_width = 80, -- max_width of signature floating_window
      noice = false, -- set to true if you using noice to render markdown
      wrap = true, -- allow doc/signature text wrap inside floating_window, useful if your lsp return doc/sig is too long
      
      floating_window = true, -- show hint in a floating window, set to false for virtual text only mode
    
      floating_window_above_cur_line = true, -- try to place the floating above the current line when possible Note:
      -- will set to true when fully tested, set to false will use whichever side has more space
      -- this setting will be helpful if you do not want the PUM and floating win overlap
    
      floating_window_off_x = 1, -- adjust float windows x position.
      floating_window_off_y = 0, -- adjust float windows y position. e.g -2 move window up 2 lines; 2 move down 2 lines
    
      --close_timeout = 4000, -- close floating window after ms when laster parameter is entered
      fix_pos = false,  -- set to true, the floating window will not auto-close until finish all parameters
      --hint_enable = true, -- virtual hint enable
      --hint_prefix = "@ ",  -- Panda for parameter, NOTE: for the terminal not support emoji, might crash
      --hint_scheme = "String",
      hi_parameter = "LspSignatureActiveParameter", -- how your parameter will be highlight
      handler_opts = {
        border = "single"   -- double, rounded, single, shadow, none, or a table of borders
      },
    
      always_trigger = false, -- sometime show signature on new line or in middle of parameter can be confusing, set it to false for #58
    
      auto_close_after = nil, -- autoclose signature float win after x sec, disabled if nil.
      extra_trigger_chars = {}, -- Array of extra characters that will trigger signature completion, e.g., {"(", ","}
      zindex = 200, -- by default it will be on top of all floating windows, set to <= 50 send it to bottom
    
      padding = '', -- character to pad on left and right of signature can be ' ', or '|'  etc
    
      transparency = nil, -- disabled by default, allow floating win transparent value 1~100
      shadow_blend = 100, -- if you using shadow as border use this set the opacity
      shadow_guibg = 'Black', -- if you using shadow as border use this set the color e.g. 'Green' or '#121315'
      timer_interval = 200, -- default timer check interval set to lower value if you want to reduce latency
      toggle_key = nil, -- toggle signature on and off in insert mode,  e.g. toggle_key = '<M-x>'
    
      select_signature_key = nil, -- cycle to next signature, e.g. '<M-n>' function overloading
      move_cursor_key = nil, -- imap, use nvim_set_current_win to move cursor between current win and floating
    }
    require'lsp_signature'.setup(cfg) 

EOF

fu! SaveSess()
  execute 'mksession! ' . getcwd() . '/.session.vim'
endfunction

fu! RestoreSess()
  if filereadable(getcwd() . '/.session.vim')
    execute 'so ' . getcwd() . '/.session.vim'
    if bufexists(1)
      for l in range(1, bufnr('$'))
        if bufwinnr(l) == -1
          exec 'sbuffer ' . l
        endif
      endfor
    endif
  endif
endfunction

fu! UpdateSLine()
    let branch = gitbranch#name()
    if match(branch, '\S') >= 0
        execute 'set statusline='
        execute 'set statusline+=' . branch . '\|\ '
        execute 'set statusline+=%f'
        execute 'set statusline+=%m'
        execute 'set statusline+=\ [line\ %l\/%L]' 
    else
        execute 'set statusline=%f'
        execute 'set statusline+=%m'
        execute 'set statusline+=\ [line\ %l\/%L]' 
    endif
endfunction

autocmd VimLeave * call SaveSess()
autocmd VimEnter * nested call RestoreSess()

autocmd BufEnter * call UpdateSLine()

call rpcnotify(0, "Gui", "Option", "Popupmenu", 0)

set signcolumn=no

let c_no_curly_error = 1
let g:seoul256_background = 233
let g:gruvbox_contrast_dark = 'hard'
let g:gruvbox_bold = 0
let g:gruvbox_termcolors = 16
let b:coc_suggest_disable = 1
let g:solarized_italics = 0
set backupdir=~/AppData/Local/nvim-data/backup
set updatetime=300
set completeopt-=preview
set clipboard=unnamed
set fillchars+=vert:\|
set fillchars+=stl:-
set fillchars+=stlnc:-
set ssop-=options
set ssop+=winpos
set ssop+=winpos
set ssop+=resize
set formatoptions-=cro
filetype indent plugin on
set backspace=indent,eol,start
set belloff=all
set wrap
syntax enable
set termguicolors
set background=dark
set laststatus=2
set guicursor=
set mouse=a
set formatoptions-=r
set formatoptions-=o
set guioptions=

set guifont=Office\ Code\ Pro\ D:h14


let s:fontsize = 12
function! AdjustFontSize(amount)
  let s:fontsize = s:fontsize+a:amount
  :execute "GuiFont! Office Code Pro D:h" . s:fontsize
endfunction

noremap <F8> :call AdjustFontSize(1)<CR>
noremap <F7> :call AdjustFontSize(-1)<CR>
inoremap <F8> <Esc>:call AdjustFontSize(1)<CR>a
inoremap <F7> <Esc>:call AdjustFontSize(-1)<CR>a

set guicursor=i:block20-Cursor
set guicursor=n-v-c:block20-Cursor
set t_md=
set smartindent
set tabstop=4
set shiftwidth=4
set clipboard=unnamed
set expandtab
set nonu
set hlsearch
set noshowmatch
set confirm
set showtabline=0

let g:codedark_conservative = 0
color codedark

"inoremap { {}<Esc>ha
"inoremap ( ()<Esc>ha
"inoremap [ []<Esc>ha
"inoremap " ""<Esc>ha
"inoremap ' ''<Esc>ha
"inoremap ` ``<Esc>ha

"hi link LspCxxHlSymVariable Identifier
"hi Comment guifg=#e396fa
"hi link myoperators Operator

map <C-o> <Nop>
map <F1> <Nop>
map <Home> <Nop>
vmap <C-c> "+yi<end>
vmap <C-x> "+c
vmap <silent><C-v> <ESC>p

"nmap <A-PageDown> :tabm -1<CR>
"nmap <A-PageUp> :tabm +1<CR>

"search and replace in line range
nmap <F1> :#,#s///g
imap <F1> <ESC>:#,#s///g

nmap <C-z> u
nmap <C-s> :update!<CR>
nmap <silent><C-l> _y$
nmap <S-Up> <ESC>O
nmap <S-Down> <ESC>o
nmap <C-Down> :m +1<CR>
nmap <C-Up> :m -2<CR>
nmap <C-k> "_dd
imap <C-k> <ESC>"_dd
imap <C-l> <ESC>_y$i
imap <silent><C-v> <ESC>pi
imap <C-s> <Esc>:update!<CR>i<Right>
imap <C-z> <ESC>:u<CR>i
imap <C-d> <ESC>0v$hyo<ESC>pki
imap <Home> <ESC>_i
imap <C-F9> <ESC>:q<CR>
imap <silent><C-F10> <ESC>:wq<CR>
imap <S-Up> <ESC>O
imap <C-Down> <ESC>:m +1<CR>i
imap <C-Up> <ESC>:m -2<CR>i
imap <S-Down> <ESC>o
imap <silent><F10> <ESC>mpi
imap <silent><F11> <ESC>mmi
imap <silent><C-F11> <ESC>mxi
imap <silent><F12> <ESC>mni
inoremap <A-h> <C-o>h
inoremap <A-j> <C-o>j
inoremap <A-k> <C-o>k
inoremap <A-l> <C-o>l

:map <MiddleMouse> <Nop>
:imap <MiddleMouse> <Nop>

