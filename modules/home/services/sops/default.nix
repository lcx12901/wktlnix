{
  config,
  lib,
  pkgs,
  ...
}:
let
  inherit (lib) mkIf types;
  inherit (lib.wktlnix) mkBoolOpt mkOpt;

  cfg = config.wktlnix.services.sops;
in
{
  options.wktlnix.services.sops = with types; {
    enable = mkBoolOpt true "Whether to enable sops.";
    defaultSopsFile = mkOpt path (lib.file.get-file "secrets/default.yaml") "Default sops file.";
    sshKeyPaths = mkOpt (listOf path) [ ] "SSH Key paths to use.";
  };

  config = mkIf cfg.enable {
    home.packages = with pkgs; [
      age
      sops
      ssh-to-age
    ];

    sops = {
      inherit (cfg) defaultSopsFile;
      defaultSopsFormat = "yaml";

      age = {
        generateKey = true;
        sshKeyPaths = [ "${config.home.homeDirectory}/.ssh/id_ed25519" ] ++ cfg.sshKeyPaths;
      };

      secrets."sops_keys" = {
        path = "${config.home.homeDirectory}/.config/sops/age/keys.txt";
      };

    };
  };
}
