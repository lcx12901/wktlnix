{
  config,
  lib,
  ...
}:
let
  inherit (lib) mkIf;
  inherit (lib.wktlnix) mkBoolOpt;

  cfg = config.wktlnix.programs.terminal.tools.ssh;
in
{
  options.wktlnix.programs.terminal.tools.ssh = {
    enable = mkBoolOpt true "Whether or not to enable ssh.";
  };

  config = mkIf cfg.enable {
    programs.ssh = {
      enable = true;

      extraOptionOverrides = {
        HostKeyAlgorithms = "ssh-ed25519-cert-v01@openssh.com,ssh-rsa-cert-v01@openssh.com,ssh-ed25519,ssh-rsa,ecdsa-sha2-nistp521-cert-v01@openssh.com,ecdsa-sha2-nistp384-cert-v01@openssh.com,ecdsa-sha2-nistp256-cert-v01@openssh.com,ecdsa-sha2-nistp521,ecdsa-sha2-nistp384,ecdsa-sha2-nistp256";
        KexAlgorithms = "curve25519-sha256@libssh.org,ecdh-sha2-nistp521,ecdh-sha2-nistp384,ecdh-sha2-nistp256,diffie-hellman-group-exchange-sha256";
        MACs = "hmac-sha2-512-etm@openssh.com,hmac-sha2-256-etm@openssh.com,umac-128-etm@openssh.com,hmac-sha2-512,hmac-sha2-256,umac-128@openssh.com";
        Ciphers = "chacha20-poly1305@openssh.com,aes256-gcm@openssh.com,aes128-gcm@openssh.com,aes256-ctr,aes192-ctr,aes128-ctr";
      };

      enableDefaultConfig = false;

      matchBlocks = {
        "*" = {
          forwardAgent = lib.mkDefault false;
          addKeysToAgent = lib.mkDefault "no";
          compression = lib.mkDefault false;
          serverAliveInterval = lib.mkDefault 60;
          serverAliveCountMax = lib.mkDefault 120;
          hashKnownHosts = lib.mkDefault false;
          userKnownHostsFile = lib.mkDefault "~/.ssh/known_hosts";
          controlMaster = lib.mkDefault "no";
          controlPath = lib.mkDefault "~/.ssh/master-%r@%n:%p";
          controlPersist = lib.mkDefault "no";
        };

        "akeno.lincx.top" = {
          identityFile = config.sops.secrets."akeno_rsa".path;
          identitiesOnly = true;
        };
        "github.com" = {
          identityFile = config.sops.secrets."github_rsa".path;
          identitiesOnly = true;
        };
        "192.168.0.216" = {
          identityFile = config.sops.secrets."github_rsa".path;
          identitiesOnly = true;
          port = 8221;
        };
      };
    };

    sops.secrets =
      let
        sopsFile = lib.file.get-file "secrets/ssh.yaml";
      in
      {
        akeno_rsa = { inherit sopsFile; };
        github_rsa = { inherit sopsFile; };
      };
  };
}
