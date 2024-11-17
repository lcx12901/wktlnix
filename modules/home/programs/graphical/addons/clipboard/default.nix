{
  config,
  lib,
  pkgs,
  namespace,
  ...
}:
let
  inherit (lib) mkIf getExe;
  inherit (lib.${namespace}) mkBoolOpt;

  cfg = config.${namespace}.programs.graphical.addons.clipboard;
in
{
  options.${namespace}.programs.graphical.addons.clipboard = {
    enable = mkBoolOpt false "Whether to enable clipboard service.";
  };

  config = mkIf cfg.enable {
    systemd.user.services = {
      cliphist = {
        Unit = {
          Description = "Clipboard history service";
          PartOf = [ "graphical-session.target" ];
          After = [ "graphical-session.target" ];
        };

        Install.WantedBy = [ "graphical-session.target" ];

        Service = {
          ExecStart = "${pkgs.wl-clipboard}/bin/wl-paste --type text --watch ${getExe pkgs.cliphist} store";
          Restart = "always";
        };
      };

      wl-clip-persist = {
        Unit = {
          Description = "Persistent clipboard for Wayland";
          PartOf = [ "graphical-session.target" ];
          After = [ "graphical-session.target" ];
        };

        Install.WantedBy = [ "graphical-session.target" ];

        Service = {
          ExecStart = "${getExe pkgs.wl-clip-persist} --clipboard both";
          Restart = "always";
        };
      };
    };
  };
}
