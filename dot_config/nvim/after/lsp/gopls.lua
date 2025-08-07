return {
	on_attach = function(client, _)
		-- goimport でフォーマットをかけるため、gopls のフォーマッタは無効化
		client.server_capabilities.documentFormattingProvider = false
		client.server_capabilities.documentRangeFormattingProvider = false
	end,
	settings = {
		gopls = {
			staticcheck = true,
			usePlaceholders = true,
		},
	},
}
