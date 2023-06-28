call plug#begin()

Plug 'matveyt/vim-modest'

Plug 'itchyny/vim-gitbranch'

"Plug 'nvim-treesitter/nvim-treesitter'

"Plug 'neoclide/coc.nvim', {'branch': 'release'}

Plug 'neovim/nvim-lspconfig'

Plug 'hrsh7th/nvim-cmp'
Plug 'hrsh7th/cmp-nvim-lsp'
Plug 'hrsh7th/cmp-buffer'
Plug 'hrsh7th/cmp-path'
Plug 'hrsh7th/cmp-cmdline'
Plug 'hrsh7th/cmp-nvim-lsp-signature-help'

"Plug 'hrsh7th/cmp-vsnip'
"Plug 'hrsh7th/vim-vsnip'

Plug 'ray-x/lsp_signature.nvim'

Plug 'alligator/accent.vim'

Plug 'aditya-azad/candle-grey'

Plug 'kristijanhusak/vim-hybrid-material'

Plug '~romainl/vim-bruin'

Plug 'andreasvc/vim-256noir'

Plug 'karoliskoncevicius/distilled-vim'

Plug 'andreypopp/vim-colors-plain'

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
        vim.keymap.set('n', '[', vim.lsp.buf.hover, bufopts)
        vim.keymap.set('n', 'RE', vim.lsp.buf.rename, bufopts)
        vim.keymap.set('n', 'CR', vim.lsp.buf.references, bufopts)
    end

    --require'nvim-treesitter.configs'.setup {
    --  highlight = {enable = true}
    --}

    require'lspconfig'.clangd.setup{
        on_attach = on_attach,
        --init_options = {
        --    highlight = {
        --        lsRanges = true;
        --    }
        --},
        --cmd = { "clangd", "--completion-style=detailed" },
        --cmd = { "clangd", "--function-arg-placeholders" },
        --cmd = { "clangd", "-j=8" },
        --cmd = { "clangd", "--background-index" },
        --cmd = { "clangd", "--malloc-trim" },
        --cmd = { "clangd", "--pch-storage=memory" },
    }

    local servers = {'clangd'}
    local root_dir =  {'compile_commands.json'}

    local cmp = require'cmp'
    cmp.setup({

        window = {
          completion = cmp.config.window.bordered(),
          documentation = cmp.config.window.bordered(),
        },

        completion = {
          autocomplete = true,
        },

        mapping = cmp.mapping.preset.insert({
           --['<C-b>'] = cmp.mapping.scroll_docs(-4),
           --['<C-f>'] = cmp.mapping.scroll_docs(4),
           ['<C-k>'] = cmp.mapping.select_prev_item(),
           ['<C-j>'] = cmp.mapping.select_next_item(),
           ['<C-Space>'] = cmp.mapping.complete(),
           ['<C-e>'] = cmp.mapping.abort(),
           ['<CR>'] = cmp.mapping.confirm({ select = false}), -- Accept currently selected item. Set `select` to `false` to only confirm explicitly selected items.
         }),

        sources = cmp.config.sources({
          { name = 'nvim_lsp' },
          { name = 'nvim_lsp_signature_help' },
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
        update_in_insert = true,
    })

    vim.cmd([[autocmd CursorHold,CursorHoldI * lua vim.diagnostic.open_float(nil, {focus=false, source = "always", border = 'single'})]])

    --local cfg = {
    --    debug = false,
    --    hint_enable = false,
    --    auto_close_after = nil,
    --    handler_opts = { border = "single" },
    --    max_width = 80,
    --}
    --require'lsp_signature'.setup(cfg) 

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
filetype indent plugin on
set backspace=indent,eol,start
set belloff=all
set wrap
set cursorline
syntax enable
set termguicolors
set background=dark
set laststatus=2
set mouse=a
set formatoptions-=cro
set guioptions=

let g:nvy = 0

let g:neovide_cursor_trail_size = 0.05
let g:neovide_cursor_animation_length = 0.05
let g:neovide_scroll_animation_length = 0.1
let g:neovide_refresh_rate = 60
let g:neovide_fullscreen = v:true 
let g:neovide_remember_window_size = v:true
let g:neovide_cursor_antialiasing = v:false

set guifont=Office\ Code\ Pro\ D:h14

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

let g:accent_colour = 'orange'
let g:accent_darken = 1
let g:codedark_conservative = 0
color hemisu

NvuiAnimationsEnabled 1
NvuiCursorAnimationDuration 0.1
NvuiScrollAnimationDuration 0.05
NvuiMoveAnimationDuration 0.05
"NvuiCmdline 0
"NvuiCmdPadding 8
"NvuiCmdCenterXPos 0.5
"NvuiCmdCenterYPos 0.5
"NvuiCmdWidth 0.6
"NvuiCmdFontFamily Office Code Pro D
"NvuiCmdFontSize 18

let s:fontsize = 12
function! AdjustFontSize(amount)
  let s:fontsize = s:fontsize+a:amount
  :execute "set guifont=Office\\ Code\\ Pro\\ D:h" . s:fontsize
endfunction

noremap <F8> :call AdjustFontSize(1)<CR>
noremap <F7> :call AdjustFontSize(-1)<CR>
inoremap <F8> <Esc>:call AdjustFontSize(1)<CR>a
inoremap <F7> <Esc>:call AdjustFontSize(-1)<CR>a

noremap <A-g> :NvuiToggleFullscreen<CR>
inoremap <A-g> <Esc>:NvuiToggleFullscreen<CR>a

hi! Cursor ctermfg=1 ctermbg=1 guifg=#000000 guibg=#00FF00

hi! link Character String

"hi! link LspCxxHlGroupNamespace Normal
"hi! link LspCxxHlSymNamespace LspCxxHlGroupNamespace
"hi! link LspCxxHlSymFunction Normal
"hi! link LspCxxHlSymVariable Identifier
"hi! link LspCxxHlSymParameter Identifier
"hi! link LspCxxHlGroupMemberVariable Normal
"hi! link LspCxxHlSymField Normal
"hi! link LspCxxHlSymMethod Normal
"hi! link LspCxxHlSymEnum Type
"hi! link LspCxxHlGroupEnumConstant Constant
"hi! link LspCxxHlSymEnumMember LspCxxHlGroupEnumConstant
"hi! link LspCxxHlSymVariableExtern Constant
"hi! link LspCxxHlSymVariableStatic Constant

"hi! link myoperators Type 
"hi mybrackets guifg=#c9c9c9 gui=NONE
"hi mymisc guifg=#c9c9c9 gui=NONE

"hi Comment guifg=#e3696fa
