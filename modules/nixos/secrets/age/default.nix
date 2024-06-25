{
  config,
  lib,
  inputs,
  pkgs,
  namespace,
  ...
}: let
  inherit (lib) mkIf;
  inherit (lib.${namespace}) mkBoolOpt;

  cfg = config.${namespace}.secrets.age;
  hasOptinPersistence = config.${namespace}.system.persist.enable;
in {
  options.${namespace}.secrets.age = {
    enable = mkBoolOpt true "Whether or not to enable agenix.";
  };

  config = mkIf cfg.enable {
    environment.systemPackages = [
      inputs.agenix.packages."${pkgs.system}".default
    ];

    age.identityPaths = [
      "${lib.optionalString hasOptinPersistence "/persist"}/etc/ssh/ssh_host_ed25519_key"
    ];

    age.secrets = {
      "config.dae" = {
        file = lib.snowfall.fs.get-file "secrets/service/dae.age";
        mode = "0440";
        owner = "root";
      };
    };
  };
}
