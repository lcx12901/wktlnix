{
  inputs,
  mkShell,
  pkgs,
  system,
  namespace,
  ...
}:
let
  inherit (inputs) snowfall-flake;
in
mkShell {
  packages = with pkgs; [
    nvfetcher
    prefetch-npm-deps

    deadnix
    snowfall-flake.packages.${system}.flake
    statix
  ];

  shellHook = ''
    echo 🔨 Welcome to ${namespace}
  '';
}
