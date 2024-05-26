{
  config,
  lib,
  namespace,
  ...
}: {
  wktlnix = {
    user = {
      enable = true;
      inherit (config.snowfallorg.user) name;
    };
  };

  home.stateVersion = "23.11";
}
