{ config, lib, ... }:
let
  inherit (lib) mkIf mkEnableOption;
  inherit (lib.types) enum;
  inherit (lib.wktlnix) mkOpt;

  cfg = config.wktlnix.services.frp;

  isClient = cfg.role == "client";
  executableFile = if isClient then "frpc" else "frps";

  configName = "frp_${config.networking.hostName}";
in
{
  options.wktlnix.services.frp = {
    enable = mkEnableOption "frp";
    role = mkOpt (enum [
      "server"
      "client"
    ]) "server" "The frp consists of `client` and `server`";
  };

  config = mkIf cfg.enable {
    services.frp.instances."" = {
      inherit (cfg) enable role;
    };

    systemd.services = {
      frp = {
        serviceConfig = {
          LoadCredential = [ "config.toml:${config.sops.secrets."${configName}".path}" ];
          ExecStart = lib.mkForce "${config.services.frp.package}/bin/${executableFile} --strict_config -c \${CREDENTIALS_DIRECTORY}/config.toml";
        };
      };
    };

    sops.secrets."${configName}" = {
      sopsFile = lib.file.get-file "secrets/frp.yaml";
    };
  };
}
