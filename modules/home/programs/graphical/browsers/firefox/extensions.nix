{
  config,
  lib,
  pkgs,
  ...
}:
let
  inherit (lib.wktlnix) mkOpt;

  cfg = config.wktlnix.programs.graphical.browsers.firefox;
in
{
  options.wktlnix.programs.graphical.browsers.firefox = {
    extensions = {
      packages = mkOpt (with lib.types; listOf package) (with pkgs.firefox-addons; [
        sponsorblock
        bitwarden
        ublock-origin
        auto-tab-discard
        firefox-color
        # darkreader
        immersive-translate
        tampermonkey
        github-file-icons
        tridactyl
      ]) "Extensions to install";

      settings = mkOpt (with lib.types; attrsOf anything) {
        "uBlock0@raymondhill.net" = {
          # Home-manager skip collision check
          force = true;
          settings = {
            selectedFilterLists = [
              "easylist"
              "easylist-annoyances"
              "easylist-chat"
              "easylist-newsletters"
              "easylist-notifications"
              "fanboy-cookiemonster"
              "ublock-badware"
              "ublock-cookies-easylist"
              "ublock-filters"
              "ublock-privacy"
              "ublock-quick-fixes"
              "ublock-unbreak"
            ];
          };
        };
      } "Settings to apply to the extensions.";
    };
  };

  config = lib.mkIf cfg.enable {
    programs.firefox.profiles.${config.wktlnix.user.name}.extensions = {
      inherit (cfg.extensions) packages settings;
      force = cfg.extensions.settings != { };
    };
  };
}
