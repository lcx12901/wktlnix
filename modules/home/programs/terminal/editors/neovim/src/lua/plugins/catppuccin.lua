return {
  "catppuccin/nvim",
  name = "catppuccin",
  opts = {
    flavour = "frappe", -- latte, frappe, macchiato, mocha
    transparent_background = false, -- setting the background color.
    term_colors = true, -- setting the terminal colors.

    integrations = {
      noice = true;
      treesitter = true;
      indent_blankline = {
        enabled = true;
        colored_indent_levels = true;
      };
      lsp_trouble = true;
      telescope = {
        enabled = true;
        style = "nvchad";
      };
      which_key = true;
    },
  },
}
