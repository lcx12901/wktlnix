{
  programs.nvf.settings = {
    vim.lsp = {
      enable = true;

      formatOnSave = true;
      inlayHints.enable = true;

      servers = {
        "*" = {
          root_markers = [
            ".git"
          ];

          capabilities = {
            textDocument = {
              foldingRange = {
                dynamicRegistration = false;
                lineFoldingOnly = true;
              };

              semanticTokens = {
                multilineTokenSupport = true;
              };
            };
          };
        };
      };
    };
  };
}
