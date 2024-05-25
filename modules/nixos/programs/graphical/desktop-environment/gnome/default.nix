{config, lib, namespace, pkgs, ...}: let
  inherit (lib) types mkIf;
  inherit (lib.${namespace}) mkBoolOpt mkOpt;

  cfg = config.${namespace}.programs.graphical.desktop-environment.gnome;

  defaultExtensions = with pkgs.gnomeExtensions; [
    appindicator
    aylurs-widgets
    dash-to-dock
    emoji-selector
    gsconnect
    gtile
    just-perfection
    logo-menu
    no-overview
    remove-app-menu
    space-bar
    top-bar-organizer
    wireless-hid
  ];
in {
  options.${namespace}.programs.graphical.desktop-environment.gnome = with types; {
    enable = mkBoolOpt false "Whether or not to use Gnome as the desktop environment.";
    color-scheme = mkOpt (enum [ "light" "dark" ]) "dark" "The color scheme to use.";
    extensions = mkOpt (listOf package) [ ] "Extra Gnome extensions to install.";
    monitors = mkOpt (nullOr path) null "The monitors.xml file to create.";
    suspend = mkBoolOpt true "Whether or not to suspend the machine after inactivity.";
    wayland = mkBoolOpt true "Whether or not to use Wayland.";
  };

  config = mkIf cfg.enable {
    environment = {
      systemPackages = with pkgs; [
        gnome.gnome-tweaks
        gnome.nautilus-python
        wl-clipboard
      ] ++ defaultExtensions ++ cfg.extensions;

      gnome.excludePackages = with pkgs.gnome; [
        epiphany
        geary
        gnome-font-viewer
        gnome-maps
        gnome-system-monitor
        pkgs.gnome-tour
      ];
    };

    services.xserver = {
      enable = true;
      displayManager.gdm.enable = true;
      desktopManager.gnome.enable = true;
    };
  };
}