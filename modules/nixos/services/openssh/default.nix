{
  config,
  lib,
  host,
  namespace,
  ...
}: let
  inherit (lib) mkIf mkMerge;
  inherit (lib.${namespace}) mkBoolOpt mkOpt;
  inherit (lib.types) port;

  cfg = config.${namespace}.services.openssh;
in {
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
            hostNames = ["github.com"];
            publicKey = "ssh-rsa AAAAB3NzaC1yc2EAAAADAQABAAABgQCj7ndNxQowgcQnjshcLrqPEiiphnt+VTTvDP6mHBL9j1aNUkY4Ue1gvwnGLVlOhGeYrnZaMgRK6+PKCUXaDbC7qtbW8gIkhL7aGCsOr/C56SJMy/BCZfxd1nWzAOxSDPgVsmerOBYfNqltV9/hWCqBywINIR+5dIg6JTJ72pcEpEjcYgXkE2YEFXV1JHnsKgbLWNlhScqb2UmyRkQyytRLtL+38TGxkxCflmO+5Z8CSSNY7GidjMIZ7Q4zMjA2n1nGrlTDkzwDCsw+wqFPGQA179cnfGWOWRVruj16z6XyvxvjJwbz0wQZ75XK5tKSb7FNyeIEs4TT4jk+S4dhPeAUC5y+bDYirYgM4GC7uEnztnZyaVWQ7B381AK4Qdrwt51ZqExKbQpTUNn+EjqoTwvqNj4kqx5QUCI0ThS/YkOxJCXmPUWZbhjpCg56i+2aB6CmK2JGhn57K5mj0MNdBXA4/WnwH6XoPWJzK5Nyu2zB3nAZp+S5hpQs+p1vN1/wsjk=";
          };
          github-ed25519 = {
            hostNames = ["github.com"];
            publicKey = "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIOMqqnkVzrm0SdG6UOoqKLsabgH5C9okWi0dh2l9GKJl";
          };
          akari-rsa = {
            hostNames = ["akari.lincx.top"];
            publicKey = "ssh-rsa AAAAB3NzaC1yc2EAAAADAQABAAABgQDKXnQb0foZ+TTSmuc57/9K5ZYE0gxrmCZLSo0nWc9bRoAOUIF6ATxKMvzO27EPdZz6C6ZK7OUrpY8cERMc9Uub0TqVH3nvA6TLOQqdoyEsgt8h9Y9KYH7GkygWQE6CoBRPUIhLuYJgkbmWlbjfr8gRC27A0qIHQW2b+ackJHT7+CIf5Pgv5DhuLAQQyex9gxqSy+y254IOw+MZ/HSeswqN4SVmHd7flJ0JboYITm1coIJ9j4TDFgW4o8DBZQmfQmX5KC02aE3fRGpr5hySGVLqQ8GguG5eIrVIkDhxfvGAS1ZWGoulvj3Z8Dt+UWQ42fNt0Q0a6hNc+FIKHXqZNfi6M9mMwL4vdzOI5c1k9Qo+qOWGVf8AVfY1WsGZ3RP6m2ffTRGuXLsOyYDFmBXsYYyM02l6yofpHOi2WjTtRThEPSq+3EQlnn///vxQLMs13sTNXMgLqJIRA4mo+NTwdSCJ3tiVJ0I/lN6niFFKogLf3nln0C+nVGiIFI3Bdzkoa5U=";
          };
          akari-ed25519 = {
            hostNames = ["akari.lincx.top"];
            publicKey = "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAINwjajUFCpZEgoJgtu57jNQRtL5+fLmTIkK+U7DV7J/h";
          };
        }

        (mkIf (host == "yukino") {
          z9yun-gitlab-nistp256 = {
            hostNames = ["[192.168.0.216]:8221"];
            publicKey = "ecdsa-sha2-nistp256 AAAAE2VjZHNhLXNoYTItbmlzdHAyNTYAAAAIbmlzdHAyNTYAAABBBJ4DwUbrGvjrVD1+xg5B9KsEwdjxeE2SdvtWOz5fVKBHxCyo0k5nY/nNFB8s8+KUIqpUqTFxOBdz6ILdj3F9KCU=";
          };
          z9yun-gitlab-ed25519 = {
            hostNames = ["[192.168.0.216]:8221"];
            publicKey = "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIGLt+JQ8Er8iN5OepJHT/hBf1ioDP9PV5S4HuKmGYzKn";
          };
        })
      ];
    };
  };
}
