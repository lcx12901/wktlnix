{
  osConfig,
  config,
  lib,
  pkgs,
  namespace,
  ...
}:
let
  cfg = config.${namespace}.programs.graphical.browsers.zen;

  persist = osConfig.${namespace}.system.persist.enable;
in
{
  imports = lib.snowfall.fs.get-non-default-nix-files ./.;

  options.${namespace}.programs.graphical.browsers.zen = {
    enable = lib.mkEnableOption "zen-browser";
  };

  config = lib.mkIf cfg.enable {
    home.file =
      let
        userChrome = ''
          ${builtins.readFile ./chrome/Animations-plus.css}
          ${builtins.readFile ./chrome/zen.css}
        '';
      in
      {
        ".zen/${config.${namespace}.user.name}/chrome/userChrome.css".text = userChrome;
      };

    home.persistence = lib.mkIf persist {
      "/persist/home/${config.${namespace}.user.name}" = {
        allowOther = true;
        directories = [ ".zen/${config.${namespace}.user.name}" ];
      };
    };

    programs.zen-browser = {
      enable = true;
      policies = {
        CaptivePortal = false;
        DisableFirefoxStudies = true;
        DisableFormHistory = true;
        DisablePocket = true;
        DisableTelemetry = true;
        DisplayBookmarksToolbar = true;
        DontCheckDefaultBrowser = true;
        FirefoxHome = {
          Pocket = false;
          Snippets = false;
        };
        PasswordManagerEnabled = false;
        UserMessaging = {
          ExtensionRecommendations = false;
          SkipOnboarding = true;
        };
        ExtensionSettings = {
          "ebay@search.mozilla.org".installation_mode = "blocked";
          "amazondotcom@search.mozilla.org".installation_mode = "blocked";
          "bing@search.mozilla.org".installation_mode = "blocked";
          "ddg@search.mozilla.org".installation_mode = "blocked";
          "baidu@search.mozilla.org".installation_mode = "blocked";
          "wikipedia@search.mozilla.org".installation_mode = "blocked";
        };
        Preferences = { };
      };

      profiles = {
        "zen-Twilight" = {
          id = 0;
          path = "${config.${namespace}.user.name}";
        };

        ${config.${namespace}.user.name} = {
          inherit (config.${namespace}.user) name;

          id = 1;

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
            "browser.newtabpage.activity-stream.improvesearch.topSiteSearchShortcuts.havePinned" = "DuckDuckGo";
            "browser.newtabpage.activity-stream.improvesearch.topSiteSearchShortcuts.searchEngines" =
              "DuckDuckGo";
            "browser.newtabpage.pinned" = [ ];
            "browser.urlbar.placeholderName.private" = "DuckDuckGo";
            "browser.search.hiddenOneOffs" = "Google,Amazon.com,Bing,DuckDuckGo,eBay,Wikipedia (en),Baidu";
            "browser.sessionstore.warnOnQuit" = true;
            "browser.shell.checkDefaultBrowser" = false;
            "browser.ssb.enabled" = true;
            "browser.startup.homepage.abouthome_cache.enabled" = true;
            "browser.startup.page" = 3;
            "browser.urlbar.keepPanelOpenDuringImeComposition" = true;
            "browser.urlbar.suggest.quicksuggest.sponsored" = false;
            "browser.translations.automaticallyPopup" = false;
            "browser.tabs.allow_transparent_browser" = true;

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
            "zen.view.grey-out-inactive-windows" = false; # Non-focused windows aren't transparent
          };

          extensions = {
            force = true;

            packages = with pkgs.firefox-addons; [
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

            settings = {
              "uBlock0@raymondhill.net" = {
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
            };
          };

          search = {
            default = "ddg";
            privateDefault = "ddg";
            force = true;

            engines = {
              "baidu".metaData.hidden = true;
              "bing".metaData.hidden = true;
              "google".metaData.hidden = true;
              "ebay".metaData.hidden = true;
              "wikipedia".metaData.hidden = true;

              "NixOs Options" = {
                metaData.hideOneOffButton = true;
                urls = [
                  {
                    template = "https://search.nixos.org/options";
                    params = [
                      {
                        name = "channel";
                        value = "unstable";
                      }
                      {
                        name = "query";
                        value = "{searchTerms}";
                      }
                    ];
                  }
                ];
                icon = "${pkgs.nixos-icons}/share/icons/hicolor/scalable/apps/nix-snowflake.svg";
                definedAliases = [ "@no" ];
              };

              "Nix Packages" = {
                metaData.hideOneOffButton = true;
                urls = [
                  {
                    template = "https://search.nixos.org/packages";
                    params = [
                      {
                        name = "channel";
                        value = "unstable";
                      }
                      {
                        name = "type";
                        value = "packages";
                      }
                      {
                        name = "query";
                        value = "{searchTerms}";
                      }
                    ];
                  }
                ];
                icon = "${pkgs.nixos-icons}/share/icons/hicolor/scalable/apps/nix-snowflake.svg";
                definedAliases = [ "@np" ];
              };

              "NixOS Wiki" = {
                metaData.hideOneOffButton = true;
                urls = [ { template = "https://wiki.nixos.org/w/index.php?search={searchTerms}"; } ];
                icon = "${pkgs.nixos-icons}/share/icons/hicolor/scalable/apps/nix-snowflake.svg";
                definedAliases = [ "@nw" ];
              };

              "Nixvim Options" = {
                metaData.hideOneOffButton = true;
                urls = [
                  {
                    template = "https://nix-community.github.io/nixvim/NeovimOptions/index.html";
                    params = [
                      {
                        name = "search";
                        value = "{searchTerms}";
                      }
                    ];
                  }
                ];
                icon = "${pkgs.nixos-icons}/share/icons/hicolor/scalable/apps/nix-snowflake.svg";
                definedAliases = [ "@nv" ];
              };
            };
          };
        };
      };
    };
  };
}
