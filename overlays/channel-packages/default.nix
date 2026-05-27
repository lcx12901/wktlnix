{ inputs }:
final: _prev:
let
  inherit (final.stdenv.hostPlatform) system;

  neovim-nightly = inputs.neovim-nightly-overlay.packages."${system}".default;
  unocss-language-server = inputs.unocss-language-server.packages."${system}".default;

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
  inherit neovim-nightly unocss-language-server;
  # From nixpkgs-master (fast updating / want latest always)
  # inherit (master) ;
}
