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
          IdentityFile ${config.sops.secrets."akame_rsa".path}
          IdentitiesOnly yes

        Host akeno.lincx.top
          IdentityFile ${config.sops.secrets."akeno_rsa".path}
          IdentitiesOnly yes

        Host github.com
          IdentityFile ${config.sops.secrets."github_rsa".path}
          IdentitiesOnly yes

        Host 192.168.0.216
          port 8221
          IdentityFile ${config.sops.secrets."github_rsa".path}
          IdentitiesOnly yes
      '';
    };

    home.file.".ssh/authorized_keys".text = builtins.concatStringsSep "\n" [
      "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIJZAyn741cbW5FmNFKplhY2nMGYDDpx2aC0ZQFzNIkMB" # hiyori
      "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAICMR+SUAz22LypQObBh7mOhcIsY3sbeJ4xIbD8/Ju2UD" # kanroji
      "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAII8Nmp08PzTfykfAz1lIsN3rNfurnYssyxGO0O3iXGnJ" # yukino

    ];

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
