{
  config,
  lib,
  pkgs,
  ...
}:
let
  inherit (lib)
    mkIf
    mkEnableOption
    getExe
    ;

  cfg = config.wktlnix.services.metapi;

  domain = "${config.networking.hostName}.lincx.top";

  homeDir = "/var/lib/metapi";

  PORT = toString 4000;
in
{
  options.wktlnix.services.metapi = {
    enable = mkEnableOption "metapi service";
  };

  config = mkIf cfg.enable {
    users.groups.metapi.gid = 1001;

    users.users.metapi = {
      isNormalUser = true;
      group = "metapi";
      uid = 1001;
      description = "metapi user";
      home = homeDir;
      createHome = false;
    };

     systemd.tmpfiles.rules = [
      "d '${homeDir}' 0770 metapi metapi - -"
    ];

    systemd.services.metapi = {
      wantedBy = [ "multi-user.target" ];
      after = [ "network-online.target" ];
      wants = [ "network-online.target" ];
      description = "metapi Daemon";

      environment = {
        inherit PORT;
        HOST = "0.0.0.0";
        DATA_DIR = homeDir;
      };

      serviceConfig = {
        User = "metapi";
        Group = "metapi";
        ExecStart = [ "${getExe pkgs.wktlnix.metapi}" ];
        Restart = "on-failure";
        RestartSec = "5s";
        EnvironmentFile = config.sops.secrets."metapi_env".path;
      };
    };

    services.nginx.virtualHosts = mkIf config.wktlnix.services.nginx.enable {
      "metapi.${domain}" = {
        locations."/" = {
          proxyPass = "http://127.0.0.1:${PORT}";
          proxyWebsockets = true;
        };
      };
    };

    environment.persistence."/persist" = {
      hideMounts = true;
      directories = [ homeDir ];
    };

    sops.secrets = {
      "metapi_env" = { };
    };
  };
}
