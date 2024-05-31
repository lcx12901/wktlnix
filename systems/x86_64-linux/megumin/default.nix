{
  lib,
  namespace,
  ...
}: let
  inherit (lib.${namespace}) enabled;
in {
  imports = [./hardware.nix];

  wktlnix = {
    archetypes = {
      wsl = enabled;
    };

    system = {
      fonts = enabled;
      locale = enabled;
      time = enabled;
    };

    programs = {
      terminal.tools.nix-ld = enabled;
    };

    suites.common = enabled;

    services.mihomo = enabled;
  };

  # This value determines the NixOS release from which the default
  # settings for stateful data, like file locations and database versions
  # on your system were taken. It‘s perfectly fine and recommended to leave
  # this value at the release version of the first install of this system.
  # Before changing this value read the documentation for this option
  # (e.g. man configuration.nix or on https://nixos.org/nixos/options.html).
  system.stateVersion = "23.11"; # Did you read the comment?
}
