use { "AlexvZyl/nordic.nvim",
  config = function()
    require("nordic").setup({
      transparent = {
        bg = true,
      },
    })
    vim.cmd("colorscheme nordic")
  end,
}
