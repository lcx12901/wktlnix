{
  inputs,
  ...
}:
{
  imports = [
    ../lib
    ./overlays.nix
    ./packages.nix
    ./configs.nix
    # ./apps.nix
  ];

  perSystem =
    { system, ... }:
    {
      _module.args.pkgs = import inputs.nixpkgs {
        inherit system;
        config = {
          allowUnfree = true;
        };
      };
    };
}
