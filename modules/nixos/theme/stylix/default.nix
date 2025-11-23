{
  inputs,
  config,
  lib,
  pkgs,
  ...
}:
let
  inherit (lib) mkIf mkEnableOption types;
  inherit (lib.wktlnix) mkOpt;

  cfg = config.wktlnix.theme.stylix;
in
{
  options.wktlnix.theme.stylix = {
    enable = mkEnableOption "stylix theme for applications";
    image = mkOpt types.str "artoria.jpg" "wallpaper name";
  };

  config = mkIf cfg.enable {
    stylix = {
      autoEnable = false;

      image = "${inputs.wallpapers}/${cfg.image}";

      base16Scheme = "${pkgs.base16-schemes}/share/themes/catppuccin-macchiato.yaml";

      cursor = {
        package = pkgs.graphite-cursors;
        name = "graphite-dark";
        size = 22;
      };

      fonts = {
        serif = {
          package = pkgs.maple-mono.NF-CN;
          name = "Maple Mono NF CN";
        };
        sansSerif = {
          package = pkgs.maple-mono.NF-CN;
          name = "Maple Mono NF CN";
        };
        monospace = {
          package = pkgs.maple-mono.NF-CN;
          name = "Maple Mono NF CN";
        };
        emoji = {
          package = pkgs.noto-fonts-color-emoji;
          name = "Noto Color Emoji";
        };
      };

      polarity = "dark";
    };
  };
}
