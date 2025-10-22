{
  config,
  lib,
  ...
}:
let
  cfg = config.wktlnix.services.clamav;

  inherit (lib) mkIf mkEnableOption;
in
{
  options.wktlnix.services.clamav = {
    enable = mkEnableOption "clamav";
  };

  config = mkIf cfg.enable {
    services.clamav = {
      scanner.enable = true;
      updater.enable = true;
      fangfrisch.enable = true;
      daemon.enable = true;
    };
  };
}
