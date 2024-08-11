{
  inputs,
  mkShell,
  pkgs,
  system,
  namespace,
  ...
}: let
  inherit (inputs) snowfall-flake;
in
  mkShell {
    packages =
      (with pkgs; [
        alejandra
      ])
      ++ [snowfall-flake.packages.${system}.flake];

    shellHook = ''
      echo 🔨 Welcome to ${namespace}
    '';
  }
