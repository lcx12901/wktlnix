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
  options.${namespace}.programs.terminal.editors.neovim = {
    enable = mkEnableOption "neovim";
    default = mkBoolOpt true "Whether to set Neovim as the session EDITOR";
  };

  config = mkIf cfg.enable {
    # home = {
    #   sessionVariables = {
    #     EDITOR = mkIf cfg.default "nvim";
    #   };

    #   packages = [pkgs.${namespace}.wktlvim];
    # };
  };
}
