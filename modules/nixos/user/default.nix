{
  config,
  lib,
  pkgs,
  namespace,
  ...
}:
let
  inherit (lib.types) str listOf attrs;
  inherit (lib.${namespace}) mkOpt;

  cfg = config.${namespace}.user;
in
{
  options.${namespace}.user = {
    email = mkOpt str "wktl1991504424@gmail.com" "The email of the user.";
    extraGroups = mkOpt (listOf str) [ ] "Groups for the user to be assigned.";
    extraOptions = mkOpt attrs { } "Extra options passed to <option>users.users.<name></option>.";
    fullName = mkOpt str "Chengxu Lin" "The full name of the user.";
    name = mkOpt str "wktl" "The name to use for the user account.";
  };

  config = {
    environment.systemPackages = with pkgs; [
      fortune
      lolcat
    ];

    programs.fish.enable = true;

    users.mutableUsers = false;

    users.users.${cfg.name} = {
      inherit (cfg) name;

      extraGroups = [
        "wheel"
        "systemd-journal"
        "mpd"
        "audio"
        "video"
        "input"
        "plugdev"
        "lp"
        "tss"
        "power"
        "nix"
      ] ++ cfg.extraGroups;

      group = "users";
      home = "/home/${cfg.name}";
      createHome = true;
      isNormalUser = true;
      shell = pkgs.fish;
      uid = 1000;

      hashedPassword = "$6$XXUp9uRF41kC5YHm$lsOLgDuECYb9CbDHBRpsPashoBzB794KoLWI2NCpOl5cB9puDosikhJwGXNxuLf/mW6nJ0SdYkasIAIHfd99/0";

      openssh.authorizedKeys.keys = [
        "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIEsBzgtsv5xRzqRmPer4JoLMuLb0wCQHGwMRwTyBDua4"
      ];
    } // cfg.extraOptions;

    users.users.root.hashedPassword = "*"; # lock root account
  };
}
