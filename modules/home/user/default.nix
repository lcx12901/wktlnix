{
  osConfig,
  config,
  lib,
  pkgs,
  namespace,
  ...
}:
let
  inherit (lib)
    types
    mkIf
    mkMerge
    mkDefault
    getExe
    getExe'
    ;
  inherit (lib.${namespace}) mkOpt enabled;

  cfg = config.${namespace}.user;

  home-directory = if cfg.name == null then null else "/home/${cfg.name}";
in
{
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
          # nix alias
          nsn = "nix shell nixpkgs#";
          nsw = "sudo nixos-rebuild switch --flake .#${osConfig.networking.hostName}";
          nfu = "nix flake update";
          repair = "nix-store --verify --check-contents --repair";
          cleanup = "sudo nix-collect-garbage --delete-older-than 3d && nix-collect-garbage -d";
          gc-check = "nix-store --gc --print-roots | egrep -v \"^(/nix/var|/run/\w+-system|\{memory|/proc)\"";

          # Navigation shortcuts
          home = "cd ~";
          ".." = "cd ..";
          "..." = "cd ../..";
          "...." = "cd ../../..";
          "....." = "cd ../../../..";
          "......" = "cd ../../../../..";

          # File management
          dfh = "${getExe' pkgs.coreutils "df"} -h";
          duh = "${getExe' pkgs.coreutils "du"} -h";
          usage = "${getExe' pkgs.coreutils "du"} -ah -d1 | sort -rn 2>/dev/null";

          # Cryptography
          genpass = "${getExe pkgs.openssl} rand - base64 20"; # Generate a random, 20-charactered password
          sha = "shasum -a 256";

          # Colorize output
          dir = "${getExe' pkgs.coreutils "dir"} --color=auto";
          egrep = "${getExe' pkgs.gnugrep "egrep"} --color=auto";
          fgrep = "${getExe' pkgs.gnugrep "fgrep"} --color=auto";
          grep = "${getExe pkgs.gnugrep} --color=auto";
          vdir = "${getExe' pkgs.coreutils "vdir"} --color=auto";

          # Misc
          clear = "clear && ${getExe config.programs.fastfetch.package}";
          clr = "clear";
          pls = "sudo";
          psg = "${getExe pkgs.ps} aux | grep";
          myip = "${getExe pkgs.curl} ifconfig.me";
        };
        username = mkDefault cfg.name;
      };

      programs.home-manager = enabled;
    }
  ]);
}
