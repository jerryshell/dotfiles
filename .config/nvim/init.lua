-- ============================================================
-- 第 1 节: 选项
-- Neovim 核心设置、leader 键、选项、基本按键映射、基本自动命令
-- ============================================================
do
    -- 通过缓存已编译的 Lua 模块来加快启动速度
    vim.loader.enable()

    -- 将 <space> 设置为 leader 键
    vim.g.mapleader = ' '
    vim.g.maplocalleader = ' '

    -- 如果安装了 Nerd 字体设置为 true
    vim.g.have_nerd_font = true

    -- [[ 设置选项 ]]

    -- 默认显示行号
    vim.o.number = true
    -- 相对行号
    vim.o.relativenumber = true

    -- 启用鼠标模式 在调整分屏大小时很有用
    vim.o.mouse = 'a'

    -- 显示模式
    vim.o.showmode = true

    -- 同步操作系统和 Neovim 之间的剪贴板
    vim.schedule(function() vim.o.clipboard = 'unnamedplus' end)

    -- 启用换行缩进
    vim.o.breakindent = true

    -- 即使关闭并重新打开文件也能撤销、重做更改
    vim.o.undofile = true

    -- 大小写不敏感搜索
    -- 除非使用 \C 或搜索词中含有一个或多个大写字母
    vim.o.ignorecase = true
    vim.o.smartcase = true

    -- 默认始终显示标志列
    vim.o.signcolumn = 'yes'

    -- 减少更新时间
    vim.o.updatetime = 250

    -- 减少按键序列的等待时间
    vim.o.timeoutlen = 300

    -- 配置新分屏的打开方式
    vim.o.splitright = true
    vim.o.splitbelow = true

    -- 设置 Neovim 在编辑器中显示特定空白字符的方式
    vim.o.list = true
    vim.opt.listchars = { tab = '» ', trail = '·', nbsp = '␣' }

    -- 键入时实时预览替换效果
    vim.o.inccommand = 'split'

    -- 高亮光标所在的行
    vim.o.cursorline = true

    -- 光标上方和下方保留的最少屏幕行数
    vim.o.scrolloff = 10

    -- 如果执行的操作会因缓冲区中存在未保存的更改而失败 例如 :q
    -- 改为弹出一个对话框询问是否希望保存当前文件
    vim.o.confirm = true
end

-- ============================================================
-- 第 2 节: 按键映射
-- 基本按键映射
-- ============================================================
do
    -- [[ 基本按键映射 ]]

    -- 在普通模式下按 <Esc> 时清除搜索高亮
    vim.keymap.set('n', '<Esc>', '<cmd>nohlsearch<CR>')

    -- 诊断配置与按键映射
    vim.diagnostic.config {
        update_in_insert = false,
        severity_sort = true,
        float = { border = 'rounded', source = 'if_many' },
        underline = { severity = { min = vim.diagnostic.severity.WARN } },

        -- 可以根据需要在这两个选项之间切换
        virtual_text = true,   -- 文本显示在行尾
        virtual_lines = false, -- 文本显示在行的下方 以虚拟行形式呈现

        -- 自动打开浮动窗口,这样在使用 `[d` 和 `]d` 跳转时可以方便地阅读错误信息
        jump = {
            on_jump = function(_, bufnr)
                vim.diagnostic.open_float {
                    bufnr = bufnr,
                    scope = 'cursor',
                    focus = false,
                }
            end,
        },
    }

    vim.keymap.set('n', '<leader>q', vim.diagnostic.setloclist, { desc = '打开诊断 [Q]uickfix 列表' })

    -- 在内置终端中使用一个更容易的快捷键退出终端模式
    -- 否则通常需要按 <C-\><C-n> 这对于没有经验的人来说不容易猜到
    vim.keymap.set('t', '<Esc><Esc>', '<C-\\><C-n>', { desc = '退出终端模式' })

    -- 在普通模式下禁用方向键并提示
    -- vim.keymap.set('n', '<left>', '<cmd>echo "请使用 h 移动!!"<CR>')
    -- vim.keymap.set('n', '<right>', '<cmd>echo "请使用 l 移动!!"<CR>')
    -- vim.keymap.set('n', '<up>', '<cmd>echo "请使用 k 移动!!"<CR>')
    -- vim.keymap.set('n', '<down>', '<cmd>echo "请使用 j 移动!!"<CR>')

    -- 便于分屏导航的按键绑定
    vim.keymap.set('n', '<C-h>', '<C-w><C-h>', { desc = '将焦点移至左侧窗口' })
    vim.keymap.set('n', '<C-l>', '<C-w><C-l>', { desc = '将焦点移至右侧窗口' })
    vim.keymap.set('n', '<C-j>', '<C-w><C-j>', { desc = '将焦点移至下方窗口' })
    vim.keymap.set('n', '<C-k>', '<C-w><C-k>', { desc = '将焦点移至上方窗口' })

    -- 注意: 某些终端存在冲突的按键映射,或无法发送不同的键码
    -- vim.keymap.set("n", "<C-S-h>", "<C-w>H", { desc = "将窗口移动到左侧" })
    -- vim.keymap.set("n", "<C-S-l>", "<C-w>L", { desc = "将窗口移动到右侧" })
    -- vim.keymap.set("n", "<C-S-j>", "<C-w>J", { desc = "将窗口移动到下方" })
    -- vim.keymap.set("n", "<C-S-k>", "<C-w>K", { desc = "将窗口移动到上方" })

    -- [[ 基本自动命令 ]]

    -- 复制(yank)文本时高亮
    vim.api.nvim_create_autocmd('TextYankPost', {
        desc = '复制文本时高亮',
        group = vim.api.nvim_create_augroup('kickstart-highlight-yank', { clear = true }),
        callback = function() vim.hl.on_yank() end,
    })
end
