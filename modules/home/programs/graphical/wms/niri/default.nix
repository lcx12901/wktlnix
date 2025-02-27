{
  inputs,
  config,
  lib,
  system,
  pkgs,
  namespace,
  ...
}:
let
  inherit (lib.${namespace}) mkBoolOpt enabled;
  inherit (lib) mkIf getExe getExe';
  inherit (inputs) nixpkgs-wayland;

  wl-paste = getExe' nixpkgs-wayland.packages.${system}.wl-clipboard "wl-paste";
  wl-clip-persist = getExe pkgs.wl-clip-persist;

  cfg = config.${namespace}.programs.graphical.wms.niri;
in
{
  options.${namespace}.programs.graphical.wms.niri = {
    enable = mkBoolOpt false "Whether or not to enable niri.";
  };

  imports = lib.snowfall.fs.get-non-default-nix-files ./.;

  config = mkIf cfg.enable {
    home.packages = with pkgs; [
      swww
      xwayland-satellite
    ];

    programs.niri.settings = {
      environment = {
        GDK_BACKEND = "wayland,x11";
        GSK_RENDERER = "gl";
        NIXOS_OZONE_WL = "1";
        DISPLAY = ":1";
        MOZ_ENABLE_WAYLAND = "1";
        # use wayland as the default backend, fallback to xcb if wayland is not available
        QT_QPA_PLATFORM = "wayland;xcb";
        QT_WAYLAND_DISABLE_WINDOWDECORATION = "1";
        XDG_CURRENT_DESKTOP = "niri";
        XDG_SESSION_TYPE = "wayland";
      };

      outputs = {
        "DP-1" = {
          mode = {
            width = 2560;
            height = 1440;
            refresh = 164.998;
          };
          variable-refresh-rate = true;
        };
        "HDMI-A-1" = {
          mode = {
            width = 1920;
            height = 1080;
            refresh = 100.000;
          };
        };
      };

      spawn-at-startup = [
        {
          command = [
            "xwayland-satellite"
            ":1"
          ];
        }
        {
          command = [
            "fcitx5"
            "-dr"
          ];
        }
        {
          command = [ "${pkgs.swww}/bin/swww-daemon" ];
        }
        {
          command = [
            "swww"
            "img"
            "${inputs.wallpapers}/Hoshino-eye.jpg"
          ];
        }
        {
          command = [
            "${wl-paste}"
            "--type"
            "image"
            "--watch"
            "cliphist"
            "store"
          ];
        }
        {
          command = [
            "${wl-paste}"
            "--type"
            "text"
            "--watch"
            "cliphist"
            "store"
          ];
        }
        {
          command = [
            "${wl-clip-persist}"
            "--clipboard"
            "both"
          ];
        }
      ];

      layout = {
        default-column-width.proportion = 2.0 / 3.0;
        preset-column-widths = [
          { proportion = 1.0 / 3.0; }
          { proportion = 2.0 / 3.0; }
          { proportion = 1.0 / 1.0; }
        ];

        gaps = 10;

        focus-ring = {
          enable = true;
          width = 3;
          active.color = "#ca9ee6";
          inactive.color = "#babbf1";
        };

        border = {
          enable = false;
          width = 4;
          active.color = "#e78284";
          inactive.color = "#babbf1";
        };
      };

      prefer-no-csd = true;
      hotkey-overlay.skip-at-startup = true;

      input = {
        focus-follows-mouse = {
          enable = true;
          max-scroll-amount = "0%";
        };
        warp-mouse-to-focus = true;
      };

      window-rules = [
        {
          geometry-corner-radius = {
            top-left = 10.0;
            top-right = 10.0;
            bottom-left = 10.0;
            bottom-right = 10.0;
          };
          clip-to-geometry = true;
        }
        {
          draw-border-with-background = false;
        }
        {
          matches = [
            { app-id = "^org\.gnome\.Nautilus$"; }
            {
              app-id = "^Bytedance-feishu$";
              title = "图片";
            }
          ];
          open-floating = true;
        }
        {
          matches = [
            { app-id = "^com\.mitchellh\.ghostty$"; }
            { app-id = "neovide"; }
          ];
          opacity = 0.9;
        }
      ];

      animations = {
        enable = true;
        # https://github.com/sodiboo/system/blob/main/niri.mod.nix#L312
        shaders.window-resize = ''
          vec4 resize_color(vec3 coords_curr_geo, vec3 size_curr_geo) {
            vec3 coords_next_geo = niri_curr_geo_to_next_geo * coords_curr_geo;

            vec3 coords_stretch = niri_geo_to_tex_next * coords_curr_geo;
            vec3 coords_crop = niri_geo_to_tex_next * coords_next_geo;

            // We can crop if the current window size is smaller than the next window
            // size. One way to tell is by comparing to 1.0 the X and Y scaling
            // coefficients in the current-to-next transformation matrix.
            bool can_crop_by_x = niri_curr_geo_to_next_geo[0][0] <= 1.0;
            bool can_crop_by_y = niri_curr_geo_to_next_geo[1][1] <= 1.0;

            vec3 coords = coords_stretch;
            if (can_crop_by_x)
              coords.x = coords_crop.x;
            if (can_crop_by_y)
              coords.y = coords_crop.y;

            vec4 color = texture2D(niri_tex_next, coords.st);

            // However, when we crop, we also want to crop out anything outside the
            // current geometry. This is because the area of the shader is unspecified
            // and usually bigger than the current geometry, so if we don't fill pixels
            // outside with transparency, the texture will leak out.
            //
            // When stretching, this is not an issue because the area outside will
            // correspond to client-side decoration shadows, which are already supposed
            // to be outside.
            if (can_crop_by_x && (coords_curr_geo.x < 0.0 || 1.0 < coords_curr_geo.x))
              color = vec4(0.0);
            if (can_crop_by_y && (coords_curr_geo.y < 0.0 || 1.0 < coords_curr_geo.y))
              color = vec4(0.0);

            return color;
          }
        '';
      };
    };

    wktlnix = {
      programs = {
        terminal = {
          emulators = {
            ghostty = enabled;
            kitty = enabled;
          };
          tools.cava = enabled;
        };
        graphical = {
          screenlockers.hyprlock = enabled;
          addons = {
            fcitx5 = enabled;
            mako = enabled;
            waybar = enabled;
          };
          launchers.rofi = enabled;
        };
      };

      services = {
        cliphist = {
          enable = true;
          systemdTargets = [ "niri.service" ];
        };
      };

      theme = {
        gtk = enabled;
        catppuccin = enabled;
      };
    };

    systemd.user.services.cliphist = {
      Unit = {
        ConditionEnvironment = [
          "WAYLAND_DISPLAY"
        ];
        After = "niri.service";
      };
    };
  };
}
