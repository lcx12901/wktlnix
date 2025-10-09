{
  inputs,
  config,
  lib,
  pkgs,
  ...
}:
let
  inherit (lib) mkIf mkEnableOption;

  cfg = config.wktlnix.services.aria2;

  domain = "${config.networking.hostName}.lincx.top";
in
{
  options.wktlnix.services.aria2 = {
    enable = mkEnableOption "Whether or not to configure aria2.";
  };

  config = mkIf cfg.enable {
    wktlnix.user.extraGroups = [ "aria2" ];

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
          enable-peer-exchange = true;
          bt-max-peers = 128;
          bt-request-peer-speed-limit = "10M";
          seed-time = 30;
          bt-tracker-connect-timeout = 10;
          bt-tracker-timeout = 10;
          bt-prioritize-piece = "head=32M,tail=32M";
          bt-save-metadata = true;
          bt-load-saved-metadata = true;
          bt-remove-unselected-file = true;
          bt-force-encryption = true;
          bt-detach-seed-only = true;
          user-agent = "Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/93.0.4577.63 Safari/537.36 Edg/93.0.961.47";
          bt-tracker = builtins.readFile "${inputs.bt-tracker}/all_aria2.txt";
        };
      };

      nginx.virtualHosts."ariang.${domain}" = {
        root = "${pkgs.ariang}/share/ariang";

        locations."/jsonrpc" = {
          proxyPass = "http://localhost:${builtins.toString config.services.aria2.settings.rpc-listen-port}";
        };
      };
    };

    networking.firewall = {
      allowedTCPPortRanges = [
        {
          from = 6881;
          to = 6999;
        }
      ];
      allowedUDPPortRanges = [
        {
          from = 6881;
          to = 6999;
        }
      ];
    };

    environment.persistence."/persist" = {
      hideMounts = true;

      directories = [
        "/var/lib/aria2"
      ];
    };

    sops.secrets = {
      "aria2_rpc_token" = { };
    };
  };
}
