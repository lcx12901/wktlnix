{
  config,
  lib,
  pkgs,
  namespace,
  ...
}:
let
  inherit (lib) mkMerge mkIf types;
  inherit (lib.${namespace}) mkBoolOpt mkOpt;

  cfg = config.${namespace}.programs.graphical.addons.waybar;

  default-modules = import ./modules/default-modules.nix { inherit config lib pkgs; };
  group-modules = import ./modules/group-modules.nix;
  hyprland-modules = import ./modules/hyprland-modules.nix { inherit config lib; };

  commonAttributes = {
    layer = "top";
    position = "top";

    margin-top = 0;
    margin-left = 0;
    margin-right = 0;

    modules-left = [
      "custom/launcher"
      "pulseaudio"
      # "mpd"
    ];

    modules-center = [
      "cava#left"
      "niri/workspaces"
      "cava#right"
    ];

    modules-right = [
      "group/stats"
      "group/tray"
      "clock"
    ];
  };
in
{
  options.${namespace}.programs.graphical.addons.waybar = {
    enable = mkBoolOpt false "Whether to enable waybar in Hyprland.";
    basicFontSize = mkOpt types.str "15" "Set waybar basic font size.";
  };

  config = mkIf cfg.enable {
    programs.waybar = {
      enable = true;

      settings.mainBar = mkMerge [
        commonAttributes
        default-modules
        group-modules
        hyprland-modules
      ];

      style = ''
        * {
          font-size: ${cfg.basicFontSize}px;
        }

        ${builtins.readFile ./styles/style.css}
        ${builtins.readFile ./styles/workspaces.css}
        ${builtins.readFile ./styles/stats.css}
      '';
    };
  };
}
