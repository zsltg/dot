return {
	{
		"mfussenegger/nvim-dap",
		cmd = { "DapContinue", "DapNew", "DapToggleBreakpoint", "DapLuaServer" },
		dependencies = {
			"mason-org/mason.nvim",
			"igorlfs/nvim-dap-view",
			"leoluz/nvim-dap-go",
			"mfussenegger/nvim-dap-python",
		},
		keys = {
			{
				"<leader>Db",
				function()
					require("dap").toggle_breakpoint()
				end,
				desc = "Toggle breakpoint",
			},
			{
				"<leader>DB",
				function()
					vim.ui.input({ prompt = "Breakpoint condition: " }, function(condition)
						if condition and condition ~= "" then
							require("dap").set_breakpoint(condition)
						end
					end)
				end,
				desc = "Set conditional breakpoint",
			},
			{
				"<leader>Dc",
				function()
					require("dap").continue()
				end,
				desc = "Start or continue debugging",
			},
			{
				"<leader>Dn",
				function()
					require("dap").step_over()
				end,
				desc = "Step over",
			},
			{
				"<leader>Di",
				function()
					require("dap").step_into()
				end,
				desc = "Step into",
			},
			{
				"<leader>Do",
				function()
					require("dap").step_out()
				end,
				desc = "Step out",
			},
			{
				"<leader>Dl",
				function()
					require("dap").run_last()
				end,
				desc = "Run last debug session",
			},
			{
				"<leader>Dq",
				function()
					require("dap").terminate()
				end,
				desc = "Terminate debug session",
			},
			{
				"<leader>Dd",
				function()
					require("dap").disconnect()
				end,
				desc = "Disconnect debugger",
			},
			{
				"<leader>Du",
				function()
					require("dap-view").toggle()
				end,
				desc = "Toggle debug window",
			},
			{
				"<leader>Dh",
				function()
					require("dap-view").hover()
				end,
				desc = "Inspect variable",
			},
			{
				"<leader>Dw",
				function()
					require("dap-view").add_expr()
				end,
				desc = "Watch expression",
			},
			{
				"<leader>Dt",
				function()
					local ft = vim.bo.filetype
					if ft == "go" then
						require("dap-go").debug_test()
					elseif ft == "python" then
						require("dap-python").test_method()
					elseif ft == "java" then
						require("jdtls").test_nearest_method()
					else
						vim.notify(
							"Test discovery supports Go, Python and Java. Use a launch configuration for other languages.",
							vim.log.levels.INFO
						)
					end
				end,
				desc = "Debug nearest test",
			},
		},
		config = function()
			local dap = require("dap")
			local mason = vim.fn.stdpath("data") .. "/mason"
			require("dap-view").setup({
				auto_toggle = true,
				winbar = { default_section = "scopes" },
				virtual_text = { enabled = true },
			})
			require("dap-go").setup()
			require("dap-python").setup("debugpy-adapter")

			-- Build native programs with debug symbols before you start the debugger.
			dap.adapters.codelldb = {
				type = "server",
				port = "${port}",
				executable = { command = "codelldb", args = { "--port", "${port}" } },
			}
			for _, ft in ipairs({ "c", "cpp", "rust" }) do
				dap.configurations[ft] = {
					{
						name = "Launch executable",
						type = "codelldb",
						request = "launch",
						program = function()
							local path = vim.fn.input("Executable: ", vim.fn.getcwd() .. "/", "file")
							return path ~= "" and path or dap.ABORT
						end,
						cwd = "${workspaceFolder}",
					},
					{
						name = "Attach to process",
						type = "codelldb",
						request = "attach",
						pid = require("dap.utils").pick_process,
						cwd = "${workspaceFolder}",
					},
				}
			end

			-- The same adapter supports Node, Deno and Chromium browsers.
			for _, adapter in ipairs({ "pwa-node", "pwa-chrome", "node", "chrome" }) do
				dap.adapters[adapter] = {
					type = "server",
					host = "127.0.0.1",
					port = "${port}",
					executable = { command = "js-debug-adapter", args = { "${port}", "127.0.0.1" } },
				}
			end
			for _, ft in ipairs({ "javascript", "javascriptreact", "typescript", "typescriptreact" }) do
				dap.configurations[ft] = {
					{
						name = "Launch file with Node",
						type = "pwa-node",
						request = "launch",
						program = "${file}",
						cwd = "${workspaceFolder}",
						console = "integratedTerminal",
						sourceMaps = true,
					},
					{
						name = "Attach to Node or Deno inspector",
						type = "pwa-node",
						request = "attach",
						address = "127.0.0.1",
						port = 9229,
						cwd = "${workspaceFolder}",
						sourceMaps = true,
					},
					{
						name = "Launch browser",
						type = "pwa-chrome",
						request = "launch",
						url = function()
							local url = vim.fn.input("Application URL: ", "http://localhost:3000")
							return url ~= "" and url or dap.ABORT
						end,
						webRoot = "${workspaceFolder}",
					},
				}
			end

			-- Use the project's debug gem and Ruby runtime through Bundler.
			dap.adapters.ruby = function(callback, config)
				callback({
					type = "server",
					host = "127.0.0.1",
					port = "${port}",
					executable = {
						command = "bundle",
						args = {
							"exec",
							"rdbg",
							"--nonstop",
							"--open",
							"--host",
							"127.0.0.1",
							"--port",
							"${port}",
							"--command",
							"--",
							"bundle",
							"exec",
							config.command,
							config.script,
						},
					},
				})
			end
			dap.configurations.ruby = {
				{
					name = "Launch Ruby file",
					type = "ruby",
					request = "attach",
					localfs = true,
					command = "ruby",
					script = "${file}",
				},
				{
					name = "Debug RSpec file",
					type = "ruby",
					request = "attach",
					localfs = true,
					command = "rspec",
					script = "${file}",
				},
			}

			dap.adapters.kotlin = {
				type = "executable",
				command = "kotlin-debug-adapter",
				options = { auto_continue_if_many_stopped = false },
			}
			dap.configurations.kotlin = {
				{
					name = "Launch Kotlin main class",
					type = "kotlin",
					request = "launch",
					projectRoot = "${workspaceFolder}",
					mainClass = function()
						local class = vim.fn.input("Main class (for example, example.MainKt): ")
						return class ~= "" and class or dap.ABORT
					end,
				},
				{
					name = "Attach to Kotlin JVM",
					type = "kotlin",
					request = "attach",
					projectRoot = "${workspaceFolder}",
					hostName = "127.0.0.1",
					port = 5005,
				},
			}

			dap.adapters.perl = { type = "executable", command = "perl-debug-adapter" }
			dap.configurations.perl = {
				{
					name = "Launch Perl file",
					type = "perl",
					request = "launch",
					program = "${file}",
					cwd = "${workspaceFolder}",
				},
			}
			dap.adapters.bashdb = { type = "executable", command = "bash-debug-adapter" }
			dap.configurations.sh = {
				{
					name = "Launch Bash script",
					type = "bashdb",
					request = "launch",
					program = "${file}",
					cwd = "${workspaceFolder}",
					pathBash = "bash",
					pathBashdb = mason .. "/opt/bashdb/bashdb",
					pathBashdbLib = mason .. "/opt/bashdb",
					pathCat = "cat",
					pathMkfifo = "mkfifo",
					pathPkill = "pkill",
					terminalKind = "integrated",
				},
			}

			dap.adapters.nlua = function(callback, config)
				callback({ type = "server", host = config.host or "127.0.0.1", port = config.port or 8086 })
			end
			dap.configurations.lua = {
				{ name = "Attach to Neovim", type = "nlua", request = "attach" },
			}
			vim.api.nvim_create_user_command("DapLuaServer", function()
				require("osv").launch({ host = "127.0.0.1", port = 8086 })
			end, { desc = "Start a debug server in this Neovim instance" })
		end,
	},
	{ "jbyuki/one-small-step-for-vimkind", lazy = true },
}
