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
    programs.zen-browser = {
      enable = true;

      setAsDefaultBrowser = true;
      nativeMessagingHosts = [ pkgs.tridactyl-native ];

      policies = import ./policies-config.nix { inherit pkgs; };

      profiles.default = {
        name = "default";

        settings = {
          "zen.workspaces.continue-where-left-off" = true;
          "zen.workspaces.natural-scroll" = true;
          "zen.view.compact.enable-at-startup" = true;
          "zen.view.compact.hide-tabbar" = true;
          "zen.view.compact.hide-toolbar" = true;
          "zen.view.compact.animate-sidebar" = false;
          "zen.welcome-screen.seen" = true;
          "zen.urlbar.behavior" = "float";
          "zen.theme.hide-unified-extensions-button" = true;

          "browser.newtabpage.pinned" = [ ];

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

          "network.cookie.cookieBehavior" = 5;
          "network.http.http3.enabled" = true;
          "network.socket.ip_addr_any.disabled" = true; # disallow bind to 0.0.0.0

          "security.enterprise_roots.enabled" = true;
        };

        presets.betterfox.enable = true;

        sine = {
          enable = true;
          mods = [
            "4ab93b88-151c-451b-a1b7-a1e0e28fa7f8" # No Sidebar Scrollbar
            "803c7895-b39b-458e-84f8-a521f4d7a064" # Hide Inactive Workspaces
            "7d577b21-4685-4db2-bb17-d39d08eec199" # Bleeding Corners Fix
            "c8d9e6e6-e702-4e15-8972-3596e57cf398" # Zen Back Forward
            "cb15abdb-0514-4e09-8ce5-722cf1f4a20f" # Hide Extension Name
            "f7c71d9a-bce2-420f-ae44-a64bd92975ab" # Better Unloaded Tabs
            "e122b5d9-d385-4bf8-9971-e137809097d0" # No Top Sites
            "fd24f832-a2e6-4ce9-8b19-7aa888eb7f8e" # Quietify
          ];
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
        directories = [ ".config/zen/default" ];
      };
    };
  };
}
