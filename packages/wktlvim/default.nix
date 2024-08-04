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
      inherit lib namespace;
    };

    module = {
      imports = lib.snowfall.fs.get-non-default-nix-files-recursive ./.;

      viAlias = true;
      vimAlias = true;

      luaLoader.enable = true;

      colorschemes.catppuccin.enable = true;
    };
  }
