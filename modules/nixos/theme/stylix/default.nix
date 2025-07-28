{
  inputs,
  config,
  lib,
  namespace,
  pkgs,
  ...
}:
let
  cfg = config.${namespace}.theme.stylix;
in
{
  options.${namespace}.theme.stylix = {
    enable = lib.mkEnableOption "stylix theme for applications";
  };

  config = lib.mkIf cfg.enable {
    stylix =
      let
        image = "${inputs.wallpapers}/Raiden_shogun.png";

        matugenToBase16 =
          name:
          pkgs.runCommand "${name}.yaml" { buildInputs = [ pkgs.matugen ]; }
            # bash --type scheme-expressive scheme-fruit-salad
            ''
              ${pkgs.python3}/bin/python ${./matu2base16.py} ${image} \
                    --name ${name} --polarity ${config.stylix.polarity} --output $out
            '';
      in
      {
        autoEnable = false;

        inherit image;

        base16Scheme = "${matugenToBase16 "Raiden_shogun"}";

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
