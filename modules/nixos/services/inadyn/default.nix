{ config, lib, ... }:
let
  inherit (lib) mkIf mkEnableOption;
  inherit (lib.types) path;
  inherit (lib.wktlnix) mkOpt;

  cfg = config.wktlnix.services.inadyn;
in
{
  options.wktlnix.services.inadyn = {
    enable = mkEnableOption "Whether or not to configure inadyn for ddns.";
    configFile = mkOpt path "" "path to singularity config";
  };

  config = mkIf cfg.enable {
    services.inadyn = {
      inherit (cfg) configFile;

      enable = true;
    };
  };
}
