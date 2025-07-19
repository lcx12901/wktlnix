{ pkgs, ... }:
{
  programs.nvf.settings = {
    vim = {
      lazy.plugins.treesj = {
        package = pkgs.vimPlugins.treesj;
        setupModule = "treesj";
        event = "BufEnter";
      };
    };
  };
}
