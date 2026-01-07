{ inputs }:
let
  inherit (inputs.nixpkgs.lib) filterAttrs mapAttrs';
in
{
  mkExtendedLib = flake: nixpkgs: nixpkgs.lib.extend flake.lib.overlay;

  mkNixpkgsConfig = flake: {
    overlays = builtins.attrValues flake.overlays;
    config = {
      allowAliases = false;
      allowUnfree = true;
      permittedInsecurePackages = [
        "immersive-translate-1.23.9"
      ];
    };
  };

  mkHomeConfigs =
    {
      flake,
      system,
      hostname,
    }:
    let
      inherit (flake.lib.file) parseHomeConfigurations;
      homesPath = ../../homes;
      allHomes = parseHomeConfigurations homesPath;
    in
    filterAttrs (
      _name: homeConfig: homeConfig.system == system && homeConfig.hostname == hostname
    ) allHomes;

  mkHomeManagerConfig =
    {
      extendedLib,
      inputs,
      system,
      matchingHomes,
    }:
    if matchingHomes != { } then
      {
        home-manager = {
          useGlobalPkgs = true;
          useUserPackages = true;
          extraSpecialArgs = {
            inherit inputs system;
            inherit (inputs) self;
            lib = extendedLib;
            flake-parts-lib = inputs.flake-parts.lib;
          };
          sharedModules = [
            { _module.args.lib = extendedLib; }
          ]
          ++ [
            inputs.home-manager.flakeModules.home-manager
            inputs.stylix.homeModules.stylix
            inputs.sops-nix.homeManagerModules.sops
            inputs.zed-extensions.homeManagerModules.default
            inputs.zen-browser.homeModules.twilight
          ]
          ++ (extendedLib.file.get-default-nix-files-recursive ../../modules/home);
          users = mapAttrs' (_name: homeConfig: {
            name = homeConfig.username;
            value = {
              imports = [ homeConfig.path ];
              home = {
                inherit (homeConfig) username;
                homeDirectory = inputs.nixpkgs.lib.mkDefault "/home/${homeConfig.username}";
              };
              _module.args.username = homeConfig.username;
            };
          }) matchingHomes;
        };
      }
    else
      { };

  mkSpecialArgs =
    {
      inputs,
      hostname,
      username,
      extendedLib,
    }:
    {
      inherit inputs hostname username;
      inherit (inputs) self;
      lib = extendedLib;
      flake-parts-lib = inputs.flake-parts.lib;
      format = "system";
      host = hostname;
    };
}
