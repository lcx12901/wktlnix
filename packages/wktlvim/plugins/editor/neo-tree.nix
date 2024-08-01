{
  config,
  lib,
  ...
}: {
  keymaps = lib.mkIf config.plugins.neo-tree.enable [
    {
      mode = "n";
      key = "<leader>e";
      action = "<Cmd>Neotree toggle<CR>";
      options = {
        desc = "Toggle Explorer";
      };
    }
    {
      mode = "n";
      key = "<Leader>o";
      action.__raw = ''
        function()
          if vim.bo.filetype == "neo-tree" then
            vim.cmd.wincmd "p"
          else
            vim.cmd.Neotree "focus"
          end
        end
      '';
      options = {
        desc = "Toggle Explorer Focus";
      };
    }
  ];

  plugins.neo-tree = {
    enable = true;

    sources = ["filesystem" "buffers" "git_status" "document_symbols"];

    closeIfLastWindow = true;

    filesystem = {
      bindToCwd = false;

      filteredItems = {
        hideDotfiles = false;
        hideHidden = false;

        neverShowByPattern = [
          ".direnv"
          ".git"
        ];

        visible = true;
      };

      followCurrentFile = {
        enabled = true;
        leaveDirsOpen = true;
      };

      useLibuvFileWatcher.__raw = ''vim.fn.has "win32" ~= 1'';
    };

    defaultComponentConfigs = {
      indent = {
        withExpanders = true;
        expanderCollapsed = "";
        expanderExpanded = " ";
        expanderHighlight = "NeoTreeExpander";
      };

      gitStatus = {
        symbols = {
          added = " ";
          conflict = " ";
          deleted = " ";
          ignored = "◌ ";
          modified = " ";
          renamed = "➜ ";
          staged = "✓ ";
          unstaged = "✗ ";
          untracked = "★ ";
        };
      };
    };

    window = {
      width = 40;
      autoExpandWidth = false;
    };
  };
}
