{
  osConfig,
  config,
  lib,
  namespace,
  ...
}:
let
  cfg = osConfig.${namespace}.programs.graphical.browsers.zen;

  userName = "${config.${namespace}.user.name}";

  profiles = {
    "Profile0" = {
      Name = userName;
      Path = userName;
      IsRelative = 1;
      Default = 1;
    };
    "General" = {
      StartWithLastProfile = 1;
      Version = 2;
    };
  };

  profilesIni = lib.generators.toINI { } profiles;
in
{
  config = lib.mkIf cfg.enable {
    home.file = lib.mkMerge [
      { ".zen/profiles.ini".text = profilesIni; }
      { ".zen/${userName}/.keep".text = ""; }
    ];
  };
}
