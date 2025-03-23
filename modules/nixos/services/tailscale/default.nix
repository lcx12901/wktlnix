{
  config,
  lib,
  pkgs,
  namespace,
  ...
}:
let
  inherit (lib) mkIf;

  cfg = config.${namespace}.services.tailscale;
in
{
  options.${namespace}.services.tailscale = {
    enable = lib.mkEnableOption "Tailscale";
  };

  config = mkIf cfg.enable {
    boot.kernel.sysctl = {
      "net.ipv4.ip_forward" = true;
      "net.ipv6.conf.all.forwarding" = true;
    };

    environment.systemPackages = with pkgs; [
      tailscale
      tailscale-systray
    ];

    networking = {
      firewall = {
        allowedUDPPorts = [ config.services.tailscale.port ];
        allowedTCPPorts = [ 5900 ];
        checkReversePath = "loose";
      };
    };

    services.tailscale = {
      enable = true;
      permitCertUid = "root";
      useRoutingFeatures = "both";
      authKeyFile = config.sops.secrets."tailscale_key".path;
      interfaceName = "userspace-networking";
      extraDaemonFlags = [ "--socks5-server=localhost:1099" ];
    };

    environment.persistence."/persist" = {
      hideMounts = true;

      directories = [ "/var/lib/tailscale" ];

    };

    sops.secrets."tailscale_key" = { };
  };
}
