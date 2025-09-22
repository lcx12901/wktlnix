{
  inputs,
  lib,
  ...
}:
let
  overlaysPath = ../overlays;
  dynamicOverlaysSet =
    if builtins.pathExists overlaysPath then
      let
        overlayDirs = builtins.attrNames (builtins.readDir overlaysPath);
      in
      lib.genAttrs overlayDirs (
        name:
        let
          overlayPath = overlaysPath + "/${name}";
          overlayFn = import overlayPath;
        in
        if lib.isFunction overlayFn then overlayFn { inherit inputs; } else overlayFn
      )
    else
      { };

  wktlnixPackagesOverlay =
    final: prev:
    let
      directory = ../packages;
      packageFunctions = prev.lib.filesystem.packagesFromDirectoryRecursive {
        inherit directory;
        callPackage = file: _args: import file;
      };
    in
    {
      wktlnix = prev.lib.fix (
        self:
        prev.lib.mapAttrs (
          _name: func: final.callPackage func (self // { inherit inputs; })
        ) packageFunctions
      );
    };

  allOverlays = (lib.attrValues dynamicOverlaysSet) ++ [ wktlnixPackagesOverlay ];
in
{
  flake = {
    overlays = dynamicOverlaysSet // {
      default = wktlnixPackagesOverlay;
      wktlnix = wktlnixPackagesOverlay;
    };

    perSystem =
      { config, pkgs, ... }:
      {
        pkgs = pkgs.extend (lib.composeManyExtensions allOverlays);

        packages = config.pkgs.wktlnix;
      };
  };
}
