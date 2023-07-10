local Plug = vim.fn['plug#']

vim.call('plug#begin', '~/appdata/local/nvim-data/plugged')

Plug 'neovim/nvim-lspconfig'

Plug 'noahfrederick/vim-hemisu'

vim.call('plug#end')

--vim.opt.guifont = "Ysabeau Infant:h14"

vim.opt.updatetime = 50
vim.opt.termguicolors = true
vim.opt.laststatus = 2
vim.opt.wrap = true
vim.opt.cursorline = true
vim.opt.swapfile = false
vim.opt.guicursor = ""

vim.opt.tabstop = 4
vim.opt.softtabstop = 4
vim.opt.shiftwidth = 4
vim.opt.expandtab = true

vim.cmd('let c_no_curly_error=1')

--vim.cmd('NvuiAnimationsEnabled 1')
--vim.cmd('NvuiCursorAnimationDuration 0.1')
--vim.cmd('NvuiScrollAnimationDuration 0.05')
--vim.cmd('NvuiMoveAnimationDuration 0.05')

--vim.cmd('set guicursor=i:block20-Cursor')
--vim.cmd('set guicursor=n-v-c:block20-Cursor')

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

    fu! UpdateStatusLine()
        execute 'set statusline=%f'
        execute 'set statusline+=%m'
        execute 'set statusline+=\ [line\ %l\/%L]' 
    endfunction

]], true)

local project_create_session = function()
    if vim.fn.filereadable(string.format("%s\\%s", vim.fn.getcwd(), "_project_")) then
        vim.cmd("mks! sess.vim")
    end 
end

local project_load_session = function()
    if vim.fn.filereadable(string.format("%s\\%s", vim.fn.getcwd(), "_project_")) then
        vim.cmd("so sess.vim")
    end 
end

vim.api.nvim_create_autocmd({"VimLeave"}, {
    callback = function() project_create_session() end,
})

vim.api.nvim_create_autocmd({"VimEnter"}, {
	nested = true,
    callback = function() project_load_session() end,
})

vim.api.nvim_create_autocmd({"BufEnter"}, {
    command = "call UpdateStatusLine()"
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

local floating_format = function(diagnostic)
    return string.format("%s (%s)", diagnostic.message, diagnostic.source) 
end

vim.diagnostic.config({
    virtual_text = {
        format = my_format,
        spacing = 0,
        prefix = "@",
    },
    float = {header = "", focus = false, source = false, border = 'rounded', suffix = ""},
    severity_sort = true,
    update_in_insert = false,
})

local create_diagnostic_floating_window = function()
    local buffnr, win_id = vim.diagnostic.open_float(nil)
    -- NOTE some gui front ends fail to keep the floating window inside the main window, so have to do some stuff!
    --if(win_id ~= nil) then
    --    local pos = vim.api.nvim_win_get_cursor(0)
    --    local off = vim.api.nvim_win_get_width(win_id) + pos[2]
    --    local win_width = vim.api.nvim_win_get_width(0)
    --    if(off > win_width) then
    --        off = win_width - off
    --    else
    --        off = 0
    --    end
    --    vim.api.nvim_win_set_config(win_id, {style = "minimal", relative = "cursor", row = 1, col = off}) 
    --end
end

vim.api.nvim_create_autocmd({"CursorHold", "CursorHoldI"}, {
    callback = function() create_diagnostic_floating_window() end,
})

