{
  config,
  lib,
  namespace,
  ...
}: let
  inherit (lib) mkIf optionalString;
  inherit (lib.${namespace}) mkBoolOpt;

  hasOptinPersistence = config.${namespace}.system.persist.enable;

  volumesRoot = "${optionalString hasOptinPersistence "/persist"}/var/lib/containers/persist_data";

  cfg = config.${namespace}.virtualisation.containers;
in {
  options.${namespace}.virtualisation.containers = {
    enable = mkBoolOpt false "Whether or not to enable containers.";
  };

  config = mkIf cfg.enable {
    virtualisation.oci-containers.containers = {
      ddns-go = {
        image = "jeessy/ddns-go:latest";
        autoStart = true;
        volumes = ["${volumesRoot}/ddns-go:/root"];
        extraOptions = ["--network=host" "--pull=newer"];
      };
    };

    networking.firewall.allowedTCPPorts = [9876];
  };
}
