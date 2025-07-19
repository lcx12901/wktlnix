{
  programs.nvf.settings = {
    vim = {
      session.nvim-session-manager = {
        enable = true;

        mappings = {
          deleteSession = "<leader>SD";
          loadLastSession = "<leader>SL";
          loadSession = "<leader>SF";
          saveCurrentSession = "<leader>SS";
        };

        setupOpts = {
          autoload_mode = "GitSession";
        };
      };

      binds.whichKey.register = {
        "<leader>S" = "Session Manager";
      };
    };
  };
}
