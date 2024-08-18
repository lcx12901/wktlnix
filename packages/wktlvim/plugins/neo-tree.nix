{
  plugins.neo-tree = {
    enable = true;

    closeIfLastWindow = true;

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

      hijackNetrwBehavior = "open_current";

      useLibuvFileWatcher.__raw =
        # lua
        ''vim.fn.has "win32" ~= 1'';
    };

    window = {
      width = 40;
      autoExpandWidth = false;
    };
  };
}
