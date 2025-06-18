{
  config,
  lib,
  namespace,
  pkgs,
  ...
}:
let
  inherit (lib)
    mkEnableOption
    mkIf
    types
    ;

  inherit (lib.${namespace}) mkOpt;

  cfg = config.${namespace}.theme.stylix;
in
{
  options.${namespace}.theme.stylix = {
    enable = mkEnableOption "stylix theme for applications";
    theme = mkOpt types.str "catppuccin-macchiato" "base16 theme file name";

    cursor = {
      name =
        mkOpt types.str "catppuccin-macchiato-lavender-cursors"
          "The name of the cursor theme to apply.";
      package = mkOpt types.package (pkgs.catppuccin-cursors.macchiatoLavender
      ) "The package to use for the cursor theme.";
      size = mkOpt types.int 22 "The size of the cursor.";
    };

    icon = {
      name = mkOpt types.str "Papirus-Dark" "The name of the icon theme to apply.";
      package = mkOpt types.package (pkgs.catppuccin-papirus-folders.override {
        accent = "lavender";
        flavor = "macchiato";
      }) "The package to use for the icon theme.";
    };
  };

  config = mkIf cfg.enable {
    stylix = {
      enable = true;
      # autoEnable = false;
      base16Scheme = "${pkgs.base16-schemes}/share/themes/${cfg.theme}.yaml";

      cursor = if (!config.${namespace}.theme.catppuccin.enable) then cfg.cursor else null;

      fonts = {
        sizes = {
          desktop = 11;
          applications = 12;
          terminal = 14;
          popups = 12;
        };

        serif = {
          package = pkgs.maple-mono.NF-CN;
          name = "Maple Mono NF CN";
        };
        sansSerif = {
          package = pkgs.maple-mono.NF-CN;
          name = "Maple Mono NF CN";
        };
        monospace = {
          package = pkgs.maple-mono.NF-CN;
          name = "Maple Mono NF CN";
        };
        emoji = {
          package = pkgs.noto-fonts-color-emoji;
          name = "Noto Color Emoji";
        };
      };

      iconTheme = lib.mkIf (!config.${namespace}.theme.catppuccin.enable) {
        enable = true;
        inherit (cfg.icon) package;
        dark = cfg.icon.name;
        light = cfg.icon.name;
      };

      polarity = "dark";

      opacity = {
        desktop = 1.0;
        applications = 0.90;
        terminal = 0.90;
        popups = 1.0;
      };

      targets = {
        # Set profile names for firefox
        firefox = {
          profileNames = [ config.${namespace}.user.name ];
          colorTheme.enable = true;
        };
        rofi.enable = !config.${namespace}.theme.catppuccin.enable;
        alacritty.enable = !config.${namespace}.theme.catppuccin.enable;
        bat.enable = !config.${namespace}.theme.catppuccin.enable;
        btop.enable = !config.${namespace}.theme.catppuccin.enable;
        cava.enable = !config.${namespace}.theme.catppuccin.enable;
        fish.enable = !config.${namespace}.theme.catppuccin.enable;
        foot.enable = !config.${namespace}.theme.catppuccin.enable;
        fzf.enable = !config.${namespace}.theme.catppuccin.enable;
        ghostty.enable = !config.${namespace}.theme.catppuccin.enable;
        gitui.enable = !config.${namespace}.theme.catppuccin.enable;
        helix.enable = !config.${namespace}.theme.catppuccin.enable;
        k9s.enable = !config.${namespace}.theme.catppuccin.enable;
        lazygit.enable = !config.${namespace}.theme.catppuccin.enable;
        ncspot.enable = !config.${namespace}.theme.catppuccin.enable;
        neovim.enable = !config.${namespace}.theme.catppuccin.enable;
        tmux.enable = !config.${namespace}.theme.catppuccin.enable;
        vesktop.enable = !config.${namespace}.theme.catppuccin.enable;
        yazi.enable = !config.${namespace}.theme.catppuccin.enable;
        zathura.enable = !config.${namespace}.theme.catppuccin.enable;
        zellij.enable = !config.${namespace}.theme.catppuccin.enable;
        gnome.enable = !config.${namespace}.theme.catppuccin.enable;
        vscode.enable = false;
        gtk.enable = false;
        hyprlock.useWallpaper = false;
        hyprlock.enable = false;
        waybar.enable = false;
      };
    };
  };
}
