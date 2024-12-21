{
  config,
  lib,
  namespace,
  ...
}:
let
  inherit (lib) mkIf;
  inherit (lib.${namespace}) mkBoolOpt enabled;

  cfg = config.${namespace}.scenes.music;
in
{
  options.${namespace}.scenes.music = {
    enable = mkBoolOpt false "Whether or not to enable music configuration.";
  };

  config = mkIf cfg.enable {

    wktlnix = {
      programs = {
        terminal = {
          media = {
            spicetify = enabled;
            go-musicfox = enabled;
          };
        };
      };
    };
  };
}
