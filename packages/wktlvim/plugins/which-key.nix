{config, ...}: let
  inherit (config) icons;
in {
  plugins.which-key = {
    enable = true;

    settings = {
      spec = [
        {
          __unkeyed = "<Leader>b";
          group = "Buffers";
          icon = "${icons.Tab}";
        }
        {
          __unkeyed = "<Leader>bs";
          group = "Sort";
          icon = "${icons.Sort}";
        }
        {
          __unkeyed = "<Leader>g";
          group = "Git";
          icon = "${icons.Git} ";
        }
        {
          __unkeyed = "<Leader>f";
          group = "Find";
          icon = "${icons.Search}";
        }
      ];

      replace = {
        desc = [
          [
            "<space>"
            "SPACE"
          ]
          [
            "<Leader>"
            "SPACE"
          ]
          [
            "<[cC][rR]>"
            "RETURN"
          ]
          [
            "<[tT][aA][bB]>"
            "TAB"
          ]
          [
            "<[bB][sS]>"
            "BACKSPACE"
          ]
        ];
      };

      win = {
        border = "single";
      };

      ft = [
        "TelescopePrompt"
        "neo-tree"
        "neo-tree-popup"
      ];
    };
  };
}