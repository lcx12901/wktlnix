-- AstroCore provides a central place to modify mappings, vim options, autocommands, and more!
-- Configuration documentation can be found with `:h astrocore`
-- NOTE: We highly recommend setting up the Lua Language Server (`:LspInstall lua_ls`)
--       as this provides autocomplete and documentation while editing

---@type LazySpec
return {
  "AstroNvim/astrocore",
  ---@type AstroCoreOpts
  opts = {
    -- Configure core features of AstroNvim
    features = {
      large_buf = { size = 1024 * 500, lines = 10000 }, -- set global limits for large files for disabling features like treesitter
      autopairs = true, -- enable autopairs at start
      cmp = true, -- enable completion at start
      diagnostics_mode = 3, -- diagnostic mode on start (0 = off, 1 = no signs/virtual text, 2 = no virtual text, 3 = on)
      highlighturl = true, -- highlight URLs at start
      notifications = true, -- enable notifications at start
    },
    -- Diagnostics configuration (for vim.diagnostics.config({...})) when diagnostics are on
    diagnostics = {
      virtual_text = true,
      underline = true,
    },
    -- vim options can be configured here
    options = {
      opt = { -- vim.opt.<key>
        relativenumber = true, -- Show relative numberline
        signcolumn = "auto", -- Show sign column when used only
        spell = false, -- Spell checking
        swapfile = false, -- Swapfile
        smartindent = false, -- fix https://github.com/ryan4yin/nix-config/issues/4
        title = true, -- Set the title of window to `filename [+=-] (path) - NVIM`
        -- The percentage of 'columns' to use for the title
        -- When the title is longer, only the end of the path name is shown.
        titlelen = 20,

        clipboard = "unnamedplus", -- Use system clipboard
        updatetime = 200, -- Update time for cursor blinking
      },
    },
    mappings = {
      n = {
        -- undo history
        ["<Leader>uh"] = { "<cmd>Telescope undo<cr>", desc = "Telescope undo" },

        -- implementation/definition preview
        ["gpd"] = {
          "<cmd>lua require('goto-preview').goto_preview_definition()<CR>",
          desc = "goto_preview_definition",
        },
        ["gpt"] = {
          "<cmd>lua require('goto-preview').goto_preview_type_definition()<CR>",
          desc = "goto_preview_type_definition",
        },
        ["gpi"] = {
          "<cmd>lua require('goto-preview').goto_preview_implementation()<CR>",
          desc = "goto_preview_implementation",
        },
        ["gP"] = { "<cmd>lua require('goto-preview').close_all_win()<CR>", desc = "close_all_win" },
        ["gpr"] = {
          "<cmd>lua require('goto-preview').goto_preview_references()<CR>",
          desc = "goto_preview_references",
        },

        -- search and replace globally
        ["<Leader>ss"] = { '<cmd>lua require("spectre").toggle()<CR>', desc = "Toggle Spectre" },
        ["<Leader>sw"] = {
          '<cmd>lua require("spectre").open_visual({select_word=true})<CR>',
          desc = "Search current word",
        },
        ["<Leader>sp"] = {
          '<cmd>lua require("spectre").open_file_search({select_word=true})<CR>',
          desc = "Search on current file",
        },
      },
    },
  },
}
