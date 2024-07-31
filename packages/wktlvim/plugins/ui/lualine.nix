_: let
  cond.__raw =
    # Lua
    ''
      function()
        local buf_size_limit = 1024 * 1024 -- 1MB size limit
        if vim.api.nvim_buf_get_offset(0, vim.api.nvim_buf_line_count(0)) > buf_size_limit then
          return false
        end

        return true
      end
    '';
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
      left = ""; # or █
      right = ""; # or █
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
          icon = "";
        }
        {
          name = "diff";
          extraConfig = {
            symbols = {
              added = " ";
              modified = " ";
              removed = " ";
            };
            separator = " ";
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
              error = " ";
              warn = " ";
              info = "󰋼 ";
              hint = "󰌵 ";
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
        {
          name = "filetype";
          extraConfig = {
            separator = " ";
          };
        }
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
