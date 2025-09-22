{ config, lib, ... }:
let
  inherit (lib) mkIf;
  inherit (lib.wktlnix) mkBoolOpt mkOpt;

  hasOptinPersistence = config.wktlnix.system.persist.enable;

  cfg = config.wktlnix.security.sops;
in
{
  options.wktlnix.security.sops = with lib.types; {
    enable = mkBoolOpt true "Whether to enable sops.";
    defaultSopsFile = mkOpt path (lib.file.get-file "secrets/default.yaml") "Default sops file.";
    sshKeyPaths = mkOpt (listOf path) [ ] "SSH Key paths to use.";
  };

  config = mkIf cfg.enable {
    sops = {
      inherit (cfg) defaultSopsFile;

      age = {
        sshKeyPaths = [
          "${lib.optionalString hasOptinPersistence "/persist"}/etc/ssh/ssh_host_ed25519_key"
        ];
      };
    };
  };
}
