use { "goolord/alpha-nvim",
  requires = { "nvim-tree/nvim-web-devicons" },
}

use {
  "SilpofGames/Workmark.nvim",
  config = function()
      require("workmark").setup()
  end,
}

use {
  "goolord/alpha-nvim",
  event = "VimEnter",
  config = function()
    local alpha = require("alpha")
    local dashboard = require("alpha.themes.dashboard")

    -- Este plugin cria uma tela inicial personalizada no Neovim,
    -- onde podes configurar uma interface de boas-vindas com
    -- um header e botões de atalho para as ações mais comuns.

    -- Definir o header (a imagem que aparece na tela inicial)
    dashboard.section.header.val = {
      [[                                                                       ]],
      [[                                                                       ]],
      [[                                                                       ]],
      [[                                                                       ]],
      [[                                                                     ]],
      [[       ████ ██████           █████      ██                     ]],
      [[      ███████████             █████                             ]],
      [[      █████████ ███████████████████ ███   ███████████   ]],
      [[     █████████  ███    █████████████ █████ ██████████████   ]],
      [[    █████████ ██████████ █████████ █████ █████ ████ █████   ]],
      [[  ███████████ ███    ███ █████████ █████ █████ ████ █████  ]],
      [[ ██████  █████████████████████ ████ █████ █████ ████ ██████ ]],
      [[                                                                       ]],
      [[                                                                       ]],
      [[                                                                       ]],
    }

    -- Definir os botões no menu (ações rápidas)
    dashboard.section.buttons.val = {
      dashboard.button("n", "[λ]  New File", "<cmd>ene<CR>"),
      dashboard.button("f", "[ρ]  Find Files", "<cmd>Telescope find_files<CR>"),
      dashboard.button("r", "[φ]  Recent Files", "<cmd>Telescope oldfiles<CR>"),
      dashboard.button("c", "[μ]  Config", "<cmd>lua require('telescope.builtin').find_files({ cwd = vim.fn.stdpath('config') })<CR>"),
      dashboard.button("q", "[ψ]  Quit", "<cmd>qa<CR>"),
    }

    -- Enviar as configurações para o alpha
    alpha.setup(dashboard.opts)

    -- Desabilitar o folding no buffer do alpha
    vim.cmd([[autocmd FileType alpha setlocal nofoldenable]])
  end,
}

use { "folke/snacks.nvim",
  config = function()
    local function get_fetch_cmd()
      local cmds = { "fastfetch", "neofetch", "screenfetch" }
      for _, c in ipairs(cmds) do
        if vim.fn.executable(c) == 1 then
          if c == "fastfetch" then return "fastfetch --pipe" end
          if c == "neofetch" then return "neofetch --off" end
          return c
        end
      end
      return nil
    end

    local fetch_cmd = get_fetch_cmd()
    local silzy_config = require("silzy").config or {}
    local show_fetch = silzy_config.fetch ~= false -- default to true if not specified

    local dashboard_sections = {
      { section = "header" },
      { section = "keys", gap = 1, padding = 1 },
      { 
        text = { { " silzy.nvim v0.1.0 ", hl = "Special" } },
        padding = 1,
        indent = 8,
      },
    }

    if fetch_cmd and show_fetch then
      table.insert(dashboard_sections, {
        section = "terminal",
        cmd = fetch_cmd,
        hl = "header",
        padding = 1,
        indent = 8,
      })
    end

    require("snacks").setup({
      indent       = { enabled = true },
      notifier     = { enabled = true, timeout = 3000, style = "compact" },
      scroll       = { enabled = true },
      input        = { enabled = true },
      statuscolumn = { enabled = true },
      words        = { enabled = true },
      terminal     = { enabled = true },
      gitbrowse    = { enabled = true },
      scope        = { enabled = true },
      zen          = { enabled = true },
      dim          = { enabled = true },
      bigfile      = { enabled = true },
      quickfile    = { enabled = true },
      picker       = { enabled = false },
      rename       = { enabled = true },
      dashboard    = {
        sections = dashboard_sections,
      },
    })
    local map = function(lhs, fn, desc, mode)
      vim.keymap.set(mode or "n", lhs, fn, { desc = desc, silent = true })
    end
    map("<leader>un", function() Snacks.notifier.hide()         end, "Dismiss Notifications")
    map("<leader>nh", function() Snacks.notifier.show_history() end, "Notification History")
    map("<leader>gb", function() Snacks.gitbrowse()             end, "Git Browse")
    map("<leader>gl", function() Snacks.lazygit()               end, "Lazygit")
    map("<leader>z",  function() Snacks.zen()                   end, "Toggle Zen Mode")
    map("<leader>dd", function() Snacks.dim()                   end, "Toggle Dim Mode")
    map("<leader>rn", function() Snacks.rename.rename_file()    end, "Rename File")
    map("<C-t>",      function() Snacks.terminal.toggle()       end, "Toggle Terminal", { "n", "t" })
    map("]]",         function() Snacks.words.jump(1)           end, "Next Reference")
    map("[[",         function() Snacks.words.jump(-1)          end, "Prev Reference")
  end,
}


