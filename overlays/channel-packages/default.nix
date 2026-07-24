{ inputs }:
final: _prev:
let
  inherit (final.stdenv.hostPlatform) system;

  inherit (inputs.self.packages.${final.stdenv.hostPlatform.system})
    rime-all
    rime-yuhaostar
    neovide
    ;

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
  inherit
    neovide
    rime-all
    rime-yuhaostar
    unocss-language-server
    ;
  # From nixpkgs-master (fast updating / want latest always)
  # inherit (master) ;
}
