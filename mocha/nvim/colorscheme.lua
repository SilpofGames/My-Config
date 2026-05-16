use { "catppuccin/nvim",
  as = "catppuccin",
  config = function()
    require("catppuccin").setup({
      flavour = "mocha",
      transparent_background = true,
      integrations = {
        telescope = true,
        neotree = true,
        treesitter = true,
        bufferline = true,
        which_key = true,
        indent_blankline = { enabled = true },
      },
    })
    vim.cmd("colorscheme catppuccin-mocha")
  end,
}