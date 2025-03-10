{
  config,
  lib,
  pkgs,
  osConfig,
  namespace,
  ...
}:
let
  inherit (lib) mkIf mkDefault;
  inherit (lib.types) str package int;
  inherit (lib.${namespace})
    boolToNum
    mkBoolOpt
    nested-default-attrs
    mkOpt
    ;

  cfg = config.${namespace}.theme.gtk;
in
{
  options.${namespace}.theme.gtk = {
    enable = mkBoolOpt false "Whether to customize GTK and apply themes.";
    usePortal = mkBoolOpt true "Whether to use the GTK Portal.";

    cursor = {
      name = mkOpt str "catppuccin-macchiato-lavender-cursors" "The name of the cursor theme to apply.";
      package =
        mkOpt package pkgs.catppuccin-cursors.macchiatoLavender
          "The package to use for the cursor theme.";
      size = mkOpt int 22 "The size of the cursor.";
    };

    icon = {
      name = mkOpt str "Papirus-Dark" "The name of the icon theme to apply.";
      package = mkOpt package (pkgs.catppuccin-papirus-folders.override {
        accent = "lavender";
        flavor = "macchiato";
      }) "The package to use for the icon theme.";
    };

    theme = {
      name = mkOpt str "catppuccin-macchiato-lavender-standard" "The name of the theme to apply";
      package = mkOpt package (pkgs.catppuccin-gtk.override {
        accents = [ "lavender" ];
        size = "standard";
        variant = "macchiato";
      }) "The package to use for the theme";
    };
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
        inherit (cfg.cursor) name package size;
        gtk.enable = true;
        x11.enable = true;
      };

      sessionVariables = {
        GTK_USE_PORTAL = "${toString (boolToNum cfg.usePortal)}";
        CURSOR_THEME = "${cfg.cursor.name}";
      };
    };

    dconf = {
      enable = true;

      settings = nested-default-attrs {
        "org/gnome/shell" = {
          disable-user-extensions = false;
          enabled-extensions = [ "user-theme@gnome-shell-extensions.gcampax.github.com" ];
        };

        "org/gnome/desktop/interface" = {
          color-scheme = "prefer-dark";
          cursor-size = cfg.cursor.size;
          cursor-theme = cfg.cursor.name;
          enable-hot-corners = false;
          font-name = osConfig.${namespace}.system.fonts.default;
          gtk-theme = cfg.theme.name;
          icon-theme = cfg.icon.name;
        };

        "org/gnome/shell/extensions/user-theme" = {
          inherit (cfg.theme) name;
        };

        # tell virt-manager to use the system connection
        "org/virt-manager/virt-manager/connections" = {
          autoconnect = [ "qemu:///system" ];
          uris = [ "qemu:///system" ];
        };
      };
    };

    gtk = {
      enable = true;

      font = {
        name = osConfig.${namespace}.system.fonts.default;
      };

      iconTheme = {
        inherit (cfg.icon) name package;
      };

      theme = {
        inherit (cfg.theme) name package;
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
        # gtk-application-prefer-dark-theme = true;
        gtk-decoration-layout = "appmenu:none";
        gtk-enable-event-sounds = 0;
        gtk-enable-input-feedback-sounds = 0;
        gtk-error-bell = 0;
        gtk-xft-antialias = 1;
        gtk-xft-hinting = 1;
        gtk-xft-hintstyle = "hintslight";
      };
    };

    xdg = {
      configFile =
        let
          gtk4Dir = "${cfg.theme.package}/share/themes/${cfg.theme.name}/gtk-4.0";
        in
        {
          "gtk-4.0/assets".source = "${gtk4Dir}/assets";
          "gtk-4.0/gtk.css".source = "${gtk4Dir}/gtk.css";
          "gtk-4.0/gtk-dark.css".source = "${gtk4Dir}/gtk-dark.css";
        };

      systemDirs.data =
        let
          schema = pkgs.gsettings-desktop-schemas;
        in
        [ "${schema}/share/gsettings-schemas/${schema.name}" ];
    };
  };
}
