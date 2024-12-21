{ config, lib, ... }:
let
  inherit (config) icons;
in
{
  plugins.bufferline =
    let
      mouse = {
        right = # Lua
          "'vertical sbuffer %d'";
        close = # Lua
          ''
            function(bufnum)
              require("mini.bufremove").delete(bufnum)
            end
          '';
      };
    in
    {
      enable = true;

      lazyLoad.settings.event = "BufEnter";

      settings = {
        options = {
          mode = "buffers";
          always_show_bufferline = true;
          buffer_close_icon = icons.BufferClose;
          close_command.__raw = mouse.close;
          close_icon = icons.BufferClose;
          diagnostics = "nvim_lsp";
          diagnostics_indicator = # Lua
            ''
              function(count, level, diagnostics_dict, context)
                local s = ""
                for e, n in pairs(diagnostics_dict) do
                  local sym = e == "error" and " ${icons.DiagnosticError}"
                    or (e == "warning" and " ${icons.DiagnosticWarn}" or "" )
                  if(sym ~= "") then
                    s = s .. " " .. n .. sym
                  end
                end
                return s
              end
            '';
          # Will make sure all names in bufferline are unique
          enforce_regular_tabs = false;

          indicator = {
            style = "icon";
            icon = "${icons.GitSign}";
          };

          left_trunc_marker = icons.ArrowLeft;
          max_name_length = 18;
          max_prefix_length = 15;
          modified_icon = icons.FileModified;

          numbers.__raw = ''
            function(opts)
              return string.format('%s·%s', opts.raise(opts.id), opts.lower(opts.ordinal))
            end
          '';

          persist_buffer_sort = true;
          right_mouse_command.__raw = mouse.right;
          right_trunc_marker = icons.ArrowRight;
          separator_style = "thin";
          show_buffer_close_icons = true;
          show_buffer_icons = true;
          show_close_icon = true;
          show_tab_indicators = true;
          sort_by = "extension";
          tab_size = 18;

          offsets = [
            {
              filetype = "neo-tree";
              text = "File Explorer";
              text_align = "center";
              highlight = "Directory";
            }
          ];
        };
      };
    };

  keymaps = lib.mkIf config.plugins.bufferline.enable [
    {
      mode = "n";
      key = "<leader>bP";
      action = "<cmd>BufferLineTogglePin<cr>";
      options = {
        desc = "Pin buffer toggle";
      };
    }
    {
      mode = "n";
      key = "<leader>bb";
      action = "<cmd>BufferLinePick<cr>";
      options = {
        desc = "Pick Buffer";
      };
    }
    {
      mode = "n";
      key = "<leader>bd";
      action = "<cmd>BufferLinePickClose<cr>";
      options = {
        desc = "Pick Buffer Close";
      };
    }
    {
      mode = "n";
      key = "<leader>bsd";
      action = "<cmd>BufferLineSortByDirectory<cr>";
      options = {
        desc = "Sort By Directory";
      };
    }
    {
      mode = "n";
      key = "<leader>bse";
      action = "<cmd>BufferLineSortByExtension<cr>";
      options = {
        desc = "Sort By Extension";
      };
    }
    {
      mode = "n";
      key = "<leader>bsr";
      action = "<cmd>BufferLineSortByRelativeDirectory<cr>";
      options = {
        desc = "Sort By Relative Directory";
      };
    }
  ];
}
