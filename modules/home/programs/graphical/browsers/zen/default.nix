{
  osConfig,
  config,
  lib,
  pkgs,
  ...
}:
let
  inherit (lib) mkIf mkEnableOption;

  persist = osConfig.wktlnix.system.persist.enable;

  cfg = config.wktlnix.programs.graphical.browsers.zen;
in
{
  options.wktlnix.programs.graphical.browsers.zen = {
    enable = mkEnableOption "Zen Browser";
  };

  config = mkIf cfg.enable {
    xdg.mimeApps =
      let
        associations = builtins.listToAttrs (
          map
            (name: {
              inherit name;
              value =
                let
                  zen-browser = config.programs.zen-browser.package;
                in
                zen-browser.meta.desktopFileName;
            })
            [
              "application/x-extension-shtml"
              "application/x-extension-xhtml"
              "application/x-extension-html"
              "application/x-extension-xht"
              "application/x-extension-htm"
              "x-scheme-handler/unknown"
              "x-scheme-handler/mailto"
              "x-scheme-handler/chrome"
              "x-scheme-handler/about"
              "x-scheme-handler/https"
              "x-scheme-handler/http"
              "application/xhtml+xml"
              "application/json"
              "text/plain"
              "text/html"
            ]
        );
      in
      {
        associations.added = associations;
        defaultApplications = associations;
      };

    programs.zen-browser = {
      enable = true;

      nativeMessagingHosts = [ pkgs.tridactyl-native ];

      policies = {
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
        Preferences =
          let
            mkLockedAttrs = builtins.mapAttrs (
              _: value: {
                Value = value;
                Status = "locked";
              }
            );
          in
          mkLockedAttrs {
            "browser.aboutConfig.showWarning" = false;
            "browser.tabs.warnOnClose" = false;
            "media.videocontrols.picture-in-picture.video-toggle.enabled" = true;
            # Disable swipe gestures (Browser:BackOrBackDuplicate, Browser:ForwardOrForwardDuplicate)
            "browser.gesture.swipe.left" = "";
            "browser.gesture.swipe.right" = "";
            "browser.newtabpage.activity-stream.feeds.topsites" = false;
            "browser.tabs.hoverPreview.enabled" = true;
            "browser.topsites.contile.enabled" = false;
          };
      };
      profiles.default = {
        name = "default";
        extensions = {
          force = true;
          packages = with pkgs.firefox-addons; [
            sponsorblock
            bitwarden
            ublock-origin
            auto-tab-discard
            immersive-translate
            tampermonkey
            github-file-icons
            return-youtube-dislikes
            decentraleyes
            tridactyl
          ];
          settings = {
            "uBlock0@raymondhill.net" = {
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
        settings = {
          "zen.workspaces.continue-where-left-off" = true;
          "zen.workspaces.natural-scroll" = true;
          "zen.view.compact.hide-tabbar" = true;
          "zen.view.compact.hide-toolbar" = true;
          "zen.view.compact.animate-sidebar" = false;
          "zen.welcome-screen.seen" = true;
          "zen.urlbar.behavior" = "float";

          "browser.newtabpage.pinned" = [ ];

          "privacy.resistFingerprinting" = true;
          "privacy.resistFingerprinting.randomization.canvas.use_siphash" = true;
          "privacy.resistFingerprinting.randomization.daily_reset.enabled" = true;
          "privacy.resistFingerprinting.randomization.daily_reset.private.enabled" = true;
          "privacy.resistFingerprinting.block_mozAddonManager" = true;
          "privacy.donottrackheader.enabled" = true;
          "privacy.spoof_english" = 1;
          "privacy.firstparty.isolate" = true;

          # default enable extensions
          "extensions.autoDisableScopes" = 0;
          "extensions.enabledScopes" = lib.mkForce 15;

          "intl.accept_languages" = "zh-CN,zh,en-US,en";
          "intl.locale.requested" = "zh-CN";
          "general.useragent.locale" = "zh-CN";

          "webgl.enable-webgl2" = true;

          # gpuAcceleration
          "dom.webgpu.enabled" = true;
          "gfx.webrender.all" = true;
          "layers.gpu-process.enabled" = true;
          "layers.mlgpu.enabled" = true;

          "webgl.disabled" = false;
          "webgl.force-enabled" = true;

          # hardwareDecoding
          "media.ffmpeg.vaapi.enabled" = true;
          "media.gpu-process-decoder" = true;
          "media.gpu-process-encoder" = true;
          "media.hardware-video-decoding.enabled" = true;
          "media.autoplay.default" = 0;

          # enable the Browser Developer Tools
          "devtools.debugger.remote-enabled" = true;
          "devtools.chrome.enabled" = true;
          "toolkit.legacyUserProfileCustomizations.stylesheets" = true;

          "network.cookie.cookieBehavior" = 5;
          "network.http.http3.enabled" = true;
          "network.socket.ip_addr_any.disabled" = true; # disallow bind to 0.0.0.0
        };

        bookmarks = {
          force = true;
          settings = [
            {
              name = "Nix sites";
              toolbar = true;
              bookmarks = [
                {
                  name = "homepage";
                  url = "https://nixos.org/";
                }
                {
                  name = "wiki";
                  tags = [
                    "wiki"
                    "nix"
                  ];
                  url = "https://wiki.nixos.org/";
                }
              ];
            }
          ];
        };

        spacesForce = true;
        spaces = {
          "Mikasa" = {
            id = "572910e1-4468-4832-a869-0b3a93e2f165";
            icon = "🎭";
            position = 1000;
            theme = {
              type = "gradient";
              colors = [
                {
                  red = 216;
                  green = 204;
                  blue = 235;
                  algorithm = "floating";
                  type = "explicit-lightness";
                }
              ];
              opacity = 0.8;
              texture = 0.5;
            };
          };
          "Sakurajima" = {
            id = "8ed24375-68d4-4d37-ab7e-b2e121f994c1";
            icon = "🦭";
            position = 1002;
            theme = {
              type = "gradient";
              colors = [
                {
                  red = 171;
                  green = 219;
                  blue = 227;
                  algorithm = "floating";
                  type = "explicit-lightness";
                }
              ];
              opacity = 0.2;
              texture = 0.5;
            };
          };
        };

        search = {
          force = true;
          default = "ddg";
          engines = {
            "Nix Packages" = {
              urls = [
                {
                  template = "https://search.nixos.org/packages";
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
              definedAliases = [ "@np" ];
            };
            "Nix Options" = {
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
              definedAliases = [ "@no" ];
            };
            "Home Manager Options" = {
              urls = [
                {
                  template = "https://home-manager-options.extranix.com";
                  params = [
                    {
                      name = "query";
                      value = "{searchTerms}";
                    }
                    {
                      name = "release";
                      value = "master";
                    }
                  ];
                }
              ];
              definedAliases = [ "@hm" ];
            };
            "Nix Flakes" = {
              urls = [
                {
                  template = "https://search.nixos.org/flakes";
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
              definedAliases = [ "@nf" ];
            };
            "NixOS Wiki" = {
              urls = [
                {
                  template = "https://wiki.nixos.org/w/index.php";
                  params = [
                    {
                      name = "search";
                      value = "{searchTerms}";
                    }
                  ];
                }
              ];
              definedAliases = [ "@nw" ];
            };
            "C++ Reference" = {
              urls = [
                {
                  template = "https://duckduckgo.com/";
                  params = [
                    {
                      name = "q";
                      value = "{searchTerms}";
                    }
                    {
                      name = "sites";
                      value = "cppreference.com";
                    }
                  ];
                }
              ];
              definedAliases = [ "@cr" ];
            };
            "bing".metaData.hidden = true;
            "google".metaData.alias = "@g"; # builtin engines only support specifying one additional alias
          };
        };

        userChrome = # SCSS
          ''
            :root[zen-single-toolbar="true"]:not([customizing]) {
              & #zen-appcontent-navbar-wrapper {
                &[zen-has-hover="true"] {
                  height: var(--zen-element-separation) !important;
                  min-height: var(--zen-element-separation) !important;
                }
                #PersonalToolbar, .titlebar-buttonbox-container {
                  display: none !important;
                }
              }
            }

            .browserSidebarContainer:is(.deck-selected, [zen-split='true']) .browserContainer {
              #tabbrowser-tabpanels[has-toolbar-hovered] & {
                margin-top: 0 !important;
              }
            }
          '';
      };
    };

    home.file.".tridactylrc".text = ''
      set newtab https://start.duckduckgo.com

      " " Binds
      bind / fillcmdline find
      bind ? fillcmdline find --reverse
      bind n findnext --search-from-view
      bind N findnext --search-from-view --reverse
      bind gn findselect
      bind gN composite findnext --search-from-view --reverse; findselect
      bind ,<Space> nohlsearch
    '';
    home.persistence = lib.mkIf persist {
      "/persist" = {
        directories = [ ".zen/default" ];
      };
    };
  };
}
