{
  config,
  lib,
  namespace,
  ...
}:
let
  inherit (lib) mkIf;
  inherit (lib.${namespace}) mkBoolOpt;

  cfg = config.${namespace}.programs.terminal.tools.ssh;

  mkSSHBlock = hostname: identityFile: {
    inherit hostname identityFile;
    identitiesOnly = true;
  };
in
{
  options.${namespace}.programs.terminal.tools.ssh = {
    enable = mkBoolOpt true "Whether or not to enable ssh.";
  };

  config = mkIf cfg.enable {
    programs.ssh = {
      enable = true;

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

        "akeno.lincx.top" = mkSSHBlock "akeno.lincx.top" "${config.sops.secrets."akeno_rsa".path}";
        "github.com" = mkSSHBlock "github.com" "${config.sops.secrets."github_rsa".path}";
        "z9yun.gitlab" = (mkSSHBlock "192.168.0.216" "${config.sops.secrets."github_rsa".path}") // {
          port = 8221;
        };
      };
    };

    sops.secrets =
      let
        sopsFile = lib.snowfall.fs.get-file "secrets/ssh.yaml";
      in
      {
        akame_rsa = { inherit sopsFile; };
        akeno_rsa = { inherit sopsFile; };
        github_rsa = { inherit sopsFile; };
      };
  };
}
