{
  config,
  lib,
  pkgs,
  ...
}:
let
  inherit (lib) mkIf mkEnableOption;

  cfg = config.wktlnix.programs.graphical.addons.fcitx5;
in
{
  options.wktlnix.programs.graphical.addons.fcitx5 = {
    enable = mkEnableOption "Whether to enable fcitx5.";
  };

  config = mkIf cfg.enable {
    i18n.inputMethod = {
      enable = true;
      type = "fcitx5";
      fcitx5 = {
        addons = with pkgs; [
          kdePackages.fcitx5-chinese-addons
          fcitx5-gtk
          libsForQt5.fcitx5-qt
          fcitx5-lua
          fcitx5-pinyin-zhwiki
          fcitx5-pinyin-moegirl
        ];

        waylandFrontend = true;
      };
    };
  };
}
