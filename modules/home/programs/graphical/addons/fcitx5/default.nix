{
  config,
  lib,
  pkgs,
  namespace,
  ...
}: let
  inherit (lib) mkIf;
  inherit (lib.${namespace}) mkBoolOpt enabled;

  cfg = config.${namespace}.programs.graphical.addons.fcitx5;
in {
  options.${namespace}.programs.graphical.addons.fcitx5 = {
    enable = mkBoolOpt false "Whether to enable fcitx5 in Hyprland.";
  };

  config = mkIf cfg.enable {
    i18n.inputMethod = {
      enabled = "fcitx5";
      fcitx5 = {
        catppuccin = enabled;
        addons = with pkgs; [
          fcitx5-chinese-addons
          fcitx5-gtk
          fcitx5-lua
          libsForQt5.fcitx5-qt

          # themes
          fcitx5-material-color
        ];
      };
    };
  };
}
