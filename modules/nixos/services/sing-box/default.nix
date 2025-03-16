{
  config,
  lib,
  pkgs,
  namespace,
  ...
}:
let
  inherit (lib) types;
  inherit (lib.${namespace}) mkBoolOpt mkOpt;

  cfg = config.${namespace}.services.sing-box;
in
{
  disabledModules = [ "services/networking/sing-box.nix" ];

  options.${namespace}.services.sing-box = {
    enable = mkBoolOpt false "Whether or not to enable sing-box.";
    package = mkOpt types.package pkgs.sing-box "default package";
    configFile = mkOpt types.path "" "path to singularity config";
  };

  config = lib.mkIf cfg.enable {
    systemd.services.sing-box = {
      wantedBy = [ "multi-user.target" ];
      after = [ "network-online.target" ];
      wants = [ "network-online.target" ];
      description = "sing-box Daemon";
      serviceConfig = {
        DynamicUser = true;
        ExecStart = [
          ""
          "${lib.getExe cfg.package} run -c $\{CREDENTIALS_DIRECTORY}/config.json -D $\{STATE_DIRECTORY}"
        ];
        LoadCredential = [ "config.json:${cfg.configFile}" ];
        StateDirectory = "sing-server";
        StateDirectoryMode = "0700";
        CapabilityBoundingSet = [ "CAP_NET_BIND_SERVICE" ];
        AmbientCapabilities = [ "CAP_NET_BIND_SERVICE" ];
        UMask = "0077";
        Restart = "on-failure";
      };
    };
  };
}
