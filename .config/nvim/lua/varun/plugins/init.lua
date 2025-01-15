return {
	{
		"nvim-telescope/telescope-file-browser.nvim",
		dependencies = { "nvim-telescope/telescope.nvim", "nvim-lua/plenary.nvim" },
	},
	{
		"goolord/alpha-nvim",
		dependencies = { "nvim-tree/nvim-web-devicons" },
		config = function()
			require("alpha").setup(require("alpha.themes.startify").config)
		end,
	},
	"nvim-lua/plenary.nvim",
	"jvgrootveld/telescope-zoxide",
	"postfen/clipboard-image.nvim",
	"mbbill/undotree",
	"wakatime/vim-wakatime",
	"Pocco81/auto-save.nvim",
	"Pocco81/true-zen.nvim",
	"lambdalisue/suda.vim",
	"github/copilot.vim",
	"numToStr/Comment.nvim",
	"nacro90/numb.nvim",
	"karb94/neoscroll.nvim",
	"edluffy/hologram.nvim",
}
