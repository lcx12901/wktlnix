{
  config,
  lib,
  ...
}: let
  inherit (config) icons;
in {
  keymaps = lib.mkIf config.plugins.neo-tree.enable [
    {
      mode = "n";
      key = "<Leader>e";
      action = "<Cmd>Neotree toggle<CR>";
      options = {
        desc = "Toggle Explorer";
        silent = true;
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
        silent = true;
      };
    }
  ];

  plugins.neo-tree = {
    enable = true;

    sources = ["filesystem"];

    enableGitStatus = true;
    enableDiagnostics = true;
    enableModifiedMarkers = true;
    enableRefreshOnWrite = true;
    closeIfLastWindow = true;
    popupBorderStyle = "rounded";

    defaultComponentConfigs = {
      indent = {
        padding = 0;
        expanderCollapsed = icons.FoldClosed;
        expanderExpanded = icons.FoldOpened;
      };
      icon = {
        folderClosed = icons.FolderClosed;
        folderOpen = icons.FolderOpen;
        folderEmpty = icons.FolderEmpty;
        folderEmptyOpen = icons.FolderEmpty;
        default = icons.DefaultFile;
      };
      modified.symbol = icons.FileModified;
      gitStatus.symbols = {
        added = icons.GitAdd;
        deleted = icons.GitDelete;
        modified = icons.GitChange;
        renamed = icons.GitRenamed;
        untracked = icons.GitUntracked;
        ignored = icons.GitIgnored;
        unstaged = icons.GitUnstaged;
        staged = icons.GitStaged;
        conflict = icons.GitConflict;
      };
    };

    filesystem = {
      followCurrentFile = {
        enabled = true;
        leaveDirsOpen = true;
      };

      filteredItems = {
        hideDotfiles = false;
        hideHidden = false;

        neverShowByPattern = [
          ".direnv"
          ".git"
        ];

        visible = true;
      };

      hijackNetrwBehavior = "open_current";

      useLibuvFileWatcher.__raw = ''vim.fn.has "win32" ~= 1'';
    };

    window = {
      width = 30;
      autoExpandWidth = false;
      mappings = {
        "<space>" = "none";
      };
    };
  };
}
