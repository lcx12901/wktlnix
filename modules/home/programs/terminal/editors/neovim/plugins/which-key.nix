_: {
  programs.nixvim = {
    plugins.which-key = {
      enable = true;

      keyLabels = {
        "<space>" = "SPACE";
        "<leader>" = "SPACE";
        "<cr>" = "RETURN";
        "<CR>" = "RETURN";
        "<tab>" = "TAB";
        "<TAB>" = "TAB";
        "<bs>" = "BACKSPACE";
        "<BS>" = "BACKSPACE";
      };

      registrations = {
        "<leader>" = {
        };
      };

      window = {
        border = "single";
      };
    };
  };
}
