-- === 基础 ===
-- 缓存编译的 Lua 模块，加快启动
vim.loader.enable()

-- 空格是前缀键（leader）
vim.g.mapleader = ' '
vim.g.maplocalleader = ' '
-- 终端已装 Nerd Font
vim.g.have_nerd_font = true

-- === 界面 ===
-- 相对行号
vim.o.relativenumber = true
-- 鼠标支持（滚动/点选）
vim.o.mouse = 'a'
-- 诊断/书签留出侧栏，不挤文字
vim.o.signcolumn = 'yes'
-- 当前行高亮
vim.o.cursorline = true
-- 滚动时光标距上下边缘至少 10 行
vim.o.scrolloff = 10
-- 显示空白字符
vim.o.list = true
vim.opt.listchars = { tab = '» ', trail = '·', nbsp = '␣' }
-- 真彩色，主题必需
vim.o.termguicolors = true
-- 平滑滚动
vim.opt.smoothscroll = true
-- 标签栏按需显示（多标签时才显示）
vim.o.showtabline = 1

-- === 编辑 ===
-- Tab 展开为空格
vim.o.expandtab = true
vim.o.tabstop = 4
vim.o.shiftwidth = 4
-- 换行自动对齐缩进
vim.o.autoindent = true
-- 长行折行后保持缩进
vim.o.breakindent = true
-- 持久化撤销记录
vim.o.undofile = true
-- 切换文件不丢未保存更改
vim.o.hidden = true
-- 外部修改自动重载
vim.o.autoread = true
-- 有 undofile，关掉 .swp 垃圾
vim.o.swapfile = false
-- 新窗口开在右侧/下方
vim.o.splitright = true
vim.o.splitbelow = true
-- 保存/放弃失败时先确认而非报错
vim.o.confirm = true
-- 系统剪贴板
vim.schedule(function() vim.o.clipboard = 'unnamedplus' end)

-- === 搜索 ===
-- 搜索忽略大小写（智能：含大写则区分）
vim.o.ignorecase = true
vim.o.smartcase = true
-- 实时预览替换
vim.o.inccommand = 'split'
-- Esc 顺手清掉搜索高亮
vim.keymap.set('n', '<Esc>', '<cmd>nohlsearch<CR>')

-- === 补全 ===
-- 命令补全菜单
vim.o.wildmenu = true
-- 命令补全弹窗
vim.o.wildoptions = 'pum'
-- 弹出菜单不自动选中
vim.o.completeopt = 'menuone,noselect'

-- === 快捷键 ===
vim.keymap.set('n', '<leader>w', '<cmd>write<CR>', { desc = '保存' })
vim.keymap.set({ 'n', 'i' }, '<C-s>', '<cmd>write<CR>', { desc = '保存' })
vim.keymap.set('n', '<leader>t', '<cmd>tabnew<CR>', { desc = '新标签' })
for i = 1, 9 do
    vim.keymap.set('n', '<leader>' .. i, '<cmd>tabnext ' .. i .. '<CR>', { desc = '标签 ' .. i })
end
vim.keymap.set('n', '<leader>h', '<cmd>help<CR>', { desc = '帮助' })
vim.keymap.set('n', '<leader>e', vim.cmd.Lexplore, { desc = '左侧文件树' })
-- === 搜索：自动检测工具，没有则用内置 ===
-- 文件查找：有 fzf 用 fzf 选择器（fd/find 喂列表），否则内置 :find
vim.o.path = '**' -- :find / gf 递归搜索的路径
local function has_tool(t) return vim.fn.executable(t) == 1 end
local function fzf_files()
    -- 列表源：有 fd 用 fd（快），否则 find；fzf 选中的路径写入临时文件
    local listcmd = has_tool('fd') and 'fd -t f -H -I' or 'find . -type f'
    local outfile = vim.fn.tempname()
    vim.fn.termopen({ 'bash', '-lc', listcmd .. ' | fzf > ' .. outfile }, {
        on_exit = function()
            local sel = vim.fn.readfile(outfile)
            vim.fn.delete(outfile)
            if #sel > 0 then vim.cmd.edit(sel[1]) end -- Esc/中断则不打开
        end,
    })
