{ inputs, ... }:
{
  flake.lib = {
    file = import ./file { inherit inputs; };
    module = import ./module { inherit inputs; };
    overlay = import ./overlay.nix { inherit inputs; };
    system = import ./system { inherit inputs; };
  };
}
