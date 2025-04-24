{
  config,
  lib,
  pkgs,
  namespace,
  ...
}:
let
  inherit (lib) mkIf;
  inherit (lib.${namespace}) mkBoolOpt;

  cfg = config.${namespace}.programs.graphical.addons.fcitx5;
in
{
  options.${namespace}.programs.graphical.addons.fcitx5 = {
    enable = mkBoolOpt false "Whether to enable fcitx5.";
  };

  config = mkIf cfg.enable {
    i18n.inputMethod = {
      enable = true;
      type = "fcitx5";
      fcitx5 = {
        addons = with pkgs; [
          fcitx5-chinese-addons
          fcitx5-gtk
          fcitx5-lua
          fcitx5-pinyin-zhwiki
          fcitx5-pinyin-moegirl
        ];
      };
    };
  };
}
