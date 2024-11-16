{
  lib,
  inputs,
  system,
  pkgs,
  namespace,
  ...
}: let
  inherit (inputs) nixvim;
in
  nixvim.legacyPackages.${system}.makeNixvimWithModule {
    inherit pkgs;
    extraSpecialArgs = {
      inherit namespace;
      inherit (inputs) self;
    };

    module = {
      imports = lib.snowfall.fs.get-non-default-nix-files-recursive ./.;
    };
  }
