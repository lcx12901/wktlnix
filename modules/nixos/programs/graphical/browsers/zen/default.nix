{
  inputs,
  config,
  lib,
  pkgs,
  system,
  namespace,
  ...
}:
let
  inherit (lib) mkIf;
  inherit (lib.${namespace}) mkBoolOpt;

  cfg = config.${namespace}.programs.graphical.browsers.zen;

  policyFormat = pkgs.formats.json { };

  policies = {
    CaptivePortal = false;
    AppAutoUpdate = false;
    DisableFirefoxStudies = true;
    PasswordManagerEnabled = false;
    DisplayBookmarksToolbar = true;
    DontCheckDefaultBrowser = true;
    UserMessaging = {
      ExtensionRecommendations = false;
      SkipOnboarding = true;
    };
    ExtensionSettings = {
      "ebay@search.mozilla.org".installation_mode = "blocked";
      "amazondotcom@search.mozilla.org".installation_mode = "blocked";
      "bing@search.mozilla.org".installation_mode = "blocked";
      "ddg@search.mozilla.org".installation_mode = "blocked";
      "wikipedia@search.mozilla.org".installation_mode = "blocked";
    };
  };
in
{
  options.${namespace}.programs.graphical.browsers.zen = {
    enable = mkBoolOpt false "Whether or not to enable zen-browser.";
  };

  config = mkIf cfg.enable {
    environment.systemPackages = [ inputs.zen-browser.packages."${system}".default ];

    environment.etc =
      let
        policiesJSON = policyFormat.generate "firefox-policies.json" { inherit policies; };
      in
      {
        "zen/policies/policies.json".source = "${policiesJSON}";
      };
  };
}
