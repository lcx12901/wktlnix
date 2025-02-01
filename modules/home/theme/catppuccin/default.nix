{
  config,
  lib,
  pkgs,
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
      bat = enabled;
      cava = {
        enable = true;
        transparent = true;
      };
      fcitx5 = enabled;
      kitty = enabled;
      ghostty = enabled;
      waybar = enabled;
      yazi = enabled;
    };
  };
}
