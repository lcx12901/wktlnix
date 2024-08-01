{
  helpers,
  lib,
  ...
}: {
  extraConfigLuaPre =
    # lua
    ''
      function bool2str(bool) return bool and "on" or "off" end
    '';

  globals = {
    mapleader = " ";
    maplocalleader = " ";
  };

  /*
    *
  ```nix
    mapAttrsToList (name: value: name + value)
      { x = "a"; y = "b"; }
    => [ "xa" "yb" ]
    ```
  */

  keymaps = let
    normal =
      lib.mapAttrsToList (
        key: {action, ...} @ attrs: {
          mode = "n";
          inherit action key;
          options = attrs.options or {};
        }
      ) {
        "<Space>" = {
          action = "<NOP>";
        };

        # Esc to clear search results
        "<esc>" = {
          action = ":noh<CR>";
        };

        # Backspace delete in normal
        "<BS>" = {
          action = "<BS>x";
        };

        # fix Y behaviour
        "Y" = {
          action = "y$";
        };

        # back and fourth between the two most recent files
        "<C-c>" = {
          action = ":b#<CR>";
        };

        # navigate to left/right window
        "<leader>[" = {
          action = "<C-w>h";
          options = {
            desc = "Left window";
          };
        };
        "<leader>]" = {
          action = "<C-w>l";
          options = {
            desc = "Right window";
          };
        };

        # navigate quickfix list
        "<C-k>" = {
          action = ":cnext<CR>";
        };
        "<C-j>" = {
          action = ":cprev<CR>";
        };

        # resize with arrows
        "<C-Up>" = {
          action = ":resize -2<CR>";
        };
        "<C-Down>" = {
          action = ":resize +2<CR>";
        };
        "<C-Left>" = {
          action = ":vertical resize +2<CR>";
        };
        "<C-Right>" = {
          action = ":vertical resize -2<CR>";
        };

        # move current line up/down
        # M = Alt key
        "<M-k>" = {
          action = ":move-2<CR>";
        };
        "<M-j>" = {
          action = ":move+<CR>";
        };

        "j" = {
          action = "v:count == 0 ? 'gj' : 'j'";
          options = {
            desc = "Move cursor down";
            expr = true;
          };
        };
        "k" = {
          action = "v:count == 0 ? 'gk' : 'k'";
          options = {
            desc = "Move cursor up";
            expr = true;
          };
        };

        "<Leader>w" = {
          action = "<Cmd>w<CR>"; # Action to perform (save the file in this case)
          options = {
            desc = "Save";
          };
        };
        "<Leader>q" = {
          action = "<Cmd>confirm q<CR>";
          options = {
            desc = "Quit";
          };
        };
        "<Leader>n" = {
          action = "<Cmd>enew<CR>";
          options = {
            desc = "New file";
          };
        };
        "<leader>W" = {
          action = "<Cmd>w!<CR>";
          options = {
            desc = "Force write";
          };
        };
        "<leader>Q" = {
          action = "<Cmd>q!<CR>";
          options = {
            desc = "Force quit";
          };
        };

        "|" = {
          action = "<Cmd>vsplit<CR>";
          options = {
            desc = "Vertical split";
          };
        };
        "\\" = {
          action = "<Cmd>split<CR>";
          options = {
            desc = "Horizontal split";
          };
        };

        "<leader>bC" = {
          action = ":%bd!<CR>";
          options = {
            desc = "Close all buffers";
            silent = true;
          };
        };
        "<leader>b]" = {
          action = ":bnext<CR>";
          options = {
            desc = "Next buffer";
            silent = true;
          };
        };
        "<TAB>" = {
          action = ":bnext<CR>";
          options = {
            desc = "Next buffer (default)";
            silent = true;
          };
        };
        "<leader>b[" = {
          action = ":bprevious<CR>";
          options = {
            desc = "Previous buffer";
            silent = true;
          };
        };
      };
  in
    helpers.keymaps.mkKeymaps {options.silent = true;} normal;
}
