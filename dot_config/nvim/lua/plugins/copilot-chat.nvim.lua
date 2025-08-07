-- [lazy-nvim-ide/lua/plugins/extras/copilot-chat-v2.lua at main · jellydn/lazy-nvim-ide](https://github.com/jellydn/lazy-nvim-ide/blob/main/lua/plugins/extras/copilot-chat-v2.lua)

local system_prompt =
	"私はプログラミングの専門家で、名前は「ずんだもん」です。一人称は「ぼく」で、できる限り「〜のだ。」「〜なのだ。」を文末に自然な形で使ってください。 疑問文は「〜のだ？」という形で使ってください。参考として口調の例を以下に示すのだ。\n> ぼくはずんだもん！ ずんだの精霊なのだ！ ぼくはずんだもちの妖精なのだ！ ぼくはずんだもん、小さくてかわいい妖精なのだ なるほど、大変そうなのだ"

local prompts = {
	-- Code related prompts
	Explain = "コードの動作を説明してください。",
	Review = "以下のコードをレビューし、改善点を提案してください。",
	Tests = "以下のコードに対するユニットテストを生成してください。",
	Refactor = "以下のコードをリファクタリングして、可読性と保守性を向上させてください。",
	FixCode = "以下のコードを修正して、意図した通りに動作するようにしてください。",
	FixError = "以下のコードのエラーを説明し、解決策を提供してください。",
	BetterNamings = "以下の変数や関数の名前をより適切なものに変更してください。",
	Documentation = "以下のコードに対するドキュメントを生成してください。",
	-- Text related prompts
	Summarize = "以下のテキストを要約してください。",
	Spelling = "以下のテキストの文法とスペルを修正してください。",
	Wording = "以下のテキストの文法と表現を改善してください。",
	Concise = "以下のテキストをより簡潔に書き直してください。",
}

return {
	{
		"CopilotC-Nvim/CopilotChat.nvim",
		branch = "main",
		-- version = "v3.3.0", -- Use a specific version to prevent breaking changes
		opts = {
			system_prompt = system_prompt,
			question_header = "## User ",
			answer_header = "## Copilot ",
			error_header = "## Error ",
			prompts = prompts,
			model = "claude-sonnet-4",
			mappings = {
				-- Use tab for completion
				complete = {
					detail = "Use @<Tab> or /<Tab> for options.",
					insert = "<Tab>",
				},
				-- Close the chat
				close = {
					normal = "q",
					insert = "<C-q>",
				},
				-- Reset the chat buffer
				reset = {
					normal = "<C-x>",
					insert = "<C-x>",
				},
				-- Submit the prompt to Copilot
				submit_prompt = {
					normal = "<CR>",
					insert = "<C-CR>",
				},
				-- Accept the diff
				accept_diff = {
					normal = "<C-y>",
					insert = "<C-y>",
				},
				-- Show help
				show_help = {
					normal = "g?",
				},
			},
		},
		config = function(_, opts)
			local chat = require("CopilotChat")
			chat.setup(opts)

			local select = require("CopilotChat.select")
			vim.api.nvim_create_user_command("CopilotChatVisual", function(args)
				chat.ask(args.args, { selection = select.visual })
			end, { nargs = "*", range = true })

			-- Inline chat with Copilot
			vim.api.nvim_create_user_command("CopilotChatInline", function(args)
				chat.ask(args.args, {
					selection = select.visual,
					window = {
						layout = "float",
						relative = "cursor",
						width = 1,
						height = 0.4,
						row = 1,
					},
				})
			end, { nargs = "*", range = true })

			-- Restore CopilotChatBuffer
			vim.api.nvim_create_user_command("CopilotChatBuffer", function(args)
				chat.ask(args.args, { selection = select.buffer })
			end, { nargs = "*", range = true })

			-- Custom buffer for CopilotChat
			vim.api.nvim_create_autocmd("BufEnter", {
				pattern = "copilot-*",
				callback = function()
					vim.opt_local.relativenumber = true
					vim.opt_local.number = true

					-- Get current filetype and set it to markdown if the current filetype is copilot-chat
					local ft = vim.bo.filetype
					if ft == "copilot-chat" then
						vim.bo.filetype = "markdown"
					end
				end,
			})
		end,
		event = "VeryLazy",
		keys = {
			-- Show prompts actions with telescope
			{
				"<leader>ap",
				function()
					require("CopilotChat").select_prompt({
						context = {
							"buffers",
						},
					})
				end,
				desc = "CopilotChat - Prompt actions",
			},
			{
				"<leader>ap",
				function()
					require("CopilotChat").select_prompt()
				end,
				mode = "x",
				desc = "CopilotChat - Prompt actions",
			},
			-- Code related commands
			{ "<leader>ae", "<cmd>CopilotChatExplain<cr>", desc = "CopilotChat - Explain code" },
			{ "<leader>at", "<cmd>CopilotChatTests<cr>", desc = "CopilotChat - Generate tests" },
			{ "<leader>ar", "<cmd>CopilotChatReview<cr>", desc = "CopilotChat - Review code" },
			{ "<leader>aR", "<cmd>CopilotChatRefactor<cr>", desc = "CopilotChat - Refactor code" },
			{ "<leader>an", "<cmd>CopilotChatBetterNamings<cr>", desc = "CopilotChat - Better Naming" },
			-- Chat with Copilot in visual mode
			{
				"<leader>av",
				":CopilotChatVisual",
				mode = "x",
				desc = "CopilotChat - Open in vertical split",
			},
			{
				"<leader>ax",
				":CopilotChatInline",
				mode = "x",
				desc = "CopilotChat - Inline chat",
			},
			-- Custom input for CopilotChat
			{
				"<leader>ai",
				function()
					local input = vim.fn.input("Ask Copilot: ")
					if input ~= "" then
						vim.cmd("CopilotChat " .. input)
					end
				end,
				desc = "CopilotChat - Ask input",
			},
			-- Generate commit message based on the git diff
			{
				"<leader>am",
				"<cmd>CopilotChatCommit<cr>",
				desc = "CopilotChat - Generate commit message for all changes",
			},
			-- Quick chat with Copilot
			{
				"<leader>aq",
				function()
					local input = vim.fn.input("Quick Chat: ")
					if input ~= "" then
						vim.cmd("CopilotChatBuffer " .. input)
					end
				end,
				desc = "CopilotChat - Quick chat",
			},
			-- Fix the issue with diagnostic
			{ "<leader>af", "<cmd>CopilotChatFixError<cr>", desc = "CopilotChat - Fix Diagnostic" },
			-- Clear buffer and chat history
			{ "<leader>al", "<cmd>CopilotChatReset<cr>", desc = "CopilotChat - Clear buffer and chat history" },
			-- Toggle Copilot Chat Vsplit
			{ "<leader>av", "<cmd>CopilotChatToggle<cr>", desc = "CopilotChat - Toggle" },
			-- Copilot Chat Models
			{ "<leader>a?", "<cmd>CopilotChatModels<cr>", desc = "CopilotChat - Select Models" },
			-- Copilot Chat Agents
			{ "<leader>aa", "<cmd>CopilotChatAgents<cr>", desc = "CopilotChat - Select Agents" },
		},
	},
}
