{ inputs }:
_final: _prev:
let
  myLib = import ./default.nix { inherit inputs; };
in
{
  # Expose wktlnix module functions directly
  wktlnix = myLib.flake.lib.module;

  # Expose all wktlnix lib namespaces
  inherit (myLib.flake.lib)
    file
    system
    ;

  # Add home-manager lib functions
  inherit (inputs.home-manager.lib) hm;

  # Add niri lib functions
  inherit (inputs.niri.lib) kdl;

  # Add nvf lib functions
  inherit (inputs.nvf.lib) nvim;
}
