-- 通过缓存编译的 Lua 模块来加快启动速度
vim.loader.enable()

-- 设置 <space> 为 leader 键
vim.g.mapleader = ' '
vim.g.maplocalleader = ' '

-- 如果在终端中安装了 Nerd Font，设为 true
vim.g.have_nerd_font = true

-- 显示行号
-- vim.o.number = true
-- 也可以添加相对行号，以帮助跳转
vim.o.relativenumber = true

-- 启用鼠标模式，在调整分割窗口大小时很有用
vim.o.mouse = 'a'

-- 同步操作系统剪贴板和 Neovim 剪贴板
vim.schedule(function() vim.o.clipboard = 'unnamedplus' end)

-- 启用断行缩进
vim.o.breakindent = true

-- 即使在关闭并重新打开文件后也能撤销/重做更改
vim.o.undofile = true

-- 搜索时忽略大小写，除非使用 \C 或搜索词中包含大写字母
vim.o.ignorecase = true
vim.o.smartcase = true

-- 默认显示符号列
vim.o.signcolumn = 'yes'

-- 减少更新时间
vim.o.updatetime = 250

-- 配置新分割窗口的打开方式
vim.o.splitright = true
vim.o.splitbelow = true

-- 设置 neovim 如何显示编辑器中的某些空白字符
vim.o.list = true
vim.opt.listchars = { tab = '» ', trail = '·', nbsp = '␣' }

-- 输入时实时预览替换效果
vim.o.inccommand = 'split'

-- 显示光标所在行
vim.o.cursorline = true

-- 光标上下方保持的最少屏幕行数
vim.o.scrolloff = 10

-- 如果执行的操作因缓冲区有未保存更改而失败（如 `:q`）
-- 则弹出对话框询问是否要保存当前文件
vim.o.confirm = true

-- 在普通模式下按 <Esc> 清除搜索高亮
vim.keymap.set('n', '<Esc>', '<cmd>nohlsearch<CR>')

-- 诊断配置和快捷键
vim.diagnostic.config {
    update_in_insert = false,
    severity_sort = true,
    float = { border = 'rounded', source = 'if_many' },
    underline = { severity = { min = vim.diagnostic.severity.WARN } },

    -- 可以根据喜好切换
    virtual_text = true,   -- 文本显示在行尾
    virtual_lines = false, -- 文本显示在行下方，使用虚拟行

    -- 自动打开浮动窗口，以便在使用 `[d` 和 `]d` 跳转时轻松阅读错误信息
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

vim.keymap.set('n', '<leader>q', vim.diagnostic.setloclist, { desc = '打开诊断快速修复列表' })

-- 打开左侧文件树 (netrw)
vim.keymap.set('n', '<leader>e', vim.cmd.Lexplore, { desc = '打开左侧文件树' })

-- 使用更容易的快捷键退出内置的终端模式
-- 否则，需要按 <C-\><C-n>
-- 没有一定经验的人不会猜到
-- 注意：这不会在所有终端模拟器/tmux 等中生效
vim.keymap.set('t', '<Esc><Esc>', '<C-\\><C-n>', { desc = '退出终端模式' })

-- 使窗口导航更便捷的快捷键
vim.keymap.set('n', '<C-h>', '<C-w><C-h>', { desc = '向左移动焦点' })
vim.keymap.set('n', '<C-l>', '<C-w><C-l>', { desc = '向右移动焦点' })
vim.keymap.set('n', '<C-j>', '<C-w><C-j>', { desc = '向下移动焦点' })
vim.keymap.set('n', '<C-k>', '<C-w><C-k>', { desc = '向上移动焦点' })

-- 复制文本时高亮
vim.api.nvim_create_autocmd('TextYankPost', {
    desc = '复制文本时高亮',
    group = vim.api.nvim_create_augroup('kickstart-highlight-yank', { clear = true }),
    callback = function() vim.hl.on_yank() end,
})
