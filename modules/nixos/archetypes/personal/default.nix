{
  config,
  lib,

  ...
}:
let
  inherit (lib) mkIf;

  cfg = config.wktlnix.archetypes.personal;
in
{
  options.wktlnix.archetypes.personal = {
    enable = lib.mkEnableOption "the personal archetype";
  };

  config = mkIf cfg.enable {
    wktlnix.system.persist = {
      userDirs = [
        "Coding"
        "Downloads"
        "Documents"
        "Pictures"
      ];
    };
  };
}
