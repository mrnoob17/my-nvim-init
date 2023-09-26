local Plug = vim.fn['plug#']

vim.call('plug#begin', '~/appdata/local/nvim-data/plugged')

Plug 'noahfrederick/vim-hemisu'

vim.call('plug#end')

vim.opt.updatetime = 50
vim.opt.termguicolors = true
vim.opt.laststatus = 2
vim.opt.wrap = true
vim.opt.swapfile = false
vim.opt.guicursor = ""

vim.opt.guifont='Office Code Pro D:h14'

vim.opt.tabstop = 4
vim.opt.softtabstop = 4
vim.opt.shiftwidth = 4
vim.opt.expandtab = true

vim.cmd('let c_no_curly_error=1')

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
