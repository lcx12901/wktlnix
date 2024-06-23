{
  lib,
  namespace,
  ...
}: let
  inherit (lib.${namespace}) enabled;
in {
  imports = [./hardware.nix];

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
    };

    hardware = {
      audio = enabled;
      graphics = enabled;
      cpu.intel = enabled;
      btrfs = enabled;
    };

    programs = {
      graphical = {
        wms = {
          hyprland = enabled;
        };
        addons.xdg-portal = enabled;
        file-managers.nautilus = enabled;
      };
      terminal.tools.nix-ld = enabled;
    };

    suites = {
      common = enabled;
      wlroots = enabled;
    };

    services.dae = enabled;

    virtualisation.kvm = {
      enable = true;
      platform = "intel";
    };
  };

  networking.firewall.allowedTCPPortRanges = [
    {
      from = 8033;
      to = 8039;
    }
  ];

  networking.extraHosts = ''
    127.0.0.1 t3.z9soft.cn
  '';

  # This value determines the NixOS release from which the default
  # settings for stateful data, like file locations and database versions
  # on your system were taken. It‘s perfectly fine and recommended to leave
  # this value at the release version of the first install of this system.
  # Before changing this value read the documentation for this option
  # (e.g. man configuration.nix or on https://nixos.org/nixos/options.html).
  system.stateVersion = "24.05"; # Did you read the comment?
}
