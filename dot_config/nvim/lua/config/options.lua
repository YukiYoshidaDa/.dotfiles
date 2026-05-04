-- Options are automatically loaded before lazy.nvim startup
-- Default options that are always set: https://github.com/LazyVim/LazyVim/blob/main/lua/lazyvim/config/options.lua
-- Add any additional options here

vim.g.mapleader = " " -- スペースキーをリーダーキーに設定
vim.g.maplocalleader = "\\"

local opt = vim.opt

opt.relativenumber = true -- 相対行番号を表示（Vim操作が楽になります）
opt.number = true -- 現在の行番号を表示
opt.tabstop = 2 -- タブ幅
opt.shiftwidth = 2
opt.expandtab = true -- タブをスペースに変換
opt.smartindent = true
opt.ignorecase = true -- 検索時に大文字小文字を無視
opt.smartcase = true
opt.termguicolors = true -- 24bitカラーを有効化
opt.cursorline = true -- 現在の行をハイライト
opt.mouse = "a" -- マウス操作を有効化
