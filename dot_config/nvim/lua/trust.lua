-- 他人のリポジトリでは LSP・保存時フォーマット・lint を自動で動かさない
-- （リポジトリ内の設定ファイルや node_modules などを読み込んで実行しうるため）
local M = {}

local function resolve(path)
	local abs = vim.fs.normalize(vim.fn.fnamemodify(vim.fs.normalize(path), ":p"))
	return vim.uv.fs_realpath(abs) or abs
end

-- path がリンクされた worktree の中にあれば、本体のリポジトリの .git の場所を返す（なければ nil）
-- worktree は本体と別の場所に作れる（herdr の既定は ~/.herdr/worktrees）ので、チェックアウトの
-- 場所だけで判定すると、~/repos/ref のリポジトリの worktree が信頼済みに見えてしまう
local function main_repository(path)
	local stat = vim.uv.fs_stat(path)
	local dir = (stat and stat.type == "directory") and path or vim.fs.dirname(path)
	local dotgit = vim.fs.find(".git", { path = dir, upward = true })[1]
	if not dotgit or (vim.uv.fs_stat(dotgit) or {}).type ~= "file" then
		return nil
	end
	-- worktree の .git は "gitdir: <本体>/.git/worktrees/<名前>" と書かれたファイル
	local ok, lines = pcall(vim.fn.readfile, dotgit, "", 1)
	local gitdir = ok and lines[1] and lines[1]:match("^gitdir:%s*(.+)$")
	if not gitdir then
		return nil
	end
	if not vim.startswith(gitdir, "/") then
		gitdir = vim.fs.dirname(dotgit) .. "/" .. gitdir
	end
	return resolve(gitdir):match("^(.*)/worktrees/[^/]+$")
end

-- path が信頼しないルート（vim.g.untrusted_roots、既定は ~/repos/ref）の外にあれば true
-- path を省略するか空文字にするとカレントディレクトリで判定する
-- worktree の中では、チェックアウトの場所と本体のリポジトリの場所の両方が外にあるときだけ true
function M.trusted(path)
	if path == nil or path == "" then
		path = vim.uv.cwd()
	end
	path = resolve(path)
	local places = { path, main_repository(path) }
	for _, root in ipairs(vim.g.untrusted_roots or { "~/repos/ref" }) do
		root = resolve(root)
		for _, place in ipairs(places) do
			if place == root or vim.startswith(place, root .. "/") then
				return false
			end
		end
	end
	return true
end

return M
