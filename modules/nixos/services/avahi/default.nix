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

      publish = {
        enable = true;
        addresses = true;
        domain = true;
        hinfo = true;
        userServices = true;
        workstation = true;
      };
    };
  };
}
