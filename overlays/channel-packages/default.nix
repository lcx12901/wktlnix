{ inputs }:
final: _prev:
let
  dae = inputs.daeuniverse.packages."${final.stdenv.hostPlatform.system}".dae-unstable;

  master = import inputs.nixpkgs-master {
    inherit (final.stdenv.hostPlatform) system;
    inherit (final) config;
  };
  # unstable = import inputs.nixpkgs-unstable {
  #   inherit (final.stdenv.hostPlatform) system;
  #   inherit (final) config;
  # };
in
{
  inherit dae;

  # From nixpkgs-master (fast updating / want latest always)
  inherit (master) vue-language-server;
}
