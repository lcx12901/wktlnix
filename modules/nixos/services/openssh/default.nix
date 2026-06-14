{ config, lib, ... }:
let
  inherit (lib) mkIf mkEnableOption;
  inherit (lib.types) port;
  inherit (lib.wktlnix) mkOpt;

  hasOptinPersistence = config.wktlnix.system.persist.enable;

  cfg = config.wktlnix.services.openssh;
in
{
  options.wktlnix.services.openssh = {
    enable = mkEnableOption "Whether or not to configure OpenSSH support.";
    port = mkOpt port 2233 "The port to listen on (in addition to 22).";
  };

  config = mkIf cfg.enable {
    services.openssh = {
      enable = true;

      settings = {
        PermitRootLogin = "no";
        PasswordAuthentication = false;
        AuthenticationMethods = "publickey";
        PubkeyAuthentication = "yes";
        UseDns = false;
        StreamLocalBindUnlink = "yes";

        # key exchange algorithms recommended by `nixpkgs#ssh-audit`
        KexAlgorithms = [
          "curve25519-sha256"
          "curve25519-sha256@libssh.org"
          "diffie-hellman-group16-sha512"
          "diffie-hellman-group18-sha512"
          "diffie-hellman-group-exchange-sha256"
          "sntrup761x25519-sha512@openssh.com"
        ];
      };

      hostKeys = [
        {
          path = "${lib.optionalString hasOptinPersistence "/persist"}/etc/ssh/ssh_host_ed25519_key";
          type = "ed25519";
        }
      ];

      openFirewall = true;

      knownHosts = {
        github-ed25519 = {
          hostNames = [ "github.com" ];
          publicKey = "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIOMqqnkVzrm0SdG6UOoqKLsabgH5C9okWi0dh2l9GKJl";
        };
        akeno-ed25519 = {
          hostNames = [ "akeno.wktl.de" ];
          publicKey = "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAING7bqcTZw/MIm3px4l6bCOOR37Em4hbnutkZJ4Jbnsm";
        };
        milet-ed25519 = {
          hostNames = [ "milet.wktl.de" ];
          publicKey = "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIAZgmbR1xNbPCmUfIMCTI0+QwYKP0d5YrkbFEPNaWErW";
        };
        z9yun-gitlab-ed25519 = {
          hostNames = [ "[192.168.0.216]:8221" ];
          publicKey = "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIGLt+JQ8Er8iN5OepJHT/hBf1ioDP9PV5S4HuKmGYzKn";
        };
        hiyori = {
          hostNames = [ "hiyori.local" ];
          publicKey = "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIJZAyn741cbW5FmNFKplhY2nMGYDDpx2aC0ZQFzNIkMB";
        };
      };
    };
  };
}
