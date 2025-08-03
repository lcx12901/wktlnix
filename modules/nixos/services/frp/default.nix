{
  config,
  lib,
  namespace,
  ...
}:
let
  inherit (lib) types;
  inherit (lib.${namespace}) mkOpt;

  cfg = config.${namespace}.services.frp;

  isClient = cfg.role == "client";
  executableFile = if isClient then "frpc" else "frps";

  configName = "frp_${config.networking.hostName}";
in
{
  options.${namespace}.services.frp = {
    enable = lib.mkEnableOption "frp";
    role = mkOpt (types.enum [
      "server"
      "client"
    ]) "server" "The frp consists of `client` and `server`";
  };

  config = lib.mkIf cfg.enable {
    services.frp = {
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
      sopsFile = lib.snowfall.fs.get-file "secrets/frp.yaml";
    };
  };
}
