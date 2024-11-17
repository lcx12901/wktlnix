{ pkgs, ... }:
{
  extraPlugins = [ pkgs.vimPlugins.heirline-nvim ];

  extraConfigLua = ''
    local status = require("astroui.status")
    local ui_config = require("astroui").config
    local condition = require "astroui.status.condition"

    require("heirline").setup({
      opts = {
        colors = require("astroui").config.status.setup_colors(),
        disable_winbar_cb = function(args)
          local enabled = vim.tbl_get(ui_config, "status", "winbar", "enabled")
          if enabled and status.condition.buffer_matches(enabled, args.buf) then return false end
          local disabled = vim.tbl_get(ui_config, "status", "winbar", "disabled")
          return not require("astrocore.buffer").is_valid(args.buf)
            or (disabled and status.condition.buffer_matches(disabled, args.buf))
        end,
      },
      statusline = { -- statusline
        hl = { fg = "fg", bg = "bg" },
        status.component.mode(),
        status.component.git_branch(),
        status.component.file_info(),
        status.component.git_diff(),
        status.component.diagnostics(),
        status.component.fill(),
        status.component.cmd_info(),
        status.component.fill(),
        status.component.lsp({
          lsp_client_names = { integrations = { null_ls = true, conform = true, lint = true }, truncate = 0.25 },
        }),
        status.component.virtual_env(),
        status.component.treesitter(),
        status.component.nav(),
        status.component.mode { surround = { separator = "right" } },
      },
      winbar = { -- winbar
        init = function(self) self.bufnr = vim.api.nvim_get_current_buf() end,
        fallthrough = false,
        -- inactive winbar
        {
          condition = function()
            return not status.condition.is_active()
          end,
          -- show the path to the file relative to the working directory
          status.component.separated_path({
            path_func = status.provider.filename({ modify = ":.:h" }),
          }),
          -- add the file name and icon
          status.component.file_info({
            file_icon = {
              hl = status.hl.file_icon("winbar"),
              padding = { left = 0 },
            },
            filename = {},
            filetype = false,
            file_modified = false,
            file_read_only = false,
            hl = status.hl.get_attributes("winbarnc", true),
            surround = false,
            update = "BufEnter",
          }),
        },
        -- active winbar
        {
          -- show the path to the file relative to the working directory
          status.component.separated_path({
            path_func = status.provider.filename({ modify = ":.:h" }),
          }),
          -- add the file name and icon
          status.component.file_info({ -- add file_info to breadcrumbs
            file_icon = { hl = status.hl.filetype_color, padding = { left = 0 } },
            filename = {},
            filetype = false,
            file_modified = false,
            file_read_only = false,
            hl = status.hl.get_attributes("winbar", true),
            surround = false,
            update = "BufEnter",
          }),
          -- show the breadcrumbs
          status.component.breadcrumbs({
            icon = { hl = true },
            hl = status.hl.get_attributes("winbar", true),
            prefix = true,
            padding = { left = 0 },
            condition = condition.aerial_available,
            update = { "CursorMoved", "CursorMovedI", "BufEnter" }
          }),
        },
      },
      tabline = { -- bufferline
        { -- automatic sidebar padding
          condition = function(self)
            self.winid = vim.api.nvim_tabpage_list_wins(0)[1]
            self.winwidth = vim.api.nvim_win_get_width(self.winid)
            return self.winwidth ~= vim.o.columns -- only apply to sidebars
              and not require("astrocore.buffer").is_valid(vim.api.nvim_win_get_buf(self.winid)) -- if buffer is not in tabline
          end,
          provider = function(self) return (" "):rep(self.winwidth + 1) end,
          hl = { bg = "tabline_bg" },
        },
        status.heirline.make_buflist(status.component.tabline_file_info()), -- component for each buffer tab
        status.component.fill { hl = { bg = "tabline_bg" } }, -- fill the rest of the tabline with background color
        { -- tab list
          condition = function() return #vim.api.nvim_list_tabpages() >= 2 end, -- only show tabs if there are more than one
          status.heirline.make_tablist { -- component for each tab
            provider = status.provider.tabnr(),
            hl = function(self) return status.hl.get_attributes(status.heirline.tab_type(self, "tab"), true) end,
          },
          { -- close button for current tab
            provider = status.provider.close_button { kind = "TabClose", padding = { left = 1, right = 1 } },
            hl = status.hl.get_attributes("tab_close", true),
            on_click = {
              callback = function() require("astrocore.buffer").close_tab() end,
              name = "heirline_tabline_close_tab_callback",
            },
          },
        },
      },
      statuscolumn = {
        init = function(self) self.bufnr = vim.api.nvim_get_current_buf() end,
        status.component.foldcolumn(),
        status.component.numbercolumn(),
        status.component.signcolumn(),
      },
    })
  '';

  keymaps = [
    {
      mode = "n";
      key = "<Leader>bb";
      options.desc = "Select buffer from tabline";
      action.__raw = ''
        function()
          require("astroui.status.heirline").buffer_picker(function(bufnr) vim.api.nvim_win_set_buf(0, bufnr) end)
        end
      '';
    }
    {
      mode = "n";
      key = "<Leader>bd";
      options.desc = "Close buffer from tabline";
      action.__raw = ''
        function()
          require("astroui.status.heirline").buffer_picker(
            function(bufnr) require("astrocore.buffer").close(bufnr) end
          )
        end
      '';
    }
  ];
}
