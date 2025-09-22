{
  config,
  lib,
  pkgs,
  ...
}:
let
  inherit (lib) mkIf mkEnableOption;

  cfg = config.wktlnix.programs.graphical.addons.mako;
in
{
  options.wktlnix.programs.graphical.addons.mako = {
    enable = mkEnableOption "Whether to enable Mako in Wayland.";
  };

  config = mkIf cfg.enable {
    stylix.targets.mako.enable = true;

    home.packages = with pkgs; [
      libnotify
    ];

    services.mako = {
      enable = true;
      settings = {
        border-size = 4;
        border-radius = 8;
        default-timeout = 5000;
        ignore-timeout = false;
      };
    };
  };
}
