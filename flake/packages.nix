{
  inputs,
  lib,
  ...
}:
{
  perSystem =
    { pkgs, ... }:
    let

      packageFunctions = lib.filesystem.packagesFromDirectoryRecursive {
        directory = ../packages;
        callPackage = file: _args: import file;
      };

      builtPackages = lib.fix (
        self:
        lib.mapAttrs (
          _name: packageData:
          let
            packageFn = packageData.default or packageData;
          in
          pkgs.callPackage packageFn (
            # 仅传入 packageFn 明确声明的参数。
            # 这样即使我们提供了共享上下文（self/pkgs/inputs），
            # 也不会把函数未声明的键（例如 `inputs` 或递归包名）
            # 传进去，避免出现参数不匹配错误。
            builtins.intersectAttrs (builtins.functionArgs packageFn) (
              self
              // pkgs
              // {
                inherit inputs;
              }
            )
          )
        ) packageFunctions
      );

      supportedPackages = lib.filterAttrs (
        _name: package:
        package != null
        && (!(package ? meta.platforms) || lib.meta.availableOn pkgs.stdenv.hostPlatform package)
      ) builtPackages;
    in
    {
      packages = supportedPackages;
    };
}