use { "hrsh7th/nvim-cmp",
  requires = {
    "hrsh7th/cmp-nvim-lsp",
    "hrsh7th/cmp-buffer",
    "hrsh7th/cmp-path",
    "hrsh7th/cmp-cmdline",
    "L3MON4D3/LuaSnip",
    "saadparwaiz1/cmp_luasnip",
  },
  config = function()
    local cmp = require("cmp")
    cmp.setup({
      snippet = { expand = function(args) require("luasnip").lsp_expand(args.body) end },
      mapping = cmp.mapping.preset.insert({
        ["<C-b>"] = cmp.mapping.scroll_docs(-4),
        ["<C-f>"] = cmp.mapping.scroll_docs(4),
        ["<C-Space>"] = cmp.mapping.complete(),
        ["<C-e>"] = cmp.mapping.abort(),
        ["<CR>"] = cmp.mapping.confirm({ select = true }),
        ["<Tab>"] = cmp.mapping(function(fallback)
          if cmp.visible() then cmp.select_next_item()
          elseif require("luasnip").expand_or_jumpable() then require("luasnip").expand_or_jump()
          else fallback() end
        end, { "i", "s" }),
      }),
      sources = cmp.config.sources({
        { name = "nvim_lsp" },
        { name = "luasnip" },
      }, {
        { name = "buffer" },
        { name = "path" },
      })
    })

    -- Cmdline completion
    cmp.setup.cmdline(":", {
      mapping = cmp.mapping.preset.cmdline(),
      sources = cmp.config.sources({
        { name = "path" }
      }, {
        { name = "cmdline" }
      })
    })
  end
}



use { "nvim-lua/plenary.nvim" }
use { "nvim-tree/nvim-web-devicons" }

use { "nvim-telescope/telescope.nvim",
  requires = { "nvim-lua/plenary.nvim", "nvim-tree/nvim-web-devicons" },
  config = function()
    local actions = require("telescope.actions")
    require("telescope").setup({
      defaults = {
        prompt_prefix    = "   ",
        selection_caret  = "  ",
        path_display     = { "truncate" },
        sorting_strategy = "ascending",
        layout_config    = {
          horizontal = { prompt_position = "top", preview_width = 0.55 },
          width = 0.87, height = 0.80,
        },
        mappings = {
          i = {
            ["<C-n>"] = actions.cycle_history_next,
            ["<C-p>"] = actions.cycle_history_prev,
            ["<C-j>"] = actions.move_selection_next,
            ["<C-k>"] = actions.move_selection_previous,
            ["<Esc>"] = actions.close,
          },
        },
      },
      pickers = {
        find_files = {
          hidden       = true,
          no_ignore    = false,
          find_command = vim.fn.executable("fd") == 1
            and { "fd", "--type", "f", "--hidden", "--exclude", ".git", "--strip-cwd-prefix" }
            or  { "find", ".", "-type", "f", "-not", "-path", "*/.git/*" },
        },
        live_grep = { additional_args = { "--hidden", "--glob", "!.git" } },
        oldfiles  = { include_current_session = true },
      },
    })
  end,
}

