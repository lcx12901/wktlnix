{
  config,
  lib,
  pkgs,
  namespace,
  ...
}:
let
  cfg = config.${namespace}.programs.graphical.addons.mako;
in
{
  options.${namespace}.programs.graphical.addons.mako = {
    enable = lib.mkEnableOption "Whether to enable Mako in Wayland.";
  };

  config = lib.mkIf cfg.enable {
    stylix.targets.mako.enable = true;

    home.packages = with pkgs; [
      libnotify
    ];

    services.mako = {
      enable = true;
      settings = {
        border-size = 4;
        border-radius = 8;
      };
    };
  };
}
