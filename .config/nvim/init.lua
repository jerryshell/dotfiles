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
-- :find / gf 递归搜索
vim.o.path = '**'
vim.keymap.set('n', '<leader>f', ':find ', { desc = '找文件' })
vim.keymap.set('n', '<leader>b', ':b ', { desc = '跳转缓冲区' })
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

-- === 注释切换（无插件） ===
-- 用文件自带 commentstring 判断注释符（treesitter 已启用，sh/py 等都能识别）
-- 支持 //、#、--、<!-- -->、/* */（单行）等常见形式
local function toggle_comment_range(s, e)
    local cs = vim.bo.commentstring
    if not cs then
        vim.notify('该文件类型未定义 commentstring'); return
    end
    local pre, suf = cs:match('^(.-)%%s(.-)$')
    if not pre then
        vim.notify('commentstring 格式不支持: ' .. cs); return
    end
    local core = pre:gsub('%s+$', '') -- '// ' → '//'
    local core_esc = core:gsub('[^%w%s]', '%%%0')
    for l = s, e do
        local head, rest = vim.fn.getline(l):match('^(%s*)(.*)$')
        if rest:sub(1, 2) ~= '#!' then       -- shebang 不参与切换
            local commented
            if rest:sub(1, #pre) == pre then -- 标准注释，如 '// x'、'# x'
                rest = rest:sub(#pre + 1)
                commented = true
            elseif rest:sub(1, #core) == core then -- '//x'、'#x' 这类无空格注释
                rest = rest:gsub('^' .. core_esc .. ' ?', '', 1)
                commented = true
            elseif core == '//' and rest:match('^/%*.*%*/$') then -- 单行块注释 /* x */
                rest = rest:gsub('^/%*%s*', ''):gsub('%s*%*/$', '')
                commented = true
            end
            if suf ~= '' and rest:sub(- #suf) == suf then -- 双段注释去尾部，如 '<!-- x -->'
                rest = rest:sub(1, - #suf - 1)
                commented = true
            end
            if not commented then
                rest = pre .. rest .. (suf ~= '' and suf or '')
            end
            vim.fn.setline(l, head .. rest)
        end
    end
end
vim.keymap.set('n', 'gc', function()
    -- 支持 3gc 切换 3 行
    toggle_comment_range(vim.fn.line('.'), vim.fn.line('.') + math.max(vim.v.count, 1) - 1)
end, { desc = '切换注释' })
vim.keymap.set('x', 'gc', function()
    vim.cmd 'normal! \27' -- 先退出可视模式，'< '> 标记才会提交
    local s, e = vim.fn.line("'<"), vim.fn.line("'>")
    toggle_comment_range(s, e)
    vim.cmd 'normal! gv' -- 重新选中，可反复切换
end, { desc = '切换注释' })

-- === 杂项 ===
-- 复制文本时高亮
vim.api.nvim_create_autocmd('TextYankPost', {
    group = vim.api.nvim_create_augroup('highlight-yank', { clear = true }),
    callback = function() vim.hl.on_yank() end,
})
