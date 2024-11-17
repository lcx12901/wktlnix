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
        Host akari.lincx.top
          IdentityFile ${osConfig.age.secrets."akari_rsa".path}
          IdentitiesOnly yes

        Host ryomori.lincx.top
          IdentityFile ${osConfig.age.secrets."ryomori_rsa".path}
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
