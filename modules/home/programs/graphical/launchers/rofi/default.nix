{
  config,
  lib,
  pkgs,
  ...
}:
let
  inherit (lib) mkIf mkEnableOption;

  cfg = config.wktlnix.programs.graphical.launchers.rofi;
in
{
  options.wktlnix.programs.graphical.launchers.rofi = {
    enable = mkEnableOption "Whether to enable Rofi in the desktop environment.";
  };

  config = mkIf cfg.enable {
    home.packages = with pkgs; [ wtype ];

    programs.rofi = {
      enable = true;
      package = pkgs.rofi;

      font = "Maple Mono NF CN 14";

      location = "center";
      theme = "catppuccin";

      pass = {
        enable = true;
        package = pkgs.rofi-pass-wayland;
      };

      plugins = with pkgs; [
        rofi-calc
        rofi-emoji
        rofi-top
      ];
    };

    xdg.configFile = {
      "rofi" = {
        source = lib.cleanSourceWith { src = lib.cleanSource ./config/.; };

        recursive = true;
      };
    };
  };
}
