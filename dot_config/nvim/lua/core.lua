vim.scriptencoding = "utf-8"

-- 新しい行のインデントを現在と同じにする
vim.opt.autoindent = true
-- ファイルを上書きする前にバックアップを作る
vim.opt.backup = false
-- 挿入モードでの <BS>, <Del>, CTRL-W, CTRL-U の働き
vim.opt.backspace = "eol,indent,start"
-- コピー、削除、変更、ペーストなどの操作
vim.opt.clipboard = "unnamedplus"
-- コマンドラインに使われる画面上の行数
vim.opt.cmdheight = 2
--  Vim内部で使われる文字エンコーディング
vim.opt.encoding = "utf-8"
-- カーソルがあるテキスト行を強調表示する
vim.opt.cursorline = true
-- 挿入モードで <Tab> を挿入するとき、代わりに適切な数の空白を使う
vim.opt.expandtab = true
-- ファイル書き出しの文字エンコーディング
vim.opt.fileencoding = "utf-8"
-- カレントバッファの <EOL>
vim.opt.fileformats = "unix,dos,mac"
-- 検索結果のハイライト
vim.opt.hlsearch = true
-- 検索結果において大文字と小文字を区別しない
vim.opt.ignorecase = true
-- 非表示文字を表示
vim.opt.list = true
-- 非表示文字の表示形式
vim.opt.listchars = { tab = "»-", trail = "-", eol = "↲", extends = "»", precedes = "«", nbsp = "%" }
-- showmatch が ON の時、対応する括弧を表示する時間[秒]
vim.opt.matchtime = 1
-- マウスの使用可否
vim.opt.mouse = "a"
-- 行番号を表示
vim.opt.number = true
-- 行番号を表示するのに使われる桁数の最小値
vim.opt.numberwidth = 5
-- カーソル行からの相対行番号を表示
vim.opt.relativenumber = true
-- コマンドを画面の一番下に表示
vim.opt.showcmd = true
-- 閉じ括弧が入力されたとき、対応する開き括弧にわずかの間ジャンプ
vim.opt.showmatch = true
-- タブバーの表示
vim.opt.showtabline = 2
-- インデントに使われる空白数
vim.opt.shiftwidth = 4
-- 目印行を表示
vim.opt.signcolumn = "yes"
-- 検索パターンに大文字を含んでいたら ignorecase を無効にする
vim.opt.smartcase = true
-- 改行時に、ブロックに応じて自動でインデント数を調整して挿入
vim.opt.smartindent = true
-- ファイル内の <Tab> が対応する空白の数
vim.opt.tabstop = 4
-- 24 ビットカラー
vim.opt.termguicolors = true
vim.opt.winblend = 0
vim.opt.pumblend = 0
--
vim.opt.title = true
-- ビープ音に画面フラッシュ
vim.opt.visualbell = true
-- 折り返し表示
vim.opt.wrap = true
-- 検索がファイル末尾まで進んだら、ファイル先頭から再び検索
vim.opt.wrapscan = true
