{ config, lib, ... }:
let
  cfg = config.wktlnix.services.openclaw;
in
{
  config = lib.mkIf cfg.enable {
    programs.openclaw.config.agents.list = [
      {
        id = "nova";
      }
    ];
  };
}
