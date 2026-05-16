use { "rebelot/kanagawa.nvim",
  config = function()
    require("kanagawa").setup({
      transparent = true,
      theme = "dragon",
    })
    vim.cmd("colorscheme kanagawa-dragon")
  end,
}
