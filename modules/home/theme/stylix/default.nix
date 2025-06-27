{
  config,
  lib,
  namespace,
  pkgs,
  ...
}:
let
  inherit (lib)
    mkEnableOption
    mkIf
    types
    ;

  inherit (lib.${namespace}) mkOpt enabled;

  cfg = config.${namespace}.theme.stylix;
in
{
  options.${namespace}.theme.stylix = {
    enable = mkEnableOption "stylix theme for applications";
    theme = mkOpt types.str "catppuccin-mocha" "base16 theme file name";

    icon = {
      name = mkOpt types.str "Papirus-Dark" "The name of the icon theme to apply.";
      package = mkOpt types.package (pkgs.catppuccin-papirus-folders.override {
        accent = "lavender";
        flavor = "mocha";
      }) "The package to use for the icon theme.";
    };
  };

  config = mkIf cfg.enable {
    stylix =
      let
        image = ./tanjiro_nezuko.jpg;

        matugenToBase16 =
          name:
          pkgs.runCommand "${name}.yaml" { buildInputs = [ pkgs.matugen ]; }
            # bash --type scheme-expressive scheme-fruit-salad
            ''
              ${pkgs.python3}/bin/python ${./matu2base16.py} ${image} \
                    --name ${name} --polarity ${config.stylix.polarity} --type scheme-expressive --output $out
            '';

      in
      {
        enable = true;
        autoEnable = false;

        inherit image;

        base16Scheme = "${matugenToBase16 "tanjiro_nezuko"}";

        cursor = {
          package = pkgs.graphite-cursors;
          name = "graphite-dark";
          size = 32;
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

        iconTheme = {
          enable = true;
          inherit (cfg.icon) package;
          dark = cfg.icon.name;
          light = cfg.icon.name;
        };

        polarity = "dark";

        targets = {
          firefox = {
            enable = true;
            profileNames = [ config.${namespace}.user.name ];
            firefoxGnomeTheme = enabled;
          };
          btop = enabled;
          bat = enabled;
          cava = {
            enable = true;
            rainbow = enabled;
          };
          fcitx5 = enabled;
          fish = enabled;
          kitty = {
            enable = true;
            variant256Colors = true;
          };
          lazygit = enabled;
          nixvim = enabled;
          vscode = {
            enable = true;
            profileNames = [
              "default"
              "Vue"
            ];
          };
          yazi = enabled;
          gnome = enabled;
          gtk = enabled;
          qt = enabled;
        };
      };
  };
}