use { "akinsho/bufferline.nvim",
  requires = { "nvim-tree/nvim-web-devicons" },
  config = function()
    require("bufferline").setup({
      options = {
        mode              = "buffers",
        separator_style   = "slant",
        always_show_bufferline = true,
        show_buffer_close_icons = true,
        show_close_icon   = false,
        color_icons       = true,
        diagnostics       = "nvim_lsp",
        offsets = {
          {
            filetype   = "neo-tree",
            text       = "  Files",
            highlight  = "Directory",
            separator  = true,
          },
        },
      },
    })
  end,
}

use { "stevearc/aerial.nvim",
  requires = { "nvim-treesitter/nvim-treesitter", "nvim-tree/nvim-web-devicons" },
  config = function()
    require("aerial").setup({
      on_attach = function(bufnr)
        vim.keymap.set("n", "{", "<cmd>AerialPrev<CR>", { buffer = bufnr, desc = "Prev symbol" })
        vim.keymap.set("n", "}", "<cmd>AerialNext<CR>", { buffer = bufnr, desc = "Next symbol" })
      end,
      layout = {
        max_width     = { 40, 0.2 },
        min_width     = 30,
        default_direction = "right",
        placement     = "edge",
      },
      attach_mode   = "global",
      backends      = { "treesitter", "lsp" },
      show_guides   = true,
      guides = {
        mid_item   = "├─ ",
        last_item  = "└─ ",
        nested_top = "│  ",
        whitespace = "   ",
      },
      filter_kind = {
        "Class", "Constructor", "Enum", "Function",
        "Interface", "Module", "Method", "Struct",
      },
    })
    vim.keymap.set("n", "<leader>a", "<cmd>AerialToggle<CR>", { desc = "Toggle Symbols" })
  end,
}

use { "nvim-lualine/lualine.nvim",
  requires = { "nvim-tree/nvim-web-devicons" },
  config = function()
    local function lsp_name()
      local clients = vim.lsp.get_clients({ bufnr = 0 })
      if #clients == 0 then return "" end
      return " " .. clients[1].name
    end

    local colors = {
      blue   = "#89b4fa",
      cyan   = "#89dceb",
      black  = "#181825",
      white  = "#cdd6f4",
      red    = "#f38ba8",
      violet = "#cba6f7",
      grey   = "#313244",
      dark   = "#1e1e2e",
    }

    require("lualine").setup({
      options = {
        theme            = "catppuccin",
        globalstatus     = true,
        component_separators = { left = ">", right = "<" },
        section_separators  = { left = "", right = "" },
        disabled_filetypes  = { statusline = { "dashboard", "silzy-dashboard", "alpha" } },
      },
      sections = {
        lualine_a = {
          { "mode", padding = { left = 1, right = 1 } },
        },
        lualine_b = {
          { "filename", 
            color = { bg = colors.grey, fg = colors.white },
          },
          { "branch", icon = " ", 
            color = { bg = colors.dark, fg = colors.white },
          },
        },
        lualine_c = { "%=" },
        lualine_x = {
          { "diagnostics", color = { bg = colors.dark } },
          { lsp_name, icon = " ", 
            color = { bg = colors.grey, fg = colors.blue },
          },
        },
        lualine_y = {
          { "filetype", color = { bg = colors.dark, fg = colors.white } },
        },
        lualine_z = {
          { "location", color = { bg = colors.blue, fg = colors.black } },
          { function() return "|" end, padding = { left = 0, right = 0 } },
        },
      },
      inactive_sections = {
        lualine_a = { "filename" },
        lualine_b = {},
        lualine_c = {},
        lualine_x = {},
        lualine_y = {},
        lualine_z = { "location" },
      },
    })
  end,
}

use { "lukas-reineke/indent-blankline.nvim",
  config = function()
    require("ibl").setup({
      indent = { char = "│" },
      scope  = { enabled = true },
    })
  end,
}
