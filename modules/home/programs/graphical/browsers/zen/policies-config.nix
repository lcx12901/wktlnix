{ pkgs }:
let
  mkLockedAttrs = builtins.mapAttrs (
    _: value: {
      Value = value;
      Status = "locked";
    }
  );

  mkPluginUrl = id: "https://addons.mozilla.org/firefox/downloads/latest/${id}/latest.xpi";

  mkExtensionEntry =
    {
      id,
      pinned ? false,
    }:
    let
      base = {
        install_url = mkPluginUrl id;
        installation_mode = "force_installed";
      };
    in
    if pinned then base // { default_area = "navbar"; } else base;

  mkExtensionSettings = builtins.mapAttrs (
    _: entry: if builtins.isAttrs entry then entry else mkExtensionEntry { id = entry; }
  );
in
{
  AIControls = {
    Default = {
      Value = "blocked";
      Locked = true;
    };
  };
  AutofillAddressEnabled = true;
  AutofillCreditCardEnabled = false;
  DisableAppUpdate = true;
  DisableFeedbackCommands = true;
  DisableFirefoxStudies = true;
  DisablePocket = true; # save webs for later reading
  DisableTelemetry = true;
  DontCheckDefaultBrowser = true;
  OfferToSaveLogins = false;
  EnableTrackingProtection = {
    Value = true;
    Locked = true;
    Cryptomining = true;
    Fingerprinting = true;
  };
  SanitizeOnShutdown = {
    FormData = true;
    Cache = true;
  };
  ExtensionSettings = mkExtensionSettings {
    "uBlock0@raymondhill.net" = mkExtensionEntry {
      id = "ublock-origin";
      pinned = true;
    };
    # about:debugging#/runtime/this-firefox
    "{4590d8b8-3569-46e3-a571-cabfbaeab2c1}" = "no-youtube-shorts";
    "{74145f27-f039-47ce-a470-a662b129930a}" = "clearurls";
    "{762f9885-5a13-4abd-9c77-433dcd38b8fd}" = "return-youtube-dislikes";
    "{85860b32-02a8-431a-b2b1-40fbd64c9c69}" = "github-file-icons";
    "{a4c4eda4-fb84-4a84-b4a1-f7c1cbf2a1ad}" = "refined-github-";
    "{fef652df-dd80-450e-b64a-567abeb3aa4b}" = "youtube-cards";
    "{5efceaa7-f3a2-4e59-a54b-85319448e305}" = "immersive-translate";
    "{446900e4-71c2-419f-a6a7-df9c091e268b}" = "bitwarden-password-manager";
    "firefox@tampermonkey.net" = "tampermonkey";
    "tridactyl.vim@cmcaine.co.uk" = "tridactyl-vim";
    "firefox-extension@steamdb.info" = "steam-database";
    "github-no-more@ihatereality.space" = "github-no-more";
    "jid1-BoFifL9Vbdl2zQ@jetpack" = "decentraleyes";
    "remove.youtube.tracking@moreo.app" = "remove-youtube-tracking";
    "issue-link-status@bfred.it" = "github-issue-link-status";
    "sponsorBlocker@ajay.app" = "sponsorblock";
  };

  "3rdparty".Extensions."uBlock0@raymondhill.net".toOverwrite = {
    filterLists = [
      "user-filters"
      "ublock-filters"
      "ublock-badware"
      "ublock-privacy"
      "ublock-quick-fixes"
      "ublock-unbreak"
      "easylist"
      "easyprivacy"
      "adguard-spyware-url"
      "urlhaus-1"
      "plowe-0"
    ];
    filters = [ "||doubleclick.net^" ];
  };

  SecurityDevices = {
    "System Trust" = "${pkgs.p11-kit}/lib/pkcs11/p11-kit-trust.so";
  };

  Preferences = mkLockedAttrs {
    "browser.aboutConfig.showWarning" = false;
    "browser.tabs.warnOnClose" = false;
    "media.videocontrols.picture-in-picture.video-toggle.enabled" = true;
    # Disable swipe gestures (Browser:BackOrBackDuplicate, Browser:ForwardOrForwardDuplicate)
    "browser.gesture.swipe.left" = "";
    "browser.gesture.swipe.right" = "";
    "browser.newtabpage.activity-stream.feeds.topsites" = false;
    "browser.tabs.hoverPreview.enabled" = true;
    "browser.topsites.contile.enabled" = false;
    "browser.translations.automaticallyPopup" = false;
    "browser.translations.enable" = false;
    "browser.translations.select.enable" = false;

    "network.cookie.cookieBehavior" = 5;

    "gfx.webrender.all" = true;
    "network.http.http3.enabled" = true;
    "network.socket.ip_addr_any.disabled" = true; # disallow bind to 0.0.0.0
  };
}
