{
  programs.nvf.settings = {
    vim.git.gitsigns = {
      enable = true;

      setupOpts = {
        current_line_blame = true;

        current_line_blame_opts = {
          delay = 500;

          ignore_blank_lines = true;
          ignore_whitespace = true;
          virt_text = true;
          virt_text_pos = "eol";
        };

        signs = {
          add.text = "▎";
          change.text = "▎";
          changedelete.text = "▎";
          delete.text = "▎";
          topdelete.text = "▎";
          untracked.text = "▎";
        };

        signcolumn = true;
        numhl = true;
      };
    };
  };
}
