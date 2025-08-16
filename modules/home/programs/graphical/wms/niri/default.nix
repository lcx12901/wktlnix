{
  inputs,
  osConfig,
  config,
  lib,
  namespace,
  ...
}@args:
let
  inherit (lib.${namespace}) mkBoolOpt mkOpt enabled;
  inherit (lib) mkIf;

  niri = osConfig.programs.niri.package;

  cfg = config.${namespace}.programs.graphical.wms.niri;

  bind = import ./modules/bind.nix args;
  startup = import ./modules/startup.nix (
    args
    // {
      inherit (cfg) DISPLAY;
    }
  );
  window-rule = import ./modules/window-rule.nix { inherit inputs; };
in
{
  options.${namespace}.programs.graphical.wms.niri = {
    enable = mkBoolOpt false "Whether or not to enable niri.";
    extraConfig =
      mkOpt inputs.niri.lib.kdl.types.kdl-document [ ]
        "extra configuration for niri, in KDL format.";
    DISPLAY = mkOpt lib.types.str ":1" "the display to use for niri.";
  };

  config = mkIf cfg.enable {
    programs.niri = {
      package = niri;

      config =
        (lib.toList bind)
        ++ (lib.toList startup)
        ++ (lib.toList window-rule)
        ++ (lib.toList cfg.extraConfig);
    };

    wktlnix = {
      programs = {
        terminal = {
          emulators = {
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
    };

    systemd.user.services.cliphist = {
      Unit = {
        ConditionEnvironment = [
          "WAYLAND_DISPLAY"
        ];
      };
    };
  };
}
