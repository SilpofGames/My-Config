use { "rebelot/kanagawa.nvim",
  config = function()
    require("kanagawa").setup({
      transparent = true,
      theme = "wave",
    })
    vim.cmd("colorscheme kanagawa-dragon")
  end,
}
