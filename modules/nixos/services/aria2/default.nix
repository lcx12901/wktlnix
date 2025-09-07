{
  inputs,
  config,
  lib,
  pkgs,
  namespace,
  ...
}:
let
  cfg = config.${namespace}.services.aria2;

  # domain = "${config.networking.hostName}.lincx.top";
in
{
  options.${namespace}.services.aria2 = {
    enable = lib.${namespace}.mkBoolOpt false "Whether or not to configure aria2.";
  };

  config = lib.mkIf cfg.enable {
    environment.systemPackages = [ pkgs.ariang ];
    services = {
      aria2 = {
        enable = true;
        openPorts = true;
        rpcSecretFile = config.sops.secrets."aria2_rpc_token".path;
        settings = {
          # file setting
          disk-cache = "64M";
          file-allocation = "falloc";
          no-file-allocation-limit = "64M";
          continue = true;
          always-resume = true;
          max-resume-failure-tries = 0;
          remote-time = true;

          # speed setting
          input-file = "/var/lib/aria2/aria2.session";
          save-session-interval = 1;
          auto-save-interval = 20;
          force-save = false;

          # download setting
          max-file-not-found = 10;
          max-tries = 0;
          retry-wait = 10;
          connect-timeout = 10;
          timeout = 10;
          max-connection-per-server = 16;
          split = 64;
          min-split-size = "4M";
          allow-piece-length-change = true;
          http-accept-gzip = true;
          reuse-uri = false;
          no-netrc = true;

          # BT setting
          enable-dht6 = true;
          dht-file-path = "/var/lib/aria2/dht.dat";
          dht-file-path6 = "/var/lib/aria2/dht6.dat";
          dht-entry-point = "dht.transmissionbt.com:6881";
          dht-entry-point6 = "dht.transmissionbt.com:6881";
          bt-enable-lpd = true;
          bt-max-peers = 128;
          bt-request-peer-speed-limit = "10M";
          seed-time = 0;
          bt-tracker-connect-timeout = 10;
          bt-tracker-timeout = 10;
          bt-save-metadata = true;
          bt-load-saved-metadata = true;
          bt-remove-unselected-file = true;
          bt-force-encryption = true;
          bt-detach-seed-only = true;
          user-agent = "Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/93.0.4577.63 Safari/537.36 Edg/93.0.961.47";
          bt-tracker = builtins.readFile "${inputs.bt-tracker}/all_aria2.txt";
        };
      };

      # nginx.virtualHosts."ariang.${domain}" = { };
    };

    systemd.services.aria2.serviceConfig.ExecStartPre = [
      "${pkgs.coreutils}/bin/touch /var/lib/aria2/dht.dat"
      "${pkgs.coreutils}/bin/touch /var/lib/aria2/dht6.dat"
    ];

    sops.secrets = {
      "aria2_rpc_token" = { };
    };
  };
}
