return {
	on_attach = function(client, _)
		-- Built-in LSP のフォーマッタで Organize Imports できるなら、その方法を優先したい
		client.server_capabilities.documentFormattingProvider = false
		client.server_capabilities.documentRangeFormattingProvider = false
	end,
}
