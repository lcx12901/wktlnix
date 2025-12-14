{ inputs }:
final: _prev:
let
  inherit (final.stdenv.hostPlatform) system;

  dae = inputs.daeuniverse.packages."${system}".dae-unstable;

  # master = import inputs.nixpkgs-master {
  #   inherit (final.stdenv.hostPlatform) system;
  #   inherit (final) config;
  # };
  # unstable = import inputs.nixpkgs-unstable {
  #   inherit (final.stdenv.hostPlatform) system;
  #   inherit (final) config;
  # };
in
{
  inherit dae;
  # From nixpkgs-master (fast updating / want latest always)
}
