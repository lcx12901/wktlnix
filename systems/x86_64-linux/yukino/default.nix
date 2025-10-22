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
        device = "/dev/nvme0n1";
      };
      fonts = enabled;
      locale = {
        enable = true;
      };
      time = enabled;
      persist = enabled;
      networking = enabled;
    };

    hardware = {
      audio = enabled;
      graphics = enabled;
      cpu.intel = enabled;
      gpu.amd = enabled;
      btrfs = enabled;
    };

    programs = {
      graphical = {
        wms.niri = enabled;
        file-managers.nautilus = enabled;
      };
      terminal.tools.nix-ld = enabled;
    };

    suites = {
      common = enabled;
    };

    services = {
      dae = enabled;
      openssh = enabled;
      sing-box = {
        enable = true;
        configFile = config.sops.secrets."yukino_sing".path;
      };
      frp = {
        enable = true;
        role = "client";
      };
      clamav = enabled;
    };

    security = {
      sudo-rs = enabled;
    };

    virtualisation.kvm = enabled;
  };

  networking = {
    firewall = {
      allowedTCPPortRanges = [
        {
          from = 8033;
          to = 8039;
        }
        {
          from = 9000;
          to = 9001;
        }
      ];
    };

    extraHosts = ''
      127.0.0.1 t3.z9soft.cn
    '';
  };

  sops.secrets."yukino_sing" = { };

  # This value determines the NixOS release from which the default
  # settings for stateful data, like file locations and database versions
  # on your system were taken. It‘s perfectly fine and recommended to leave
  # this value at the release version of the first install of this system.
  # Before changing this value read the documentation for this option
  # (e.g. man configuration.nix or on https://nixos.org/nixos/options.html).
  system.stateVersion = "24.05"; # Did you read the comment?
}
