{
  config,
  lib,
  options,
  pkgs,
  ...
}:
let
  inherit (lib) types mkAliasDefinitions;
  inherit (lib.wktlnix) mkOpt;
in
{
  options.wktlnix.home = with types; {
    configFile =
      mkOpt attrs { }
        "A set of files to be managed by home-manager's <option>xdg.configFile</option>.";
    extraOptions = mkOpt attrs { } "Options to pass directly to home-manager.";
    file = mkOpt attrs { } "A set of files to be managed by home-manager's <option>home.file</option>.";
  };

  config = {
    environment.systemPackages = [ pkgs.home-manager ];

    wktlnix.home.extraOptions = {
      home.file = mkAliasDefinitions options.wktlnix.home.file;
      home.stateVersion = config.system.stateVersion;
      xdg.configFile = mkAliasDefinitions options.wktlnix.home.configFile;
      xdg.enable = true;
    };

    home-manager = {
      # enables backing up existing files instead of erroring if conflicts exist
      backupFileExtension = "hm.old";

      useGlobalPkgs = true;
      useUserPackages = true;

      users.${config.wktlnix.user.name} = mkAliasDefinitions options.wktlnix.home.extraOptions;

      verbose = true;
    };
  };
}
