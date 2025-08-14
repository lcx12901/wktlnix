{ pkgs, ... }:
{
  programs.nvf.settings = {
    vim = {
      lazy.plugins."tiny-inline-diagnostic.nvim" = {
        package = pkgs.vimPlugins.tiny-inline-diagnostic-nvim;
        setupModule = "tiny-inline-diagnostic";
        event = "LspAttach";
        setupOpts = {
          preset = "ghost";
          options = {
            add_messages = false;
            multilines = {
              enabled = true;
              always_show = true;
            };
            break_line = {
              enabled = true;
            };
          };
        };
      };
    };
  };
}
