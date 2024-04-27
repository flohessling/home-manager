return {
	{
		"nvim-treesitter/nvim-treesitter",
		opts = function(_, opts)
			vim.list_extend(opts.ensure_installed, {
				"bash",
			})
		end,
	},
	{
		"williamboman/mason.nvim",
		opts = function(_, opts)
			vim.list_extend(opts.ensure_installed, {
				"shellcheck",
				"shfmt",
			})
		end,
	},
	{
		"neovim/nvim-lspconfig",
		opts = {
			servers = {
				bashls = {
					settings = {
						bashIde = {
							-- disable shellcheck because it conflicts with linter
							shellcheckPath = "",
						},
					},
				},
			},
		},
	},
	{
		"stevearc/conform.nvim",
		opts = function(_, opts)
			opts.formatters_by_ft = vim.tbl_deep_extend("force", opts.formatters_by_ft, {
				sh = { "shfmt" },
			})
		end,
	},
	{
		"mfussenegger/nvim-lint",
		opts = function(_, opts)
			opts.linters_by_ft = vim.tbl_deep_extend("force", opts.linters_by_ft, {
				sh = { "shellcheck" },
			})
		end,
	},
}
