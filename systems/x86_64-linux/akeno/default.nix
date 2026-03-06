{ config, lib, ... }:
let
  inherit (lib.wktlnix) enabled;
in
{
  imports = [ ./hardware.nix ];

  wktlnix = {
    system = {
      boot = enabled;
      disko = {
        enable = true;
        device = "/dev/vda";
      };
      fonts = enabled;
      locale = {
        enable = true;
      };
      time = enabled;
      persist = enabled;
    };

    hardware = {
      btrfs = enabled;
    };

    programs = {
      terminal.tools.nix-ld = enabled;
    };

    suites = {
      common = enabled;
    };

    services = {
      openssh = enabled;
    };

    security = {
      sudo-rs = enabled;
    };
  };

  networking = {
    interfaces."eth0" = {
      ipv4.addresses = [
        {
          address = "151.241.128.81";
          prefixLength = 24;
        }
      ];
    };

    defaultGateway = {
      address = "151.241.128.254";
      interface = "eth0";
    };
  };

  systemd.network.links."10-eth0" = {
    matchConfig.PermanentMACAddress = "10:40:69:00:07:ee";
    linkConfig = {
      Name = "eth0";
      # 保留 enp0s17 和 ens17 作为备用名称
      AlternativeName = "enp0s17 ens17";
    };
  };

  # This value determines the NixOS release from which the default
  # settings for stateful data, like file locations and database versions
  # on your system were taken. It‘s perfectly fine and recommended to leave
  # this value at the release version of the first install of this system.
  # Before changing this value read the documentation for this option
  # (e.g. man configuration.nix or on https://nixos.org/nixos/options.html).
  system.stateVersion = "24.05"; # Did you read the comment?
}
