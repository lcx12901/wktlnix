{
  config,
  lib,
  pkgs,
  inputs,
  namespace,
  ...
}:
let
  inherit (lib)
    mkIf
    mkEnableOption
    mkOption
    types
    ;
  inherit (lib.${namespace}) enabled;

  catppuccinAccents = [
    "rosewater"
    "flamingo"
    "pink"
    "mauve"
    "red"
    "maroon"
    "peach"
    "yellow"
    "green"
    "teal"
    "sky"
    "sapphire"
    "blue"
    "lavender"
  ];

  catppuccinFlavors = [
    "latte"
    "frappe"
    "macchiato"
    "mocha"
  ];

  cfg = config.${namespace}.theme.catppuccin;
in
{
  options.${namespace}.theme.catppuccin = {
    enable = mkEnableOption "Enable catppuccin theme for applications.";

    accent = mkOption {
      type = types.enum catppuccinAccents;
      default = "lavender";
      description = ''
        An optional theme accent.
      '';
    };

    flavor = mkOption {
      type = types.enum catppuccinFlavors;
      default = "macchiato";
      description = ''
        An optional theme flavor.
      '';
    };

    package = mkOption {
      type = types.package;
      default = pkgs.catppuccin.override {
        inherit (cfg) accent;
        variant = cfg.flavor;
      };
    };
  };

  config = mkIf cfg.enable {
    catppuccin = {
      # NOTE: Need some customization and merging of configuration files so cant just enable all
      enable = false;

      inherit (cfg) accent flavor;

      btop = enabled;
      cava = {
        enable = true;
        transparent = true;
      };
      kitty = enabled;
      waybar = enabled;
      yazi = enabled;
    };

    xdg.dataFile."fcitx5/themes/catppuccin-${cfg.flavor}-${cfg.accent}" = {
      source = "${inputs.catppuccin-fcitx5}/src/catppuccin-${cfg.flavor}-${cfg.accent}";
      recursive = true;
    };
    xdg.configFile."fcitx5/conf/classicui.conf" = {
      text = lib.generators.toINIWithGlobalSection { } {
        globalSection.Theme = "catppuccin-${cfg.flavor}-${cfg.accent}";
      };
    };
  };
}
