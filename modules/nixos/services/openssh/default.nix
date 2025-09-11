{
  config,
  lib,
  namespace,
  ...
}:
let
  inherit (lib) mkIf;
  inherit (lib.${namespace}) mkBoolOpt mkOpt;
  inherit (lib.types) port;

  hasOptinPersistence = config.${namespace}.system.persist.enable;

  cfg = config.${namespace}.services.openssh;
in
{
  options.${namespace}.services.openssh = {
    enable = mkBoolOpt false "Whether or not to configure OpenSSH support.";
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
        github-rsa = {
          hostNames = [ "github.com" ];
          publicKey = "ssh-rsa AAAAB3NzaC1yc2EAAAADAQABAAABgQCj7ndNxQowgcQnjshcLrqPEiiphnt+VTTvDP6mHBL9j1aNUkY4Ue1gvwnGLVlOhGeYrnZaMgRK6+PKCUXaDbC7qtbW8gIkhL7aGCsOr/C56SJMy/BCZfxd1nWzAOxSDPgVsmerOBYfNqltV9/hWCqBywINIR+5dIg6JTJ72pcEpEjcYgXkE2YEFXV1JHnsKgbLWNlhScqb2UmyRkQyytRLtL+38TGxkxCflmO+5Z8CSSNY7GidjMIZ7Q4zMjA2n1nGrlTDkzwDCsw+wqFPGQA179cnfGWOWRVruj16z6XyvxvjJwbz0wQZ75XK5tKSb7FNyeIEs4TT4jk+S4dhPeAUC5y+bDYirYgM4GC7uEnztnZyaVWQ7B381AK4Qdrwt51ZqExKbQpTUNn+EjqoTwvqNj4kqx5QUCI0ThS/YkOxJCXmPUWZbhjpCg56i+2aB6CmK2JGhn57K5mj0MNdBXA4/WnwH6XoPWJzK5Nyu2zB3nAZp+S5hpQs+p1vN1/wsjk=";
        };
        github-ed25519 = {
          hostNames = [ "github.com" ];
          publicKey = "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIOMqqnkVzrm0SdG6UOoqKLsabgH5C9okWi0dh2l9GKJl";
        };
        akeno-rsa = {
          hostNames = [ "akeno.lincx.top" ];
          publicKey = "ssh-rsa AAAAB3NzaC1yc2EAAAADAQABAAABgQC0uLZfb7O7Rs8F07VeZTUArliPCdEbAkY+U5DlrzkwTrBtxXXcv0w9UM71oKygWe5wq5ExJMxrD/GzsZIevAcjEYnrZt/OlUVsnqsmGqvQI61IIxaj8lK3sR25iRcyJN3U6RKV0Y1EHt2V19YddKsIXKkakaqgRs/Qje6o39yFvy2joXRPawCDmGYO4Sk9oqWo3ykppBF68PxUnsb0cN8rZutJVHQ2I5aCJdLZdoNUnWpsBmKAWsJ4rOa2lZNypBB3btCxQ3SLBU8pj5YPRLiJoOi5A8yxDcfoVSAlb8/6A5B3qVdf2b4e6gdPUHCADtrT6vp28kZEwT5gE2+ZiInQJUGqlLYVkY6IByNqQXytx99Nxjkec8YCBeLMoLQFyiLPs5MvqdWk0g/6fu+CYqRuo68V4ATMECiWmtzIPZV/kDOSHiouAJfr1yPfCa2j6Avpco0o2Qexl5uylGKIkI2c241Su+Wmwl5761oDx486R4aknFQuUKY7uaUmdaLjLVE=";
        };
        akeno-ed25519 = {
          hostNames = [ "akeno.lincx.top" ];
          publicKey = "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIMuvmHU/Ssuu83KgbvzagrSd1vgbDGvzSFPnCDzCpYCg";
        };
        milet-ed25519 = {
          hostNames = [ "milet.lincx.top" ];
          publicKey = "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIAZgmbR1xNbPCmUfIMCTI0+QwYKP0d5YrkbFEPNaWErW";
        };
        z9yun-gitlab-nistp256 = {
          hostNames = [ "[192.168.0.216]:8221" ];
          publicKey = "ecdsa-sha2-nistp256 AAAAE2VjZHNhLXNoYTItbmlzdHAyNTYAAAAIbmlzdHAyNTYAAABBBJ4DwUbrGvjrVD1+xg5B9KsEwdjxeE2SdvtWOz5fVKBHxCyo0k5nY/nNFB8s8+KUIqpUqTFxOBdz6ILdj3F9KCU=";
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
