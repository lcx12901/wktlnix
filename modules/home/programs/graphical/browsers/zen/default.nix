{
  osConfig,
  config,
  lib,
  pkgs,
  namespace,
  ...
}:
let
  cfg = osConfig.${namespace}.programs.graphical.browsers.zen;

  persist = osConfig.${namespace}.system.persist.enable;

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

  userPrefValue =
    pref:
    builtins.toJSON (
      if lib.isBool pref || lib.isInt pref || lib.isString pref then pref else builtins.toJSON pref
    );

  mkUserJs = prefs: ''
    ${lib.concatStrings (
      lib.mapAttrsToList (name: value: ''
        user_pref("${name}", ${userPrefValue value});
      '') prefs
    )}
  '';

  # https://github.com/yokoffing/Betterfox
  settings = {
    # Browser behavior
    "accessibility.typeaheadfind.enablesound" = false;
    "accessibility.typeaheadfind.flashBar" = 0;
    "browser.aboutConfig.showWarning" = false;
    "browser.aboutwelcome.enabled" = false;
    "browser.meta_refresh_when_inactive.disabled" = true;
    "browser.newtabpage.activity-stream.default.sites" = "";
    "browser.newtabpage.activity-stream.showSponsored" = false;
    "browser.newtabpage.activity-stream.showSponsoredTopSites" = false;
    "browser.newtabpage.activity-stream.improvesearch.topSiteSearchShortcuts.havePinned" = "duckduckgo";
    "browser.newtabpage.activity-stream.improvesearch.topSiteSearchShortcuts.searchEngines" =
      "duckduckgo";
    "browser.newtabpage.pinned" = [
      {
        "url" = "https://duckduckgo.com";
        "label" = "@duckduckgo";
        "searchTopSite" = true;
      }
    ];
    "browser.urlbar.placeholderName.private" = "DuckDuckGo";
    "browser.search.hiddenOneOffs" = "Google,Amazon.com,Bing,DuckDuckGo,eBay,Wikipedia (en)";
    "browser.sessionstore.warnOnQuit" = true;
    "browser.shell.checkDefaultBrowser" = false;
    "browser.ssb.enabled" = true;
    "browser.startup.homepage.abouthome_cache.enabled" = true;
    "browser.startup.page" = 3;
    "browser.urlbar.keepPanelOpenDuringImeComposition" = true;
    "browser.urlbar.suggest.quicksuggest.sponsored" = false;

    # Developer tools
    "devtools.chrome.enabled" = true;
    "devtools.debugger.remote-enabled" = true;

    # Storage & forms
    "dom.storage.next_gen" = true;
    "dom.forms.autocomplete.formautofill" = true;

    # Extensions
    "extensions.htmlaboutaddons.recommendations.enabled" = false;
    "extensions.formautofill.addresses.enabled" = false;
    "extensions.formautofill.creditCards.enabled" = false;
    "extensions.autoDisableScopes" = 0;
    "extensions.enabledScopes" = 15;

    # Scrolling & UI
    "general.autoScroll" = false;
    "general.smoothScroll.msdPhysics.enabled" = true;

    # Geolocation
    "geo.enabled" = false;
    "geo.provider.use_corelocation" = false;
    "geo.provider.use_geoclue" = false;
    "geo.provider.use_gpsd" = false;

    # Font rendering
    "gfx.font_rendering.directwrite.bold_simulation" = 2;
    "gfx.font_rendering.cleartype_params.enhanced_contrast" = 25;
    "gfx.font_rendering.cleartype_params.force_gdi_classic_for_families" = "";
    "font.name.monospace.x-western" = "Maple Mono NF CN";
    "font.name.sans-serif.x-western" = "Maple Mono NF CN";
    "font.name.serif.x-western" = "Maple Mono NF CN";

    # Media & localization
    "media.eme.enabled" = true;
    "media.videocontrols.picture-in-picture.video-toggle.enabled" = false;
    "intl.locale.requested" = "zh-CN,en-US";
    "toolkit.legacyUserProfileCustomizations.stylesheets" = true;

    # GPU acceleration
    "signon.autofillForms" = false;
    "dom.webgpu.enabled" = true;
    "gfx.webrender.all" = true;
    "layers.gpu-process.enabled" = true;
    "layers.mlgpu.enabled" = true;

    # Hardware decoding
    "media.ffmpeg.vaapi.enabled" = true;
    "media.gpu-process-decoder" = true;
    "media.hardware-video-decoding.enabled" = true;

    # Zen specific
    "zen.theme.accent-color" = "#f6b0ea";
    "zen.theme.color-prefs.use-workspace-colors" = true;
    "zen.welcome-screen.seen" = true;
  };

  extensionPath = "extensions/{ec8030f7-c20a-464f-9b0e-13a3a9e97384}";

  extensions = with pkgs.firefox-addons; [
    sponsorblock
    bitwarden
    ublock-origin
    auto-tab-discard
    # darkreader
    immersive-translate
    tampermonkey
    github-file-icons
    duckduckgo-privacy-essentials
  ];

  userChrome = ''
    ${builtins.readFile ./chrome/Animations-plus.css}
    ${builtins.readFile ./chrome/zen.css}
  '';
in
{
  config = lib.mkIf cfg.enable {
    home.file = lib.mkMerge [
      { ".zen/profiles.ini".text = profilesIni; }
      { ".zen/${userName}/.keep".text = ""; }
      {
        ".zen/${userName}/user.js" = {
          text = mkUserJs settings;
          force = true;
        };
      }
      {
        ".zen/${userName}/extensions" = {
          source =
            let
              extensionsEnvPkg = pkgs.buildEnv {
                name = "hm-firefox-extensions";
                paths = extensions;
              };
            in
            "${extensionsEnvPkg}/share/mozilla/${extensionPath}";
          recursive = true;
          force = true;
        };
      }
      { ".zen/${userName}/chrome/userChrome.css".text = userChrome; }
    ];

    home.persistence = lib.mkIf persist {
      "/persist/home/${config.${namespace}.user.name}" = {
        allowOther = true;
        directories = [ ".zen/${userName}" ];
      };
    };
  };
}
