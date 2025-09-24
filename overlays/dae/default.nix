{ inputs, ... }:
_final: prev:
let
  inherit (prev.stdenv.hostPlatform) system;
in
{
  dae = inputs.daeuniverse.packages."${system}".dae-unstable;
}
