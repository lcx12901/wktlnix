{
  plugins.lualine = {
    enable = true;

    disabledFiletypes = {
      winbar = [
        "neo-tree"
      ];
    };

    globalstatus = true;

    componentSeparators = {
      left = "|";
      right = "|";
    };
    sectionSeparators = {
      left = "█"; # 
      right = "█"; # 
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
          };
        }
        {
          name = "diagnostics";
          extraConfig = {
            sources = ["nvim_lsp"];
            symbols = {
              error = " ";
              warn = " ";
              info = " ";
              hint = "󰛩 ";
            };
          };
        }
      ];
      lualine_c = [
        {
          name = "filetype";
          extraConfig = {
            icon_only = true;
            separator = "";
            padding = {
              left = 1;
              right = 0;
            };
          };
        }
        {
          name = "filename";
          extraConfig = {
            path = 1;
          };
        }
      ];
      lualine_x = [
      ];
      lualine_y = [
        "encoding"
        "fileformat"
      ];
      lualine_z = [
        "progress"
        "location"
      ];
    };
  };
}
