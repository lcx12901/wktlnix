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
        KbdInteractiveAuthentication = false;
        # Automatically remove stale sockets
        StreamLocalBindUnlink = "yes";
        # Allow forwarding ports to everywhere
        GatewayPorts = "clientspecified";
      };

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
          akari-rsa = {
            hostNames = [ "akari.lincx.top" ];
            publicKey = "ssh-rsa AAAAB3NzaC1yc2EAAAADAQABAAABgQDunawOwShyVJLbRlTIz1Sk3POwCbCX9Zr5VAFaU5nED4KPMubZbeZRjgGb5tBlkoL6sfgzSvEMFAEIDB31KiOE0oDGoESv6yvVunZCyJaqQ5AkeSAToz8UD7fO4YUVwYA3gKfsYufPCF98Q+p0gqWzGpHUZ4dNvwaYKG65tPnAmAYKg7ifJpOcaIcvytZatl3w4FIYtbC/uqb2z0n1FI5tAqEon3vpx7R70InEU+NS52M61XNNjAJFBrm5WFgxt6qoHTRiWacXIYIH8EkyvzruwwWezrWWSRYFCrv1AsS/sIQhYQsbvxgooRDvmZwoYuyfjIYPK5jXYovrBZBLMZyuFJWYYOi//XYnZvglbn45hvMoFxQpb3z1Huz9zgbJQE110+bPrAO6QLfYkeA/7AEQ6kCcCrZNZAFuSXeODYSaLNVDmyA+DHkoJ+5KaF9Y9+kRX+foOWBoYDiCXEt45SGLojSD3ob6wGevA6ZW2cC6R2GvgwtamcAcYPUKkDb5LAM=";
          };
          akari-ed25519 = {
            hostNames = [ "akari.lincx.top" ];
            publicKey = "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIGcKaCEcZR316DCKO7fXP2nkF+krWnVm09WHKcxez5Fg";
          };
          ryomori-rsa = {
            hostNames = [ "ryomori.lincx.top" ];
            publicKey = "ssh-rsa AAAAB3NzaC1yc2EAAAADAQABAAABgQDGCLxynLT4epa8cyk2fP8pVQWj1QftlEUW7dGNP7jOf4Av+tYViJep5bRhXuvpxsOmN50M+vQAponNd3Zm6Kok31+7UfmV8TbCKNGo6vQeg1xhM5NF5cDgtGfM+2IHUuVz083Wr5nrStHMvuNR8N1N1R1isd9R7SZdy0nINhYxBbleJHbDVzH/ebLziJSqdSoGQ4C2+6hZIZ3NzDJZGwvBIwqmShYmSUAEmXdra2lviRYkQTtyZ8NuhyS0taWnW57JCw5UQWB03pUCZwYB8DRjTKotK225L5UxfpeD/jkxyjBXexWpGaVfJe+C6ePGBK11SAfF+lAG+uGYiYo7vnUVz/97RaQERsOIv8LuxjqIq3itJVzvRwQlgZ+oTFjsQkU52sb/0oIXsBuFvalxlAg3UdwrGAyA2TmoozdgEwQTKQel79WYVXPG0QxFjIV9Zcz9+pXaZkFQSx91uVDQDj/waLg3ect5NcTWd5Qmkgw1cRA2lUCASTEkvNAv+k4wVaM=";
          };
          ryomori-ed25519 = {
            hostNames = [ "ryomori.lincx.top" ];
            publicKey = "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIIXCpJT3DLO3Rnu2a0wk2DmYmdZDDOD/uFO3v9hjyEKd";
          };
          akame-rsa = {
            hostNames = [ "akame.lincx.top" ];
            publicKey = "ssh-rsa AAAAB3NzaC1yc2EAAAADAQABAAABgQCPCPkwWm1vyvCW8py6KO1Ua7udTWZVUa3DWbE9us7IS9KWtR0BfgyhdygWJzHWqXFcQ5upVMWpllAtmxHwzthOBcLvRzUVMORSJ8uJCeeTowj5IrijsMT7SBxZdOZ/Ca3WkHI+W9vwzzHX4DkLnF9D18nbr3nlp40xAkgu7S7K2OmX76QwTiZgYM9EVQzHatmKZ844PEqwDYCJmqz+WpRiGwgHc1O2MXx/XtCJFylyHVJsJkwY8ilzkb8sbsFZ5CCQl3ZdAmcyKnY0ZRADFV6L2rV5CEiOK+Yfut5rf6rOPp71fDwSGu3SEfvdQZhrCNf9rddV2+sG5aOS05ugyVFLy9ogb+a1CDNI7Z9vCrSSQJ2Rlcc3YiEUxPKRIpHS8Fhm4VPjiLC1VagQ8LgjJE1ZPK2gBq+PmyurAmdItNOt/M+ysyqKwRA/hRGQiHrxDkjNuaLvGbOuypAJVNnHbtRXRv6K6lRc3x8bs/jWYQzzHCJD8yvXZk2ThcqD313uJ6E=";
          };
          akame-ed25519 = {
            hostNames = [ "akame.lincx.top" ];
            publicKey = "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIJ5zj8Ii9OAfwiHMly+kCDAjiqvLnfRrktWUfMVxtUWB";
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
      ];
    };
  };
}
