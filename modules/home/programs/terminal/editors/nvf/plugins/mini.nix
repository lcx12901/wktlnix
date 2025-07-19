{
  programs.nvf.settings = {
    vim.mini = {
      ai.enable = true;
      align.enable = true;
      basics.enable = true;
      bracketed.enable = true;
      icons.enable = true;
      comment = {
        enable = true;
        setupOpts = {
          mappings = {
            comment = "<leader>/";
            comment_line = "<leader>/";
            comment_visual = "<leader>/";
            textobject = "<leader>/";
          };
        };
      };
    };
  };
}
