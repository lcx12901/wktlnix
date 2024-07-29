{
  lib,
  inputs,
  system,
  pkgs,
  ...
}: let
  inherit (inputs) nixvim;
in
  nixvim.legacyPackages.${system}.makeNixvimWithModule {
    inherit pkgs;

    module = {
      imports = lib.snowfall.fs.get-non-default-nix-files-recursive ./.;

      viAlias = true;
      vimAlias = true;

      luaLoader.enable = true;

      # Highlight and remove extra white spaces
      highlight.ExtraWhitespace.bg = "red";
      match.ExtraWhitespace = "\\s\\+$";

      colorschemes.catppuccin.enable = true;
    };
  }
