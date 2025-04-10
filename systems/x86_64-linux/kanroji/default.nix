{
  lib,
  namespace,
  ...
}:
let
  inherit (lib.${namespace}) enabled;
in
{
  imports = [ ./hardware.nix ];

  wktlnix = {
    system = {
      boot = enabled;
      disko = {
        enable = true;
        device = "/dev/nvme0n1";
        rootSize = "1T";
      };
      fonts = enabled;
      locale = {
        enable = true;
      };
      time = enabled;
      persist = enabled;
      networking = {
        enable = true;
        wireless = true;
      };
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
        games = {
          steam = enabled;
          gamemode = enabled;
        };
        file-managers.nautilus = enabled;
        browsers.zen = enabled;
      };
      terminal.tools.nix-ld = enabled;
    };

    suites = {
      common = enabled;
      wlroots = enabled;
    };

    services = {
      dae = enabled;
      openssh = enabled;
      avahi = enabled;
    };

    security = {
      sudo-rs = enabled;
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
