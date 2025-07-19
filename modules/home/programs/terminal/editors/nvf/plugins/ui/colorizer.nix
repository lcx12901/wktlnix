{
  programs.nvf.settings = {
    vim.ui.colorizer = {
      enable = true;

      setupOpts = {
        user_default_options = {
          css = true;
          tailwind = true;
          mode = "foreground";
        };
      };
    };
  };
}
