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
in {
  options.${namespace}.secrets.age = {
    enable = mkBoolOpt true "Whether or not to enable agenix.";
  };

  config = mkIf cfg.enable {
    environment.systemPackages = [
      inputs.agenix.packages."${pkgs.system}".default
    ];

    age.identityPaths = [
      "/etc/ssh/ssh_host_ed25519_key"
    ];

    age.secrets = {
      "mihomo.conf" = {
        file = lib.snowfall.fs.get-file "secrets/service/mihomo.age";
        mode = "0440";
        owner = "root";
      };
    };
  };
}