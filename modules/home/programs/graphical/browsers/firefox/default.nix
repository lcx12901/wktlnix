{
  config,
  lib,
  pkgs,
  namespace,
  ...
}:
let
  inherit (lib)
    types
    mkIf
    mkMerge
    ;
  inherit (lib.${namespace}) mkBoolOpt mkOpt;

  cfg = config.${namespace}.programs.graphical.browsers.firefox;

  firefoxPath = ".mozilla/firefox/${config.${namespace}.user.name}";
in {
  options.${namespace}.programs.graphical.browsers.firefox = with types; {
    enable = mkBoolOpt false "Whether or not to enable Firefox.";
    hardwareDecoding = mkBoolOpt false "Enable hardware video decoding.";
    gpuAcceleration = mkBoolOpt false "Enable GPU acceleration.";
    extraConfig = mkOpt str "" "Extra configuration for the user profile JS file.";
    settings = mkOpt attrs { } "Settings to apply to the profile.";
    userChrome = mkOpt str "" "Extra configuration for the user chrome CSS file.";
  };

  config = mkIf cfg.enable {
    programs.firefox = {
      enable = true;
      package = pkgs.firefox-beta;

      profiles.${config.${namespace}.user.name} = {
        inherit (cfg) extraConfig;
        inherit (config.${namespace}.user) name;

        id = 0;

        extensions = with pkgs.nur.repos.rycee.firefox-addons; [
          firefox-color
          sidebery
          sponsorblock
          bitwarden
          ublock-origin
          auto-tab-discard
          darkreader
        ];
      };
    };
  };
}