{
  lib,
  config,
  ...
}:
let
  inherit (config) icons;
in
{
  plugins.neo-tree = {
    enable = true;

    # Close Neo-tree if it is the last window left in the tab
    closeIfLastWindow = true;

    # Disable fold column (gutter)
    eventHandlers = {
      neo_tree_buffer_enter = ''
        function(_)
          vim.opt_local.signcolumn = "auto"
          vim.opt_local.foldcolumn = "0"
        end
      '';
    };

    filesystem = {
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

      # Open neotree "fullscreen" when opening a directory
      hijackNetrwBehavior = "open_current";

      useLibuvFileWatcher.__raw = ''vim.fn.has "win32" ~= 1'';
    };

    window = {
      width = 30;
      autoExpandWidth = false;

      mappings = {
        "[b" = "prev_source";
        "]b" = "next_source";

        # Disable default behavior to toggle node on Space keypress
        "<Space>".__raw = "false";

        # See extraOptions.commands for details on following keymaps
        h = "parent_or_close";
        l = "child_or_open";
      };
    };

    defaultComponentConfigs = {
      modified.symbol = icons.FileModified;
      diagnostics = {
        symbols = {
          error = icons.DiagnosticError;
          hint = icons.DiagnosticHint;
          info = icons.DiagnosticInfo;
          warn = icons.DiagnosticWarn;
        };
      };
      gitStatus.symbols = {
        added = icons.GitAdd;
        conflict = icons.GitConflict;
        deleted = icons.GitDelete;
        ignored = icons.GitIgnored;
        modified = icons.GitChange;
        renamed = icons.GitRenamed;
        staged = icons.GitStaged;
        unstaged = icons.GitUnstaged;
        untracked = icons.GitUntracked;
      };
    };

    # Sources tabs
    sourceSelector = {
      # Label position
      contentLayout.__raw = "'center'";

      # No tabs separator
      separator = "";

      # Show tabs on winbar
      winbar = true;

      # Sources to show and their labels
      sources = [
        {
          displayName = "${icons.FolderClosed} Files";
          source = "filesystem";
        }
        {
          displayName = "${icons.DefaultFile} Bufs";
          source = "buffers";
        }
        {
          displayName = "${icons.Git} Git";
          source = "git_status";
        }
      ];
    };

    # Extra options not exposed by the plugin
    extraOptions = {
      # Custom functions (taken from AstroNvim)
      # https://github.com/AstroNvim/AstroNvim/blob/v4.27.2/lua/astronvim/plugins/neo-tree.lua#L108
      commands = {
        # Focus parent directory of currently focused item or close directory
        parent_or_close.__raw = ''
          function(state)
            local node = state.tree:get_node()
            if node:has_children() and node:is_expanded() then
              state.commands.toggle_node(state)
            else
              require("neo-tree.ui.renderer").focus_node(state, node:get_parent_id())
            end
          end
        '';
        # Focus first directory child item or open directory
        child_or_open.__raw = ''
          function(state)
            local node = state.tree:get_node()
            if node:has_children() then
              if not node:is_expanded() then -- if unexpanded, expand
                state.commands.toggle_node(state)
              else -- if expanded and has children, seleect the next child
                if node.type == "file" then
                  state.commands.open(state)
                else
                  require("neo-tree.ui.renderer").focus_node(state, node:get_child_ids()[1])
                end
              end
            else -- if has no children
              state.commands.open(state)
            end
          end
        '';
      };
    };
  };

  keymaps = lib.mkIf config.plugins.neo-tree.enable [
    {
      mode = "n";
      key = "<Leader>e";
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

  autoCmd =
    let
      refresh = ''
        function()
          local manager_avail, manager = pcall(require, "neo-tree.sources.manager")
          if manager_avail then
            for _, source in ipairs { "filesystem", "git_status", "document_symbols" } do
              local module = "neo-tree.sources." .. source
              if package.loaded[module] then manager.refresh(require(module).name) end
            end
          end
        end
      '';
    in
    lib.mkIf config.plugins.neo-tree.enable [
      {
        event = "BufEnter";
        desc = "Open Neo-Tree on startup with directory";
        group = "neotree";
        callback.__raw = ''
          function()
            if package.loaded["neo-tree"] then
              return true
            else
              local stats = vim.loop.fs_stat(vim.api.nvim_buf_get_name(0))
              if stats and stats.type == "directory" then
                return true
              end
            end
          end
        '';
      }
      {
        desc = "Refresh explorer sources on focus";
        event = "FocusGained";
        group = "neotree";
        callback.__raw = refresh;
      }
    ];
}
