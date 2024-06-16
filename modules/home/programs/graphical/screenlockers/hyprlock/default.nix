{
  config,
  inputs,
  lib,
  osConfig,
  system,
  namespace,
  ...
}: let
  inherit (lib) mkIf;
  inherit (lib.${namespace}) mkBoolOpt;
  inherit (inputs) hyprlock wallpapers;

  cfg = config.${namespace}.programs.graphical.screenlockers.hyprlock;
in {
  options.${namespace}.programs.graphical.screenlockers.hyprlock = {
    enable = mkBoolOpt false "Whether to enable hyprlock in the desktop environment.";
  };

  config = mkIf cfg.enable {
    programs.hyprlock = {
      enable = true;
      package = hyprlock.packages.${system}.hyprlock;

      settings = {
        background = {
          monitor = "";
          path = "${wallpapers}/katana.png";
          color = "rgba(25, 20, 20, 1.0)";
          blur_passes = 3;
          contrast = 0.8916;
          brightness = 0.8172;
          vibrancy = 0.1696;
          vibrancy_darkness = 0.0;
        };

        general = {
          no_fade_in = false;
          grace = 0;
          disable_loading_bar = true;
          hide_cursor = true;
        };

        input-field = {
          monitor = "";
          size = "250, 60";
          outline_thickness = 2;
          dots_size = 0.2; # Scale of input-field height, 0.2 - 0.8
          dots_spacing = 0.2; # Scale of dots' absolute size, 0.0 - 1.0
          dots_center = true;
          outer_color = "rgba(0, 0, 0, 0)";
          inner_color = "rgba(0, 0, 0, 0.5)";
          font_color = "rgb(200, 200, 200)";
          fade_on_empty = false;
          placeholder_text = "<span foreground=\"##cad3f5\">Password...</span>";
          hide_input = false;
          position = "0, -120";
          halign = "center";
          valign = "center";
        };

        label = [
          {
            monitor = "";
            text = "<span font_weight=\"ultrabold\">$TIME</span>";
            color = "rgba(0, 0, 0, 0.5)";
            font_size = 120;
            font_family = osConfig.${namespace}.system.fonts.default;
            position = "0, -300";
            halign = "center";
            valign = "top";
          }
          {
            monitor = "";
            text = "<span font_weight=\"bold\">Hi, $USER</span>";
            color = "rgba(0, 0, 0, 0.5)";
            font_size = 25;
            font_family = osConfig.${namespace}.system.fonts.default;
            position = "0, -40";
            halign = "center";
            valign = "center";
          }
        ];
      };
    };
  };
}
