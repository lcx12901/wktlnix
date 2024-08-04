{config, ...}: let
  inherit (config) icons;
in {
  plugins.lualine = {
    enable = true;
    globalstatus = true;

    extensions = [
      "fzf"
      "neo-tree"
    ];

    disabledFiletypes = {
      statusline = ["startup" "alpha"];
    };

    theme = "catppuccin";

    componentSeparators = {
      left = "";
      right = "";
    };

    sectionSeparators = {
      left = "█"; # or 
      right = "█"; # or 
    };

    sections = {
      lualine_a = [
        {
          name = "mode";
          icon = " ";
        }
      ];

      lualine_b = [
        {
          name = "branch";
          icon = icons.GitBranch;
        }
        {
          name = "diff";
          extraConfig = {
            symbols = {
              added = icons.GitAdd;
              modified = icons.GitChange;
              removed = icons.GitDelete;
            };
          };
        }
      ];

      lualine_c = [
        {
          name = "filesize";
          extraConfig = {
            cond.__raw = ''
              function()
                return vim.fn.empty(vim.fn.expand('%:t')) ~= 1
              end
            '';
          };
        }
        {
          name = "filename";
          color.gui = "bold";
          extraConfig = {
            path = 1;
          };
        }
      ];

      lualine_x = [
        {
          name = "diagnostics";
          extraConfig = {
            sources = ["nvim_lsp"];
            symbols = {
              error = icons.DiagnosticError;
              warn = icons.DiagnosticWarn;
              info = icons.DiagnosticInfo;
              hint = icons.DiagnosticHint;
            };
          };
        }
        {
          name.__raw =
            # lua
            ''
              function()
                  local msg = ""
                  local buf_ft = vim.api.nvim_buf_get_option(0, 'filetype')
                  local clients = vim.lsp.get_active_clients()
                  if next(clients) == nil then
                      return msg
                  end
                  for _, client in ipairs(clients) do
                      local filetypes = client.config.filetypes
                      if filetypes and vim.fn.index(filetypes, buf_ft) ~= -1 then
                          return client.name
                      end
                  end
                  return msg
              end
            '';
          icon = "";
          color.fg = "#ffffff";
        }
        "encoding"
        "fileformat"
        "filetype"
      ];

      lualine_y = [
      ];

      lualine_z = [
        {
          name = "location";
        }
      ];
    };
  };
}
