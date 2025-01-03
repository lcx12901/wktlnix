{
  config,
  inputs,
  lib,
  pkgs,
  system,
  namespace,
  ...
}:
let
  inherit (lib) mkIf mkEnableOption;
  inherit (lib.${namespace}) mkOpt enabled;
  inherit (inputs) hyprland;

  cfg = config.${namespace}.programs.graphical.wms.hyprland;
in
{
  options.${namespace}.programs.graphical.wms.hyprland = {
    enable = mkEnableOption "Hyprland.";
    monitor = mkOpt lib.types.str ",highrr,auto,1" "Set up hyprland's monitor.";
    appendConfig = lib.mkOption {
      type = lib.types.lines;
      default = "";
      description = ''
        Extra configuration lines to add to bottom of `~/.config/hypr/hyprland.conf`.
      '';
    };
    prependConfig = lib.mkOption {
      type = lib.types.lines;
      default = "";
      description = ''
        Extra configuration lines to add to top of `~/.config/hypr/hyprland.conf`.
      '';
    };
  };

  imports = lib.snowfall.fs.get-non-default-nix-files ./.;

  config = mkIf cfg.enable {
    home = {
      packages = with pkgs; [
        xwaylandvideobridge

        swww

        grim
        slurp
      ];

      sessionVariables = {
        GDK_BACKEND = "wayland";
        HYPRLAND_LOG_WLR = "1";
        MOZ_ENABLE_WAYLAND = "1";
        MOZ_USE_XINPUT2 = "1";
        WLR_DRM_NO_ATOMIC = "1";
        XDG_CURRENT_DESKTOP = "Hyprland";
        XDG_SESSION_DESKTOP = "Hyprland";
        XDG_SESSION_TYPE = "wayland";
        _JAVA_AWT_WM_NONREPARENTING = "1";
        __GL_GSYNC_ALLOWED = "0";
        __GL_VRR_ALLOWED = "0";
        NIXOS_OZONE_WL = "1";
      };
    };

    wayland.windowManager.hyprland = {
      enable = true;

      package = hyprland.packages.${system}.hyprland;

      systemd = {
        enable = true;
        variables = [ "--all" ];
      };

      xwayland.enable = true;
    };

    wktlnix = {
      programs = {
        terminal = {
          emulators.kitty = enabled;
          tools.cava = enabled;
        };
        graphical = {
          screenlockers.hyprlock = enabled;
          addons = {
            fcitx5 = enabled;
            mako = enabled;
            clipboard = enabled;
            waybar = enabled;
          };
          launchers.rofi = enabled;
        };
      };

      theme = {
        gtk = enabled;
        catppuccin = enabled;
      };
    };
  };
}
