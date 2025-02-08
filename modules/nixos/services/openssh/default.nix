{
  config,
  lib,
  host,
  namespace,
  ...
}:
let
  inherit (lib) mkIf mkMerge;
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

      knownHosts = mkMerge [
        {
          github-rsa = {
            hostNames = [ "github.com" ];
            publicKey = "ssh-rsa AAAAB3NzaC1yc2EAAAADAQABAAABgQCj7ndNxQowgcQnjshcLrqPEiiphnt+VTTvDP6mHBL9j1aNUkY4Ue1gvwnGLVlOhGeYrnZaMgRK6+PKCUXaDbC7qtbW8gIkhL7aGCsOr/C56SJMy/BCZfxd1nWzAOxSDPgVsmerOBYfNqltV9/hWCqBywINIR+5dIg6JTJ72pcEpEjcYgXkE2YEFXV1JHnsKgbLWNlhScqb2UmyRkQyytRLtL+38TGxkxCflmO+5Z8CSSNY7GidjMIZ7Q4zMjA2n1nGrlTDkzwDCsw+wqFPGQA179cnfGWOWRVruj16z6XyvxvjJwbz0wQZ75XK5tKSb7FNyeIEs4TT4jk+S4dhPeAUC5y+bDYirYgM4GC7uEnztnZyaVWQ7B381AK4Qdrwt51ZqExKbQpTUNn+EjqoTwvqNj4kqx5QUCI0ThS/YkOxJCXmPUWZbhjpCg56i+2aB6CmK2JGhn57K5mj0MNdBXA4/WnwH6XoPWJzK5Nyu2zB3nAZp+S5hpQs+p1vN1/wsjk=";
          };
          github-ed25519 = {
            hostNames = [ "github.com" ];
            publicKey = "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIOMqqnkVzrm0SdG6UOoqKLsabgH5C9okWi0dh2l9GKJl";
          };
          akame-rsa = {
            hostNames = [ "akame.lincx.top" ];
            publicKey = "ssh-rsa AAAAB3NzaC1yc2EAAAADAQABAAABgQCPCPkwWm1vyvCW8py6KO1Ua7udTWZVUa3DWbE9us7IS9KWtR0BfgyhdygWJzHWqXFcQ5upVMWpllAtmxHwzthOBcLvRzUVMORSJ8uJCeeTowj5IrijsMT7SBxZdOZ/Ca3WkHI+W9vwzzHX4DkLnF9D18nbr3nlp40xAkgu7S7K2OmX76QwTiZgYM9EVQzHatmKZ844PEqwDYCJmqz+WpRiGwgHc1O2MXx/XtCJFylyHVJsJkwY8ilzkb8sbsFZ5CCQl3ZdAmcyKnY0ZRADFV6L2rV5CEiOK+Yfut5rf6rOPp71fDwSGu3SEfvdQZhrCNf9rddV2+sG5aOS05ugyVFLy9ogb+a1CDNI7Z9vCrSSQJ2Rlcc3YiEUxPKRIpHS8Fhm4VPjiLC1VagQ8LgjJE1ZPK2gBq+PmyurAmdItNOt/M+ysyqKwRA/hRGQiHrxDkjNuaLvGbOuypAJVNnHbtRXRv6K6lRc3x8bs/jWYQzzHCJD8yvXZk2ThcqD313uJ6E=";
          };
          akame-ed25519 = {
            hostNames = [ "akame.lincx.top" ];
            publicKey = "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIJ5zj8Ii9OAfwiHMly+kCDAjiqvLnfRrktWUfMVxtUWB";
          };
          akeno-rsa = {
            hostNames = [ "akeno.lincx.top" ];
            publicKey = "ssh-rsa AAAAB3NzaC1yc2EAAAADAQABAAABgQC0uLZfb7O7Rs8F07VeZTUArliPCdEbAkY+U5DlrzkwTrBtxXXcv0w9UM71oKygWe5wq5ExJMxrD/GzsZIevAcjEYnrZt/OlUVsnqsmGqvQI61IIxaj8lK3sR25iRcyJN3U6RKV0Y1EHt2V19YddKsIXKkakaqgRs/Qje6o39yFvy2joXRPawCDmGYO4Sk9oqWo3ykppBF68PxUnsb0cN8rZutJVHQ2I5aCJdLZdoNUnWpsBmKAWsJ4rOa2lZNypBB3btCxQ3SLBU8pj5YPRLiJoOi5A8yxDcfoVSAlb8/6A5B3qVdf2b4e6gdPUHCADtrT6vp28kZEwT5gE2+ZiInQJUGqlLYVkY6IByNqQXytx99Nxjkec8YCBeLMoLQFyiLPs5MvqdWk0g/6fu+CYqRuo68V4ATMECiWmtzIPZV/kDOSHiouAJfr1yPfCa2j6Avpco0o2Qexl5uylGKIkI2c241Su+Wmwl5761oDx486R4aknFQuUKY7uaUmdaLjLVE=";
          };
          akeno-ed25519 = {
            hostNames = [ "akeno.lincx.top" ];
            publicKey = "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIMuvmHU/Ssuu83KgbvzagrSd1vgbDGvzSFPnCDzCpYCg";
          };
        }

        (mkIf (host == "yukino") {
          z9yun-gitlab-nistp256 = {
            hostNames = [ "[192.168.0.216]:8221" ];
            publicKey = "ecdsa-sha2-nistp256 AAAAE2VjZHNhLXNoYTItbmlzdHAyNTYAAAAIbmlzdHAyNTYAAABBBJ4DwUbrGvjrVD1+xg5B9KsEwdjxeE2SdvtWOz5fVKBHxCyo0k5nY/nNFB8s8+KUIqpUqTFxOBdz6ILdj3F9KCU=";
          };
          z9yun-gitlab-ed25519 = {
            hostNames = [ "[192.168.0.216]:8221" ];
            publicKey = "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIGLt+JQ8Er8iN5OepJHT/hBf1ioDP9PV5S4HuKmGYzKn";
          };
        })

        {
          hiyori = {
            hostNames = [ "hiyori.local" ];
            publicKey = "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIJZAyn741cbW5FmNFKplhY2nMGYDDpx2aC0ZQFzNIkMB";
          };
        }
      ];
    };
  };
}
