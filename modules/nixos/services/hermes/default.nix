{
  inputs,
  config,
  lib,
  pkgs,
  ...
}:
let
  inherit (lib)
    mkEnableOption
    mkIf
    ;

  inherit (pkgs.stdenv.hostPlatform) system;

  cfg = config.wktlnix.services.hermes;
in
{
  options.wktlnix.services.hermes = {
    enable = mkEnableOption "Hermes agent";
  };

  config = mkIf cfg.enable {
    nix.settings.allowed-users = [ "hermes" ];

    services.hermes-agent = {
      enable = true;
      package = inputs.hermes-agent.packages.${system}.default;

      environmentFiles = [ config.sops.secrets."hermes-env".path ];

      settings = {
        model = {
          provider = "copilot";
          default = "gpt-5-mini";
        };
      };
    };

    sops.secrets =
      let
        sopsFile = lib.file.get-file "secrets/hermes.yaml";
      in
      {
        "hermes-env" = {
          inherit sopsFile;
          format = "yaml";
        };
      };

    environment.persistence."/persist" = {
      hideMounts = true;

      directories = [
        "/var/lib/hermes"
      ];
    };
  };
}
