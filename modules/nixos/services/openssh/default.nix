{
  config,
  lib,
  namespace,
  ...
}: let
  inherit (lib) mkIf;
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
    };
  };
}
