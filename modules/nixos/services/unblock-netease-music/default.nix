{
  config,
  lib,
  pkgs,
  ...
}:
let
  inherit (lib) mkIf mkEnableOption getExe;

  cfg = config.wktlnix.services.unblock-netease-music;
in
{
  options.wktlnix.services.unblock-netease-music = {
    enable = mkEnableOption "unblock-netease-music service";
  };

  config = mkIf cfg.enable {
    networking.firewall = {
      allowedTCPPorts = [
        9927
      ];
    };

    systemd.services.unblock-netease-music-server = {
      wantedBy = [ "multi-user.target" ];
      after = [ "network-online.target" ];
      wants = [ "network-online.target" ];
      description = "unblock-netease-music Daemon";
      serviceConfig = {
        DynamicUser = true;
        ExecStart = [
          "${getExe pkgs.nodejs} --env-file=$\{CREDENTIALS_DIRECTORY}/.env ${pkgs.wktlnix.unblock-netease-music-server}/app/app.js -p 9927:9928 -o qq"
        ];
        LoadCredential = [ ".env:${config.sops.templates.".env".path}" ];
        StateDirectory = "unblock-netease-music-server";
        StateDirectoryMode = "0700";
        UMask = "0077";
        Restart = "on-failure";
      };
    };

    sops.secrets.qq_cookies = { };

    sops.templates.".env".content = ''
      ENABLE_LOCAL_VIP=svip
      ENABLE_FLAC=true
      DISABLE_UPGRADE_CHECK=true
      SELECT_MAX_BR=true
      SIGN_CERT="${./server.crt}"
      SIGN_KEY="${./server.key}"
      QQ_COOKIE=${config.sops.placeholder.qq_cookies}
    '';
  };
}
