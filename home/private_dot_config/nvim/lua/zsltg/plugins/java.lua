return {
	"mfussenegger/nvim-jdtls",
	ft = "java",
	dependencies = { "neovim/nvim-lspconfig", "mfussenegger/nvim-dap" },
	config = function()
		vim.lsp.config("jdtls", {
			-- Give each project its own workspace so that concurrent servers cannot share it.
			cmd = function(dispatchers, config)
				local root = config.root_dir or vim.fn.getcwd()
				local workspace = vim.fn.stdpath("cache") .. "/jdtls/" .. vim.fn.sha256(root)
				return vim.lsp.rpc.start({ "jdtls", "-data", workspace }, dispatchers, { cwd = root })
			end,
			before_init = function(_, config)
				local share = vim.fn.stdpath("data") .. "/mason/share/"
				local bundles =
					vim.fn.glob(share .. "java-debug-adapter/com.microsoft.java.debug.plugin.jar", false, true)
				local tests = vim.fn.stdpath("data") .. "/mason/packages/java-test/extension/server/*.jar"
				for _, jar in ipairs(vim.fn.glob(tests, false, true)) do
					local name = vim.fn.fnamemodify(jar, ":t")
					if
						name ~= "com.microsoft.java.test.runner-jar-with-dependencies.jar"
						and name ~= "jacocoagent.jar"
					then
						table.insert(bundles, jar)
					end
				end
				config.init_options.bundles = bundles
			end,
		})
		vim.lsp.enable("jdtls")
	end,
}
