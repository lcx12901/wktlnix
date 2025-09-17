{ inputs }:
_final: _prev:
let
  wktlnixLib = import ./default.nix { inherit inputs; };
in
{
  # Expose khanelinix module functions directly
  wktlnix = wktlnixLib.flake.lib.module;

  # Expose all khanelinix lib namespaces
  inherit (wktlnixLib.flake.lib) system;

  inherit (wktlnixLib.flake.lib.file) getFile importModulesRecursive;

  inherit (wktlnixLib.flake.lib.module)
    mkOpt
    mkOpt'
    mkBoolOpt
    mkBoolOpt'
    enabled
    disabled
    capitalize
    boolToNum
    default-attrs
    force-attrs
    nested-default-attrs
    nested-force-attrs
    decode
    ;

  # Add home-manager lib functions
  inherit (inputs.home-manager.lib) hm;
}
