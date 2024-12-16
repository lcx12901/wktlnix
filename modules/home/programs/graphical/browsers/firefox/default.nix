{
  config,
  lib,
  pkgs,
  osConfig,
  namespace,
  ...
}:
let
  inherit (lib) mkIf mkMerge optionalAttrs;
  inherit (lib.${namespace}) mkBoolOpt mkOpt;
  inherit (lib.types) str attrs;

  cfg = config.${namespace}.programs.graphical.browsers.firefox;

  persist = osConfig.${namespace}.system.persist.enable;

  firefoxPath = ".mozilla/firefox/${config.${namespace}.user.name}";
in
{
  # https://github.com/gvolpe/nix-config/blob/6feb7e4f47e74a8e3befd2efb423d9232f522ccd/home/programs/browsers/firefox.nix
  options.${namespace}.programs.graphical.browsers.firefox = {
    enable = mkBoolOpt false "Whether or not to enable Firefox.";
    hardwareDecoding = mkBoolOpt false "Enable hardware video decoding.";
    gpuAcceleration = mkBoolOpt false "Enable GPU acceleration.";
    extraConfig = mkOpt str "" "Extra configuration for the user profile JS file.";
    settings = mkOpt attrs { } "Settings to apply to the profile.";
    userChrome = mkOpt str "" "Extra configuration for the user chrome CSS file.";
  };

  config = mkIf cfg.enable {
    home = {
      file = mkMerge [
        {
          "${firefoxPath}/chrome/img" = {
            source = lib.cleanSourceWith { src = lib.cleanSource ./chrome/img/.; };

            recursive = true;
          };
        }
      ];
    };

    programs.firefox = {
      enable = true;
      package = pkgs.firefox-devedition;

      languagePacks = [ "zh-CN" ];

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
        # PromptForDownloadLocation = true;
        UserMessaging = {
          ExtensionRecommendations = false;
          SkipOnboarding = true;
        };
        # https://mozilla.github.io/policy-templates/#3rdparty
        ExtensionSettings = {
          "ebay@search.mozilla.org".installation_mode = "blocked";
          "amazondotcom@search.mozilla.org".installation_mode = "blocked";
          "bing@search.mozilla.org".installation_mode = "blocked";
          "ddg@search.mozilla.org".installation_mode = "blocked";
          "wikipedia@search.mozilla.org".installation_mode = "blocked";
        };
        Preferences = { };
      };

      profiles = {
        "dev-edition-default" = {
          id = 0;
          path = "${config.${namespace}.user.name}";
        };

        ${config.${namespace}.user.name} = {
          inherit (cfg) extraConfig;
          inherit (config.${namespace}.user) name;

          id = 1;

          extensions = with pkgs.nur.repos.rycee.firefox-addons; [
            sidebery
            sponsorblock
            bitwarden
            ublock-origin
            auto-tab-discard
            darkreader
            immersive-translate
            tampermonkey
            vimium
          ];

          search = {
            default = "Google";
            privateDefault = "DuckDuckGo";
            force = true;
          };

          settings = mkMerge [
            cfg.settings
            {
              "accessibility.typeaheadfind.enablesound" = false;
              "accessibility.typeaheadfind.flashBar" = 0;
              "browser.aboutConfig.showWarning" = false;
              "browser.aboutwelcome.enabled" = false;
              "browser.bookmarks.autoExportHTML" = true;
              "browser.bookmarks.showMobileBookmarks" = true;
              "browser.meta_refresh_when_inactive.disabled" = true;
              "browser.newtabpage.activity-stream.default.sites" = "";
              "browser.newtabpage.activity-stream.showSponsored" = false;
              "browser.newtabpage.activity-stream.showSponsoredTopSites" = false;
              "browser.search.hiddenOneOffs" = "Google,Amazon.com,Bing,DuckDuckGo,eBay,Wikipedia (en)";
              "browser.search.suggest.enabled" = false;
              "browser.sessionstore.warnOnQuit" = true;
              "browser.shell.checkDefaultBrowser" = false;
              "browser.ssb.enabled" = true;
              "browser.startup.homepage.abouthome_cache.enabled" = true;
              "browser.startup.page" = 3;
              "browser.urlbar.keepPanelOpenDuringImeComposition" = true;
              "browser.urlbar.suggest.quicksuggest.sponsored" = false;
              "devtools.chrome.enabled" = true;
              "devtools.debugger.remote-enabled" = true;
              "dom.storage.next_gen" = true;
              "dom.forms.autocomplete.formautofill" = true;
              "extensions.htmlaboutaddons.recommendations.enabled" = false;
              "extensions.formautofill.addresses.enabled" = false;
              "extensions.formautofill.creditCards.enabled" = false;
              "general.autoScroll" = false;
              "general.smoothScroll.msdPhysics.enabled" = true;
              "geo.enabled" = false;
              "geo.provider.use_corelocation" = false;
              "geo.provider.use_geoclue" = false;
              "geo.provider.use_gpsd" = false;
              "gfx.font_rendering.directwrite.bold_simulation" = 2;
              "gfx.font_rendering.cleartype_params.enhanced_contrast" = 25;
              "gfx.font_rendering.cleartype_params.force_gdi_classic_for_families" = "";
              "intl.accept_languages" = "zh-CN,zh,en-US,en";
              "intl.multilingual.enabled" = true;
              "intl.multilingual.downloadEnabled" = true;
              "media.eme.enabled" = true;
              "media.videocontrols.picture-in-picture.video-toggle.enabled" = false;
              "toolkit.legacyUserProfileCustomizations.stylesheets" = true;
              "font.name.monospace.x-western" = "RecMonoCasual Nerd Font";
              "font.name.sans-serif.x-western" = "RecMonoCasual Nerd Font";
              "font.name.serif.x-western" = "RecMonoCasual Nerd Font";
              "signon.autofillForms" = false;
            }
            (optionalAttrs cfg.gpuAcceleration {
              "dom.webgpu.enabled" = true;
              "gfx.webrender.all" = true;
              "layers.gpu-process.enabled" = true;
              "layers.mlgpu.enabled" = true;
            })
            (optionalAttrs cfg.hardwareDecoding {
              "media.ffmpeg.vaapi.enabled" = true;
              "media.gpu-process-decoder" = true;
              "media.hardware-video-decoding.enabled" = true;
            })
          ];

          # TODO: support alternative theme loading
          userChrome =
            builtins.readFile ./chrome/userChrome.css
            + ''
              ${cfg.userChrome}
            '';
        };
      };
    };
    home.persistence = mkIf persist {
      "/persist/home/${config.${namespace}.user.name}" = {
        allowOther = true;
        directories = [ firefoxPath ];
      };
    };
  };
}
