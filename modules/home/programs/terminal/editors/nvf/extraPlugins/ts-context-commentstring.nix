{ pkgs, ... }:
{
  programs.nvf.settings = {
    vim = {
      lazy.plugins.nvim-ts-context-commentstring = {
        package = pkgs.vimPlugins.nvim-ts-context-commentstring;
        setupModule = "ts_context_commentstring";
        event = "BufEnter";
        setupOpts = {
          enable_autocmd = false;
        };
      };
    };
  };
}
