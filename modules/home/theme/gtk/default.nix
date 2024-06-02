{
  config,
  lib,
  pkgs,
  osConfig,
  namespace,
  ...
}:
let
  inherit (lib) mkIf mkDefault types;

  inherit (lib.${namespace})
    boolToNum
    mkBoolOpt
    mkOpt
    nested-default-attrs
    ;

  cfg = config.${namespace}.theme.gtk;

  osTheme = osConfig.${namespace}.theme;
in {
  options.${namespace}.theme.gtk = {
    enable = mkBoolOpt false "Whether to customize GTK and apply themes.";
    usePortal = mkBoolOpt false "Whether to use the GTK Portal.";
  };

  config = mkIf cfg.enable {
    home = {
      packages = with pkgs; [
        dconf # required explicitly with noXlibs and home-manager
        glib # gsettings
        gtk3.out # for gtk-launch
        libappindicator-gtk3
      ];

      pointerCursor = mkDefault {
        inherit (osTheme.cursor) name package size;
        x11.enable = true;
      };

      sessionVariables = {
        GTK_USE_PORTAL = "${toString (boolToNum cfg.usePortal)}";
        CURSOR_THEME = mkDefault osTheme.cursor.name;
      };
    };

    dconf = {
      enable = true;

      settings = nested-default-attrs {
        "org/gnome/desktop/interface" = {
          color-scheme = "prefer-dark";
          cursor-size = osTheme.cursor.size;
          cursor-theme = osTheme.cursor.name;
          enable-hot-corners = false;
          font-name = osConfig.${namespace}.system.fonts.default;
          gtk-theme = osTheme.name;
          icon-theme = osTheme.name;
        };
      };
    };

    gtk = {
      enable = true;

      font = {
        name = osConfig.${namespace}.system.fonts.default;
      };

      gtk2 = {
        configLocation = "${config.xdg.configHome}/gtk-2.0/gtkrc";
        extraConfig = ''
          gtk-xft-antialias=1
          gtk-xft-hinting=1
          gtk-xft-hintstyle="hintslight"
          gtk-xft-rgba="rgb"
        '';
      };

      gtk3.extraConfig = {
        gtk-application-prefer-dark-theme = true;
        gtk-button-images = 1;
        gtk-decoration-layout = "appmenu:none";
        gtk-enable-event-sounds = 0;
        gtk-enable-input-feedback-sounds = 0;
        gtk-error-bell = 0;
        gtk-menu-images = 1;
        gtk-toolbar-icon-size = "GTK_ICON_SIZE_LARGE_TOOLBAR";
        gtk-toolbar-style = "GTK_TOOLBAR_BOTH";
        gtk-xft-antialias = 1;
        gtk-xft-hinting = 1;
        gtk-xft-hintstyle = "hintslight";
      };

      gtk4.extraConfig = {
        gtk-application-prefer-dark-theme = true;
        gtk-decoration-layout = "appmenu:none";
        gtk-enable-event-sounds = 0;
        gtk-enable-input-feedback-sounds = 0;
        gtk-error-bell = 0;
        gtk-xft-antialias = 1;
        gtk-xft-hinting = 1;
        gtk-xft-hintstyle = "hintslight";
      };
    };

    xdg.systemDirs.data =
      let
        schema = pkgs.gsettings-desktop-schemas;
      in
      [ "${schema}/share/gsettings-schemas/${schema.name}" ];
  };
}