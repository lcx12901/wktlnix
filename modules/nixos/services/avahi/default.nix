{
  config,
  lib,
  ...
}:
let
  cfg = config.wktlnix.services.avahi;

  inherit (lib) mkIf mkEnableOption;
in
{
  options.wktlnix.services.avahi = {
    enable = mkEnableOption "Avahi";
  };

  config = mkIf cfg.enable {
    services.avahi = {
      enable = true;

      # resolve .local domains
      nssmdns4 = true;

      # pass avahi port(s) to the firewall
      openFirewall = true;

      settings = {
        server.host-name = config.system.name;

        publish = {
          disable-publishing = false;
          disable-user-service-publishing = false;
          publish-addresses = true;
          publish-domain = true;
          publish-hinfo = true;
          publish-workstation = true;
        };
      };
    };
  };
}
