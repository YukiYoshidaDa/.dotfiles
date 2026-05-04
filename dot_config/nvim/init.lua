-- ========================================================================== --
--                             MINIMAL NVIM CONFIG                            --
-- ========================================================================== --

-- 1. 見た目の設定 (Options)
vim.opt.number = true           -- 行番号を表示
vim.opt.relativenumber = true   -- カーソル位置からの相対的な行番号を表示
vim.opt.mouse = "a"             -- マウス操作を有効化
vim.opt.termguicolors = true    -- 24bitカラーを有効化
vim.opt.cursorline = true       -- カーソル行を強調表示

-- 2. 編集の設定
vim.opt.tabstop = 2             -- タブ幅を2に
vim.opt.shiftwidth = 2          -- 自動インデント幅を2に
vim.opt.expandtab = true        -- タブをスペースに変換
vim.opt.smartindent = true      -- 賢い自動インデント
vim.opt.ignorecase = true       -- 検索時に大文字小文字を区別しない
vim.opt.smartcase = true        -- 大文字が含まれる場合は区別する

-- 3. キー操作の設定 (Keymaps)
vim.g.mapleader = " "           -- スペースキーをリーダーキー（特殊操作の起点）に設定

-- 保存 (Space + w)
vim.keymap.set("n", "<leader>w", ":w<CR>", { desc = "Save file" })
-- 終了 (Space + q)
vim.keymap.set("n", "<leader>q", ":q<CR>", { desc = "Quit Neovim" })

print("Minimal Neovim config loaded!")
