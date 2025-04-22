-- install
--   1. bash command
-- 	    curl -LO https://github.com/neovim/neovim/releases/latest/download/nvim-linux-x86_64.tar.gz
--	    sudo rm -rf /opt/nvim
--	    sudo tar -C /opt -xzf nvim-linux-x86_64.tar.gz
--   2. config $PATH in ~/.bashrc
--   	export PATH="$PATH:/opt/nvim-linux-x86_64/bin"

vim.opt.number = true
vim.opt.relativenumber = true
vim.opt.tabstop = 4
vim.opt.shiftwidth = 4
vim.opt.expandtab = true
vim.opt.smartindent = true
vim.opt.wrap = false
vim.opt.mouse = "a"
vim.opt.showmode = false
vim.o.termguicolors = true

vim.g.mapleader = " "
vim.g.maplocalleader = " "
vim.keymap.set("n", "<leader>w", ":w<CR>")
vim.keymap.set("n", "<leader>f", vim.lsp.buf.format)

local lazypath = vim.fn.stdpath("data") .. "/lazy/lazy.nvim"
if not (vim.uv or vim.loop).fs_stat(lazypath) then
	local lazyrepo = "https://github.com/folke/lazy.nvim.git"
	local out = vim.fn.system({ "git", "clone", "--filter=blob:none", "--branch=stable", lazyrepo, lazypath })
	if vim.v.shell_error ~= 0 then
		error("Error cloning lazy.nvim:\n" .. out)
	end
end ---@diagnostic disable-next-line: undefined-field
vim.opt.rtp:prepend(lazypath)

require("lazy").setup({
	{ "folke/lazy.nvim", version = "*" },
	{ "folke/tokyonight.nvim" }, -- 颜色主题

	-- 代码格式化，需安装特定的格式化工具
	{
		"nvimtools/none-ls.nvim",
		dependencies = {
			"nvim-lua/plenary.nvim",
		},
		config = function()
			local null_ls = require("null-ls")

			-- 配置格式化源
			null_ls.setup({
				sources = {
					-- 根据你的需求选择格式化工具
					null_ls.builtins.formatting.stylua, -- lua
					null_ls.builtins.formatting.prettier, -- JavaScript, JSON, CSS, HTML等
					null_ls.builtins.formatting.black, -- Python
					null_ls.builtins.formatting.gofmt, -- Go
					-- null_ls.builtins.diagnostics.shellcheck,
					null_ls.builtins.formatting.shfmt,
					-- 添加更多格式化工具...
				},
			})

			-- 可选：设置保存时自动格式化
			vim.cmd([[
                augroup formatting
                autocmd!
                autocmd BufWritePre * lua vim.lsp.buf.format()
                augroup END
            ]])

			-- 设置快捷键
			vim.keymap.set("n", "<leader>f", vim.lsp.buf.format, { desc = "Format document" })
		end,
	},
})
vim.cmd.colorscheme("tokyonight-night")
