{
  colorschemes.catppuccin = {
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
        cmp = true;
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
        notify = true;
        aerial = true;
        telescope = {
          enabled = true;
          style = "nvchad";
        };
        semantic_tokens = true;
        symbols_outline = true;
        which_key = true;
      };
    };
  };
}
