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
    stylix =
      let
        image = "${inputs.wallpapers}/${cfg.image}";

        # matugenToBase16 =
        #   name:
        #   pkgs.runCommand "${name}.yaml" { buildInputs = [ pkgs.matugen ]; }
        #     # bash --type scheme-expressive scheme-fruit-salad
        #     ''
        #       ${pkgs.python3}/bin/python ${./matu2base16.py} ${image} \
        #             --name ${name} --polarity ${config.stylix.polarity} --type scheme-expressive --output $out
        #     '';
      in
      {
        autoEnable = false;

        inherit image;

        base16Scheme = "${pkgs.base16-schemes}/share/themes/catppuccin-frappe.yaml";

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
