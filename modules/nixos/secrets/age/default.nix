{
  config,
  lib,
  inputs,
  pkgs,
  namespace,
  ...
}: let
  inherit (lib) mkIf;
  inherit (lib.${namespace}) mkBoolOpt mkOpt;

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
      "nextcloud.pwd" = {
        file = lib.snowfall.fs.get-file "secrets/service/nextcloud.age";
        mode = "0440";
        owner = config.${namespace}.user.name;
      };
    };
  };
}