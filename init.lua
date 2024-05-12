local Plug = vim.fn['plug#']

vim.call('plug#begin', '~/appdata/local/nvim-data/plugged')

Plug 'neovim/nvim-lspconfig'
Plug 'noahfrederick/vim-hemisu'
Plug 'rluba/jai.vim'

vim.call('plug#end')

vim.opt.updatetime = 50
vim.opt.termguicolors = true
vim.opt.laststatus = 2
vim.opt.wrap = true
vim.opt.swapfile = false
vim.opt.guicursor = ""

vim.opt.guifont='Courier Prime Code:h12'

vim.opt.tabstop = 4
vim.opt.softtabstop = 4
vim.opt.shiftwidth = 4
vim.opt.expandtab = true

vim.cmd('let c_no_curly_error=1')
vim.cmd('let g:zig_fmt_autosave = 0')
vim.cmd('set t_md=')
vim.cmd('set smartindent')
vim.cmd('set nonu')
vim.cmd('set noshowmatch')
vim.cmd('set confirm')
vim.cmd('set showtabline=0')

vim.cmd('filetype indent plugin on')
vim.cmd('set mouse=a')
vim.cmd('set signcolumn=no')
vim.cmd('set clipboard=unnamed')
vim.cmd('set belloff=all')
vim.cmd('set virtualedit=block')

vim.cmd('set completeopt-=preview')
vim.cmd('set completeopt=menu,menuone,noselect')

vim.cmd('set fillchars+=vert:\\.')
vim.cmd('set fillchars+=stl:.')
vim.cmd('set fillchars+=stlnc:.')

vim.cmd('set ssop-=options')
vim.cmd('set ssop+=winpos')
vim.cmd('set ssop+=resize')

vim.cmd('set backspace=indent,eol,start')
vim.cmd('set formatoptions-=cro')
vim.cmd('set guioptions=')
vim.cmd('set background=dark')
vim.cmd('color hemisu')

--vim.cmd("hi! link @lsp.mod.declaration Label")
--vim.cmd("hi! link @lsp.type.property Normal")
--vim.cmd("hi! link Identifier Normal")
--vim.cmd("hi! link Function Normal")
--vim.cmd("hi! link Structure Type")
--vim.cmd("hi! link @lsp.typemod.enumMember.declaration",  { "fg": s:accent6})
--vim.cmd("hi! link @lsp.mod.class",                    { "fg": s:accent5})
--vim.cmd("hi! link @lsp.typemod.variable.globalScope", { "fg": s:accent6})
--vim.cmd("hi! link @lsp.type.namespace",               { "fg": s:accent5})

vim.cmd('set backupdir=~/appdata/local/nvim-data/backup')
vim.cmd('set directory=~/appdata/local/nvim-data/backup')
vim.cmd('set undodir=~/appdata/local/nvim-data/backup')

vim.api.nvim_exec([[

    fu! UpdateStatusLine()
        execute 'set statusline=%f'
        execute 'set statusline+=%m'
        execute 'set statusline+=\ [line\ %l\/%L]' 
    endfunction

]], true)

local project_create_session = function()
    if vim.fn.filereadable(string.format("%s\\%s", vim.fn.getcwd(), "_project_")) == 1 then
        vim.cmd("mks! sess.vim")
    end 
end

local project_load_session = function()
    if vim.fn.filereadable(string.format("%s\\%s", vim.fn.getcwd(), "_project_")) == 1 then
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

local check_custom_file_types = function()
    if vim.bo.filetype == ".mphs" then
        vim.cmd("set filetype=mphs")      
    elseif vim.bo.filetype == ".crk" then
        vim.cmd("set filetype=cpp")      
    elseif vim.bo.filetype == ".rly" then
        vim.cmd("set filetype=rly")      
    end
end

vim.api.nvim_create_autocmd({"BufNewFile", "BufRead"}, {
    callback = function() check_custom_file_types() end,
})

local buf_enter_commands = function()
    vim.cmd("set cursorline")
    vim.cmd("call UpdateStatusLine()")
end

vim.api.nvim_create_autocmd({"BufEnter"}, {
    callback = function() buf_enter_commands() end,
})

vim.api.nvim_create_autocmd({"BufLeave"}, {
    command = "set nocursorline"
})

local opts = { noremap=true, silent=true }
vim.keymap.set('n', 'FD', vim.diagnostic.goto_prev, opts)
vim.keymap.set('n', 'BD', vim.diagnostic.goto_next, opts)
vim.keymap.set('n', '<space>q', vim.diagnostic.setloclist, opts)

local on_attach = function(client, bufnr)

    vim.api.nvim_buf_set_option(bufnr, 'omnifunc', 'v:lua.vim.lsp.omnifunc')

    local bufopts = { noremap=true, silent=true, buffer=bufnr }
    vim.keymap.set('n', 'CD', vim.lsp.buf.declaration, bufopts)
    vim.keymap.set('n', 'CT', vim.lsp.buf.definition, bufopts)
    vim.keymap.set('n', '[', vim.lsp.buf.hover, bufopts)
    vim.keymap.set('n', 'RE', vim.lsp.buf.rename, bufopts)
    vim.keymap.set('n', 'CR', vim.lsp.buf.references, bufopts)
    vim.keymap.set('n', 'F', vim.lsp.buf.code_action, bufopts)

end

require'lspconfig'.clangd.setup{
    on_attach = on_attach,
    cmd = { "clangd", "--clang-tidy=false", "--background-index", "-j=8"},
}

local servers = {'clangd'}
local root_dir =  {'compile_commands.json'}

local my_format = function(diagnostic)
    if diagnostic.severity == vim.diagnostic.severity.WARN then
        return string.format("%s: %s", diagnostic.source, "warning") 
    elseif diagnostic.severity == vim.diagnostic.severity.ERROR then
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

local diagnostic_window = nil 

local create_diagnostic_window = function()
    _, diagnostic_window = vim.diagnostic.open_float(nil)
end

vim.api.nvim_create_autocmd({"CursorHold"}, {
    callback = function() create_diagnostic_window() end,
})
