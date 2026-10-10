-- 他人のリポジトリでは LSP・保存時フォーマット・lint を自動で動かさない
-- （リポジトリ内の設定ファイルや node_modules などを読み込んで実行しうるため）
local M = {}

local function resolve(path)
	local abs = vim.fs.normalize(vim.fn.fnamemodify(vim.fs.normalize(path), ":p"))
	return vim.uv.fs_realpath(abs) or abs
end

-- path が信頼しないルート（vim.g.untrusted_roots、既定は ~/repos/ref）の外にあれば true
-- path を省略するか空文字にするとカレントディレクトリで判定する
function M.trusted(path)
	if path == nil or path == "" then
		path = vim.uv.cwd()
	end
	path = resolve(path)
	for _, root in ipairs(vim.g.untrusted_roots or { "~/repos/ref" }) do
		root = resolve(root)
		if path == root or vim.startswith(path, root .. "/") then
			return false
		end
	end
	return true
end

return M
