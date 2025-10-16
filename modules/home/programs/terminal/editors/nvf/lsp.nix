{
  programs.nvf.settings = {
    vim = {
      lsp = {
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

      languages = {
        enableFormat = true;
        enableTreesitter = true;
        enableExtraDiagnostics = true;

        bash.enable = true;
        json.enable = true;
        markdown.enable = true;
      };
    };
  };
}
