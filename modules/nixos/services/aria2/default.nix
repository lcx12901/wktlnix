{
  config,
  lib,
  pkgs,
  namespace,
  ...
}: let
  cfg = config.${namespace}.services.aria2;
in {
  options.${namespace}.services.aria2 = {
    enable = lib.${namespace}.mkBoolOpt false "Whether or not to configure aria2.";
  };

  config = lib.mkIf cfg.enable {
    services.aria2 = {
      enable = true;
      rpcSecretFile = config.age.secrets."aria2-rpc-token.text".path;
      extraArguments = lib.concatStringsSep " " [
        "--enable-dht6"
      ];
    };
    systemd.services.aria2.serviceConfig.ExecStartPre = [
      "${pkgs.coreutils}/bin/touch /var/lib/aria2/dht.dat"
      "${pkgs.coreutils}/bin/touch /var/lib/aria2/dht6.dat"
    ];
  };
}
