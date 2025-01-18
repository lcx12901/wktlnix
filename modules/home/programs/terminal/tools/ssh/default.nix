{
  osConfig,
  config,
  lib,
  namespace,
  ...
}:
let
  inherit (lib) mkIf;
  inherit (lib.${namespace}) mkBoolOpt;

  cfg = config.${namespace}.programs.terminal.tools.ssh;
in
{
  options.${namespace}.programs.terminal.tools.ssh = {
    enable = mkBoolOpt true "Whether or not to enable ssh.";
  };

  config = mkIf cfg.enable {
    programs.ssh = {
      enable = true;
      extraConfig = ''
        ServerAliveInterval 60
        ServerAliveCountMax 120

        Host akame.lincx.top
          IdentityFile ${osConfig.age.secrets."akame_rsa".path}
          IdentitiesOnly yes

        Host akeno.lincx.top
          IdentityFile ${osConfig.age.secrets."akeno_rsa".path}
          IdentitiesOnly yes

        Host github.com
          IdentityFile ${osConfig.age.secrets."host_rsa".path}
          IdentitiesOnly yes

        Host 192.168.0.216
          port 8221
          IdentityFile ${osConfig.age.secrets."host_rsa".path}
          IdentitiesOnly yes
      '';
    };
  };
}
