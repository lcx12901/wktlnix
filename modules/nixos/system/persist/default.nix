{
  config,
  lib,
  namespace,
  ...
}: let
  inherit (lib) mkIf;
  inherit (lib.${namespace}) mkBoolOpt;

  cfg = config.${namespace}.system.persist;
in {
  options.${namespace}.system.persist = {
    enable = mkBoolOpt false "Whether or not to enable impermanence.";
  };

  config = mkIf cfg.enable {
    environment.persistence."/persist" = {
      hideMounts = true;

      directories = [
        "/etc/ssh"
      ];
    };
  };
}