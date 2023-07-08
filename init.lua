local Plug = vim.fn['plug#']

vim.call('plug#begin', '~/appdata/local/nvim-data/plugged')

Plug 'itchyny/vim-gitbranch'

Plug 'neovim/nvim-lspconfig'

Plug 'noahfrederick/vim-hemisu'

vim.call('plug#end')

vim.opt.guifont = "Office Code Pro D:h14"

vim.opt.updatetime = 50
vim.opt.termguicolors = true
vim.opt.laststatus = 2
vim.opt.wrap = true
vim.opt.cursorline = true
vim.opt.swapfile = false

vim.opt.tabstop = 4
vim.opt.softtabstop = 4
vim.opt.shiftwidth = 4
vim.opt.expandtab = true

vim.cmd('let c_no_curly_error=1')

vim.cmd('NvuiAnimationsEnabled 1')
vim.cmd('NvuiCursorAnimationDuration 0.1')
vim.cmd('NvuiScrollAnimationDuration 0.05')
vim.cmd('NvuiMoveAnimationDuration 0.05')

vim.cmd('set guicursor=i:block20-Cursor')
vim.cmd('set guicursor=n-v-c:block20-Cursor')
vim.cmd('set t_md=')
vim.cmd('set smartindent')
vim.cmd('set nonu')
vim.cmd('set noshowmatch')
vim.cmd('set confirm')
vim.cmd('set showtabline=0')

vim.cmd('filetype indent plugin on')
vim.cmd('set backupdir=~/AppData/Local/nvim-data/backup')
vim.cmd('set mouse=a')
vim.cmd('set signcolumn=no')
vim.cmd('set clipboard=unnamed')
vim.cmd('set belloff=all')
vim.cmd('set completeopt-=preview')
vim.cmd('set completeopt=menu,menuone,noselect')
vim.cmd('set fillchars+=vert:\\|')
vim.cmd('set fillchars+=stl:-')
vim.cmd('set fillchars+=stlnc:-')
vim.cmd('set ssop-=options')
vim.cmd('set ssop+=winpos')
vim.cmd('set ssop+=winpos')
vim.cmd('set ssop+=resize')
vim.cmd('set backspace=indent,eol,start')
vim.cmd('set formatoptions-=cro')
vim.cmd('set guioptions=')
vim.cmd('set background=dark')
vim.cmd('color hemisu')

vim.keymap.set({'n'}, '<F8>', ':call AdjustFontSize(1)<CR>')
vim.keymap.set({'n'}, '<F7>', ':call AdjustFontSize(-1)<CR>')
vim.keymap.set({'i'}, '<F8>', '<Esc>:call AdjustFontSize(1)<CR>a')
vim.keymap.set({'i'}, '<F7>', '<Esc>:call AdjustFontSize(-1)<CR>a')

vim.keymap.set({'n'}, '<A-g>', ':NvuiToggleFullscreen<CR>')
vim.keymap.set({'i'}, '<A-g>', '<Esc>:NvuiToggleFullscreen<CR>a')

vim.api.nvim_exec([[

    let s:fontsize = 14
    function! AdjustFontSize(amount)
      let s:fontsize = s:fontsize+a:amount
      :execute "set guifont=Office\\ Code\\ Pro\\ D:h" . s:fontsize
    endfunction

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

]], true)

vim.api.nvim_create_autocmd({"VimLeave"}, {
    command = "call SaveSess()"
})

vim.api.nvim_create_autocmd({"VimEnter"}, {
    command = "nested call RestoreSess()"
})

vim.api.nvim_create_autocmd({"BufEnter"}, {
    command = "call UpdateSLine()"
})

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

require'lspconfig'.clangd.setup{
    on_attach = on_attach,
    --cmd = { "clangd", "--completion-style=detailed" },
    --cmd = { "clangd", "--function-arg-placeholders" },
    --cmd = { "clangd", "-j=8" },
    --cmd = { "clangd", "--background-index" },
    --cmd = { "clangd", "--malloc-trim" },
    --cmd = { "clangd", "--pch-storage=memory" },
}

local servers = {'clangd'}
local root_dir =  {'compile_commands.json'}

local my_format = function(diagnostic)
    if(diagnostic.severity == vim.diagnostic.severity.WARN) then
        return string.format("%s: %s", diagnostic.source, "warning") 
    elseif(diagnostic.severity == vim.diagnostic.severity.ERROR) then
        return string.format("%s: %s", diagnostic.source, "error") 
    end
end

vim.diagnostic.config({
    virtual_text = {
        format = my_format,
        spacing = 0,
        prefix = "@",
    },
    float = {focus=false, source = "always", border = 'single'},
    severity_sort = true,
    update_in_insert = true,
})

local create_diagnostic_floating_window = function()
    local buffnr,win_id = vim.diagnostic.open_float(nil)
    if(win_id ~= nil) then
        local pos = vim.api.nvim_win_get_cursor(0)
        local off = vim.api.nvim_win_get_width(win_id) + pos[2]
        local win_width = vim.api.nvim_win_get_width(0)
        if(off > win_width) then
            off = win_width - off
        else
            off = 0
        end
        vim.api.nvim_win_set_config(win_id, {relative = "cursor", row = 1, col = off}) 
    end
end

vim.api.nvim_create_autocmd({"CursorHold", "CursorHoldI"}, {
    callback = function() create_diagnostic_floating_window() end,
})
