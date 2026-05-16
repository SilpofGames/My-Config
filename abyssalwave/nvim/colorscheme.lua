use { "folke/tokyonight.nvim",
  config = function()
    require("tokyonight").setup({
      style = "night",
      transparent = true,
    })
    vim.cmd("colorscheme nordic")
  end,
}
