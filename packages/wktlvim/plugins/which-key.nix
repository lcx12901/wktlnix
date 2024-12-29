{ config, ... }:
let
  inherit (config) icons;
in
{
  plugins.which-key = {
    enable = true;

    lazyLoad.settings.event = "UIEnter";

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
        {
          __unkeyed = "<Leader>l";
          group = "Find";
          icon = "${icons.ActiveLSP}";
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
