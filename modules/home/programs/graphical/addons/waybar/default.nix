{
  config,
  lib,
  pkgs,
  inputs,
  namespace,
  ...
}:
let
  inherit (lib) mkMerge mkIf types;
  inherit (lib.${namespace}) mkBoolOpt mkOpt;
  inherit (inputs) waybar;

  cfg = config.${namespace}.programs.graphical.addons.waybar;

  default-modules = import ./modules/default-modules.nix { inherit config lib pkgs; };
  group-modules = import ./modules/group-modules.nix;
  hyprland-modules = import ./modules/hyprland-modules.nix { inherit config lib; };

  style = builtins.readFile ./styles/style.css;
  workspacesStyle = builtins.readFile ./styles/workspaces.css;
  stats = builtins.readFile ./styles/stats.css;

  commonAttributes = {
    layer = "top";
    position = "top";

    margin-top = 0;
    margin-left = 0;
    margin-right = 0;

    modules-left = [
      "custom/launcher"
      "pulseaudio"
      "mpd"
    ];

    modules-center = [
      # "cava#left"
      "hyprland/workspaces"
      # "cava#right"
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
      # FIXME:tray module not showing icons, wait for upstream fix
      # package = waybar.packages.${system}.waybar;
      systemd.enable = true;

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

        ${style}
        ${workspacesStyle}
        ${stats}
      '';
    };
  };
}
