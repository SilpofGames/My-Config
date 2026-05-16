vim.opt.runtimepath:prepend("/home/silpof/.local/share/nvim/silzy/manager")

require("config.options")
require("config.keymaps")

if vim.fn.filereadable(vim.fn.stdpath("config") .. "/lua/config/keybinds.lua") == 1 then
  require("config.keybinds")
end

local silzy = require("silzy")
silzy.setup({ auto_install = true, fetch = false })

require("core")

silzy.load_plugins()
