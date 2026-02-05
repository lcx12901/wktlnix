{ config, lib, ... }:
let
  inherit (lib) mkIf mkEnableOption;

  cfg = config.wktlnix.security.certificates;
in
{
  options.wktlnix.security.certificates = {
    enable = mkEnableOption "certificates";
  };

  config = mkIf cfg.enable {
    security.pki.certificateFiles = [
      ./ca.crt
    ];
  };
}
