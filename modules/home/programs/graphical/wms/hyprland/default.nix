{
  config,
  inputs,
  lib,
  pkgs,
  system,
  namespace,
  ...
}: let
  inherit (lib) mkIf mkEnableOption;
  inherit (lib.${namespace}) enabled;
  inherit (inputs) hyprland;

  cfg = config.${namespace}.programs.graphical.wms.hyprland;
in {
  options.${namespace}.programs.graphical.wms.hyprland = {
    enable = mkEnableOption "Hyprland.";
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
      packages = with pkgs; [swww];

      sessionVariables = {
        CLUTTER_BACKEND = "wayland";
        GDK_BACKEND = "wayland,x11";
        HYPRLAND_LOG_WLR = "1";
        MOZ_ENABLE_WAYLAND = "1";
        MOZ_USE_XINPUT2 = "1";
        SDL_VIDEODRIVER = "wayland";
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
        variables = ["--all"];
      };

      xwayland.enable = true;
    };

    wktlnix = {
      programs = {
        terminal = {
          emulators.kitty = enabled;
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
