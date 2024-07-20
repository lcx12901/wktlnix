_: {
  programs.nixvim = {
    colorschemes.catppuccin = {
      settings = {
        dim_inactive = {
          enabled = false;
          percentage = 0.25;
        };

        flavour = "macchiato";

        integrations = {
          # aerial = true;
          # cmp = true;
          # dap = {
          #   enabled = true;
          #   enable_ui = true;
          # };
        };

        transparent_background = true;
      };
    };
  };
}
