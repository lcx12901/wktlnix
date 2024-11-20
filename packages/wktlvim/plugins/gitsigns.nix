{ config, ... }:
let
  inherit (config) icons;
in
{
  plugins.gitsigns = {
    enable = true;

    settings = {
      current_line_blame = true;

      current_line_blame_opts = {
        delay = 500;

        ignore_blank_lines = true;
        ignore_whitespace = true;
        virt_text = true;
        virt_text_pos = "eol";
      };

      signs = {
        add.text = icons.GitSign;
        change.text = icons.GitSign;
        changedelete.text = icons.GitSign;
        delete.text = icons.GitSign;
        topdelete.text = icons.GitSign;
        untracked.text = icons.GitSign;
      };

      signcolumn = true;
    };
  };
}
