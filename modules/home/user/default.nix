{
  config,
  lib,
  pkgs,
  namespace,
  ...
}: let
  inherit (lib) types mkIf mkMerge mkDefault getExe;
  inherit (lib.${namespace}) mkOpt enabled;

  cfg = config.${namespace}.user;

  home-directory =
    if cfg.name == null
    then null
    else "/home/${cfg.name}";
in {
  options.${namespace}.user = {
    enable = mkOpt types.bool false "Whether to configure the user account.";
    email = mkOpt types.str "wktl1991504424@gmail.com" "The email of the user.";
    fullName = mkOpt types.str "Chengxu Lin" "The full name of the user.";
    home = mkOpt (types.nullOr types.str) home-directory "The user's home directory.";
    name = mkOpt (types.nullOr types.str) config.snowfallorg.user.name "The user account.";
  };

  config = mkIf cfg.enable (mkMerge [
    {
      assertions = [
        {
          assertion = cfg.name != null;
          message = "wktlnix.user.name must be set";
        }
        {
          assertion = cfg.home != null;
          message = "wktlnix.user.home must be set";
        }
      ];

      home = {
        homeDirectory = mkDefault cfg.home;

        shellAliases = {
          # Navigation shortcuts
          home = "cd ~";
          ".." = "cd ..";
          "..." = "cd ../..";
          "...." = "cd ../../..";
          "....." = "cd ../../../..";
          "......" = "cd ../../../../..";

          # Cryptography
          genpass = "${getExe pkgs.openssl} rand - base64 20"; # Generate a random, 20-charactered password
          sha = "shasum -a 256"; # Test checksum
        };
        username = mkDefault cfg.name;
      };

      programs.home-manager = enabled;
    }
  ]);
}