end
if has_tool('fzf') then
    vim.keymap.set('n', '<leader>f', fzf_files, { desc = '找文件(fzf)' })
else
    vim.keymap.set('n', '<leader>f', ':find ', { desc = '找文件(内置)' })
end
vim.keymap.set('n', '<leader>b', ':b ', { desc = '跳转缓冲区' })

-- 内容搜索：有 rg 用 rg 进 quickfix（]q/[q 浏览），否则内置 grep
if has_tool('rg') then
    vim.o.grepprg = 'rg --vimgrep'
    vim.o.grepformat = '%f:%l:%c:%m'
end
vim.keymap.set('n', '<leader>g', ':grep ', { desc = '内容搜索' })
vim.keymap.set('n', '<leader>q', vim.diagnostic.setloclist, { desc = '诊断列表' })
vim.keymap.set('i', 'jj', '<Esc>', { desc = '退出插入模式' })
-- visual 模式粘贴时，选中文本丢入黑洞寄存器，不污染剪贴板
vim.keymap.set('x', 'p', '"_dP', { desc = '粘贴且不覆盖剪贴板' })
vim.keymap.set('n', ']q', '<cmd>cnext<CR>', { desc = '下一条错误' })
vim.keymap.set('n', '[q', '<cmd>cprev<CR>', { desc = '上一条错误' })
vim.keymap.set('t', '<Esc><Esc>', '<C-\\><C-n>', { desc = '退出终端模式' })
vim.keymap.set('n', '<C-h>', '<C-w><C-h>', { desc = '左移焦点' })
vim.keymap.set('n', '<C-j>', '<C-w><C-j>', { desc = '下移焦点' })
vim.keymap.set('n', '<C-k>', '<C-w><C-k>', { desc = '上移焦点' })
vim.keymap.set('n', '<C-l>', '<C-w><C-l>', { desc = '右移焦点' })

-- === 诊断 ===
-- 输入时不更新诊断（省 CPU）
vim.diagnostic.config {
    update_in_insert = false,
    severity_sort = true,
    float = { border = 'rounded', source = 'if_many' },
    -- 只给 WARN 以上加下划线
    underline = { severity = { min = vim.diagnostic.severity.WARN } },
    virtual_text = true,
    virtual_lines = false,
    jump = {
        on_jump = function(_, bufnr)
            vim.diagnostic.open_float { bufnr = bufnr, scope = 'cursor', focus = false }
        end,
    },
}

-- === 主题 ===
-- nvim 0.12 内置 catppuccin，无需插件
vim.cmd.colorscheme 'catppuccin'
-- 背景纯黑，更省 OLED 电
vim.api.nvim_set_hl(0, 'Normal', { bg = '#000000' })
vim.api.nvim_set_hl(0, 'NormalFloat', { bg = '#000000' })

-- === 折叠 ===
-- 基于语法树的折叠
vim.o.foldmethod = 'expr'
vim.o.foldexpr = 'v:lua.vim.treesitter.foldexpr()'
-- 默认全展开，za 手动折叠
vim.o.foldlevelstart = 99

-- === Treesitter ===
-- 有解析器的语言自动启用高亮（无解析器则静默跳过）
vim.api.nvim_create_autocmd({ 'BufReadPost', 'BufNewFile' }, {
    desc = '启用 Treesitter 高亮',
    callback = function() pcall(vim.treesitter.start) end,
})

-- === 杂项 ===
-- 复制文本时高亮
vim.api.nvim_create_autocmd('TextYankPost', {
    group = vim.api.nvim_create_augroup('highlight-yank', { clear = true }),
    callback = function() vim.hl.on_yank() end,
})
