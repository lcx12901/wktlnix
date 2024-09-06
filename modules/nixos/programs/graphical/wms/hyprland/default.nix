{
  config,
  inputs,
  lib,
  system,
  pkgs,
  namespace,
  ...
}: let
  inherit
    (lib)
    mkIf
    types
    ;
  inherit (lib.${namespace}) mkBoolOpt mkOpt enabled;
  inherit (inputs) hyprland;

  cfg = config.${namespace}.programs.graphical.wms.hyprland;
in {
  options.${namespace}.programs.graphical.wms.hyprland = {
    enable = mkBoolOpt false "Whether or not to enable Hyprland.";
    customConfigFiles =
      mkOpt types.attrs {}
      "Custom configuration files that can be used to override the default files.";
    customFiles = mkOpt types.attrs {} "Custom files that can be used to override the default files.";
  };

  disabledModules = ["programs/hyprland.nix"];

  config = mkIf cfg.enable {
    environment = {
      etc."greetd/environments".text = ''
        "Hyprland"
        fish
      '';
    };

    wktlnix = {
      display-managers = {
        sddm = enabled;
      };

      programs = {
        graphical = {
          addons = {
            xdg-portal = enabled;
          };
        };
      };
    };

    services = {
      displayManager.sessionPackages = [hyprland.packages.${system}.hyprland];

      # needed for GNOME services outside of GNOME Desktop
      dbus.packages = [pkgs.gcr];
      udev.packages = with pkgs; [gnome-settings-daemon];
    };
  };
}
