{
  colorschemes.catppuccin = {
    lazyLoad.enable = true;

    settings = {
      default_integrations = true;
      dim_inactive = {
        enabled = false;
        percentage = 0.25;
      };

      flavour = "frappe";

      show_end_of_buffer = true;
      term_colors = true;
      transparent_background = false;

      integrations = {
        mini = {
          enabled = true;
          indentscope_color = "lavender";
        };
        cmp = true;
        blink_cmp = true;
        gitsigns = true;
        neotree = true;
        treesitter = true;
        treesitter_context = true;
        native_lsp = {
          enabled = true;
          virtual_text = {
            errors = [ "italic" ];
            hints = [ "italic" ];
            warnings = [ "italic" ];
            information = [ "italic" ];
          };
          underlines = {
            errors = [ "underline" ];
            hints = [ "underline" ];
            warnings = [ "underline" ];
            information = [ "underline" ];
          };
          inlay_hints = {
            background = true;
          };
        };
        alpha = true;
        noice = true;
        notify = true;
        aerial = true;
        telescope = {
          enabled = true;
          style = "nvchad";
        };
        fzf = true;
        navic = {
          enabled = true;
        };
        semantic_tokens = true;
        symbols_outline = true;
        snacks = true;
        ufo = true;
        which_key = true;
      };
    };
  };
}
