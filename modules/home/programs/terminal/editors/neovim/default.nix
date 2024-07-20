{
  config,
  lib,
  namespace,
  ...
}: let
  inherit (lib) mkEnableOption mkIf;
  inherit (lib.${namespace}) mkBoolOpt;

  cfg = config.${namespace}.programs.terminal.editors.neovim;
in {
  # https://nix-community.github.io/nixvim/
  options.${namespace}.programs.terminal.editors.neovim = {
    enable = mkEnableOption "neovim";
    default = mkBoolOpt true "Whether to set Neovim as the session EDITOR";
  };

  imports = lib.snowfall.fs.get-non-default-nix-files-recursive ./.;

  config = mkIf cfg.enable {
    home = {
      sessionVariables = {
        EDITOR = mkIf cfg.default "nvim";
      };
    };

    programs.nixvim = {
      enable = true;

      defaultEditor = true;

      viAlias = true;
      vimAlias = true;

      luaLoader.enable = true;

      # Highlight and remove extra white spaces
      highlight.ExtraWhitespace.bg = "red";
      match.ExtraWhitespace = "\\s\\+$";

      colorschemes.catppuccin.enable = true;
    };
  };
}
