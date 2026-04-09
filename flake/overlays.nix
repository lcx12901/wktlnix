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
          _name: func:
          final.callPackage func (
            # 让 overlay 的打包流程保持健壮：先提供共享上下文
            # （self/final/inputs），再按函数签名过滤参数。
            # 这样可避免 package 函数未声明某些键时，
            # 触发“unexpected argument”错误。
            builtins.intersectAttrs (builtins.functionArgs func) (
              self
              // final
              // {
                inherit inputs;
              }
            )
          )
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
      firefox-addons = inputs.firefox-addons.overlays.default;
    };

    perSystem =
      { config, pkgs, ... }:
      {
        pkgs = pkgs.extend (lib.composeManyExtensions allOverlays);

        packages = config.pkgs.wktlnix;
      };
  };
}
