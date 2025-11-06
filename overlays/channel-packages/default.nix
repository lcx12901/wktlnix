{ inputs }:
final: _prev:
let
  inherit (final.stdenv.hostPlatform) system;

  dae = inputs.daeuniverse.packages."${system}".dae-unstable;

  neovim-nightly = inputs.neovim-nightly.packages.${system}.neovim;

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
  inherit dae neovim-nightly;

  # From nixpkgs-master (fast updating / want latest always)
}
