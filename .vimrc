"===================="
"      .vimrc        "
"===================="


" Fundamental Settings

" 文字コード
set fenc=utf-8
" バックアップファイルを作らない
set nobackup
" スワップファイルを作らない
set noswapfile
" 編集中のファイルが変更されたら自動でリロードする
set autoread
" バッファが編集中でもその他のファイルを開けるように
set hidden
" 入力中のコマンドをステータスに表示
set showcmd


" Visual

" 行番号を表示
set number
" 現在の行を強調表示
"  set cursorline
" 行末の1字先までカーソルを移動できるように
set virtualedit=onemore
" ステータスラインを常に表示
set laststatus=2
" スマートインデント
set smartindent
" シンタックスハイライト
syntax enable


" Complementation

" 括弧
set showmatch
" コマンドライン
set wildmode=list:longest


" Search

" 小文字 -> 大文字小文字区別なく
set ignorecase
" 大文字 -> 大文字のみ
set smartcase
" インクリメンタルサーチ
set incsearch
" 最後まで行ったら最初に戻る
set wrapscan
" 検索語をハイライト表示
set hlsearch


" Tab Operation

:set tabstop=4
:set shiftwidth=0
:set expandtab


