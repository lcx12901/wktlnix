{
  osConfig,
  config,
  lib,
  ...
}:
let
  inherit (lib) mkIf mkEnableOption kdl;
  inherit (lib.wktlnix) mkOpt enabled;

  niri = osConfig.programs.niri.package;

  cfg = config.wktlnix.programs.graphical.wms.niri;
in
{
  imports = [
    ./modules/bind.nix
    ./modules/startup.nix
    ./modules/window-rule.nix
  ];

  options.wktlnix.programs.graphical.wms.niri = {
    enable = mkEnableOption "Whether or not to enable niri.";
    extraConfig = mkOpt kdl.types.kdl-document [ ] "extra configuration for niri, in KDL format.";
  };

  config = mkIf cfg.enable {
    programs.niri = {
      package = niri;

      config = cfg.extraConfig;
    };

    wktlnix = {
      programs = {
        terminal = {
          emulators.ghostty = enabled;
          tools.zellij = enabled;
        };
        graphical = {
          launchers.vicinae = enabled;
          screenlockers.hyprlock = enabled;
          browsers.zen = enabled;
          bars.noctalia = enabled;

          addons = {
            fcitx5 = enabled;
          };
        };
      };

      services = {
        cliphist = {
          enable = true;
          systemdTargets = [ "niri.service" ];
        };
        flameshot = enabled;
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
