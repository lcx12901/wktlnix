{
  config,
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
      cpu.amd = enabled;
      gpu.amd = enabled;
      btrfs = enabled;
    };

    programs = {
      terminal.tools.nix-ld = enabled;
    };

    suites = {
      common = enabled;
    };

    services = {
      dae = enabled;
      openssh = enabled;
      avahi = enabled;
      inadyn = {
        enable = true;
        configFile = config.sops.secrets."cf-hiyori-inadyn".path;
      };
    };

    security = {
      sudo-rs = enabled;
      acme = enabled;
    };
  };

  sops.secrets."cf-hiyori-inadyn" = {
    inherit (config.services.inadyn) group;
    owner = config.services.inadyn.user;
  };

  # This value determines the NixOS release from which the default
  # settings for stateful data, like file locations and database versions
  # on your system were taken. It‘s perfectly fine and recommended to leave
  # this value at the release version of the first install of this system.
  # Before changing this value read the documentation for this option
  # (e.g. man configuration.nix or on https://nixos.org/nixos/options.html).
  system.stateVersion = "24.05"; # Did you read the comment?
}
