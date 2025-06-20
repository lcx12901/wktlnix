{
  osConfig,
  config,
  lib,
  pkgs,
  namespace,
  ...
}:
let
  inherit (lib) types mkIf;
  inherit (lib.${namespace}) mkOpt enabled;

  cfg = config.${namespace}.programs.graphical.browsers.firefox;

  persist = osConfig.${namespace}.system.persist.enable;
in
{
  imports = lib.snowfall.fs.get-non-default-nix-files ./.;

  options.${namespace}.programs.graphical.browsers.firefox = with types; {
    enable = lib.mkEnableOption "Firefox";

    policies = mkOpt attrs {
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
      ExtensionSettings = {
        "ebay@search.mozilla.org".installation_mode = "blocked";
        "amazondotcom@search.mozilla.org".installation_mode = "blocked";
        "bing@search.mozilla.org".installation_mode = "blocked";
        "ddg@search.mozilla.org".installation_mode = "blocked";
        "wikipedia@search.mozilla.org".installation_mode = "blocked";
      };
      Preferences = { };
    } "Policies to apply to firefox";
  };

  config = mkIf cfg.enable {
    home.persistence = lib.mkIf persist {
      "/persist/home/${config.${namespace}.user.name}" = {
        allowOther = true;
        directories = [ ".mozilla/firefox/${config.${namespace}.user.name}" ];
      };
    };

    home.file.".tridactylrc".text = ''
      set newtab https://start.duckduckgo.com

      " " Binds
    '';

    programs.firefox = {
      enable = true;

      betterfox = enabled;

      languagePacks = [
        "zh-CN"
        "en-US"
      ];

      nativeMessagingHosts = [ pkgs.tridactyl-native ];

      inherit (cfg) policies;

      profiles = {
        "default" = {
          id = 0;
          path = "${config.${namespace}.user.name}";
        };

        ${config.${namespace}.user.name} = {
          inherit (config.${namespace}.user) name;

          id = 1;

          betterfox = {
            enable = true;
            enableAllSections = true;
          };

          settings = {
            "sidebar.verticalTabs" = true;
            "sidebar.visibility" = "expand-on-hover";
            "sidebar.main.tools" = "history,bookmarks,aichat";
            "sidebar.animation.expand-on-hover.duration-ms" = 150;
            "sidebar.revamp" = true;
            "browser.tabs.closeTabByDblclick" = true;
            "browser.ml.chat.shortcuts" = false;

            "extensions.autoDisableScopes" = 0;
            "extensions.enabledScopes" = lib.mkForce 15;

            "intl.accept_languages" = "zh-CN,zh,en-US,en";
            "intl.locale.requested" = "zh-CN";
            "general.useragent.locale" = "zh-CN";

            "accessibility.typeaheadfind.enablesound" = false;
            "accessibility.typeaheadfind.flashBar" = 0;

            "browser.startup.page" = 3;
            "browser.bookmarks.showMobileBookmarks" = false;
            "browser.meta_refresh_when_inactive.disabled" = true;
            "browser.sessionstore.warnOnQuit" = true;
            "browser.urlbar.keepPanelOpenDuringImeComposition" = true;

            "devtools.chrome.enabled" = true;
            "devtools.debugger.remote-enabled" = true;
            "devtools.toolbox.host" = "window";

            "dom.storage.next_gen" = true;
            "media.videocontrols.picture-in-picture.video-toggle.enabled" = false;
            "browser.startup.homepage" = "about:blank";
            "browser.ctrlTab.sortByRecentlyUsed" = false;
            "browser.translations.automaticallyPopup" = false;

            "privacy.donottrackheader.enabled" = true;

            # # gpuAcceleration
            "dom.webgpu.enabled" = true;
            "gfx.webrender.all" = true;
            "layers.gpu-process.enabled" = true;
            "layers.mlgpu.enabled" = true;

            # # hardwareDecoding
            "media.ffmpeg.vaapi.enabled" = true;
            "media.gpu-process-decoder" = true;
            "media.hardware-video-decoding.enabled" = true;
          };
        };
      };
    };
  };
}
