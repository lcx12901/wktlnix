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
    deadnix
    alejandra
    nix-tree
    snowfall-flake.packages.${system}.flake
  ];

  shellHook = ''
    echo 🔨 Welcome to ${namespace}


  '';
}
