{
  config,
  inputs,
  lib,
  system,
  pkgs,
  ...
}:
{
  extraPlugins = lib.mkIf config.plugins.blink-cmp.enable (
    with pkgs;
    [
      wordnet
    ]
  );

  plugins = lib.mkMerge [
    {
      blink-cmp = {
        enable = true;
        package = inputs.blink-cmp.packages.${system}.default;

        lazyLoad.settings.event = "InsertEnter";

        settings = {
          completion = {
            ghost_text.enabled = true;
            documentation = {
              auto_show = true;
              window.border = "rounded";
            };
            menu = {
              border = "rounded";
              draw = {
                columns = [
                  {
                    __unkeyed-1 = "label";
                  }
                  {
                    __unkeyed-1 = "kind_icon";
                    __unkeyed-2 = "kind";
                    gap = 1;
                  }
                  { __unkeyed-1 = "source_name"; }
                ];
                components = {
                  kind_icon = {
                    ellipsis = false;
                    text.__raw = ''
                      function(ctx)
                        local kind_icon, _, _ = require('mini.icons').get('lsp', ctx.kind)
                        -- Check for both nil and the default fallback icon
                        if not kind_icon or kind_icon == '󰞋' then
                          -- Use our configured kind_icons
                          return require('blink.cmp.config').appearance.kind_icons[ctx.kind] or ""
                        end
                        return kind_icon
                      end,
                      -- Optionally, you may also use the highlights from mini.icons
                      highlight = function(ctx)
                        local _, hl, _ = require('mini.icons').get('lsp', ctx.kind)
                        return hl
                      end
                    '';
                  };
                };
              };
            };
          };
          fuzzy = {
            prebuilt_binaries = {
              download = false;
              ignore_version_mismatch = true;
            };
          };
          appearance = {
            use_nvim_cmp_as_default = true;
          };
          keymap = {
            preset = "enter";
            "<A-Tab>" = [
              "snippet_forward"
              "fallback"
            ];
            "<A-S-Tab>" = [
              "snippet_backward"
              "fallback"
            ];
            "<Tab>" = [
              "select_next"
              "fallback"
            ];
            "<S-Tab>" = [
              "select_prev"
              "fallback"
            ];
          };
          signature = {
            enabled = true;
            window.border = "rounded";
          };
          snippets.preset = "mini_snippets";
          sources = {
            default =
              [
                "buffer"
                "lsp"
                "path"
                "snippets"
                "emoji"
                # "git"
                "dictionary"
                "npm"
                "calc"
                "spell"
                #"treesitter"
                # "zsh"
              ]
              ++ lib.optionals config.plugins.codeium-nvim.enable [
                "codeium"
              ];
            providers =
              {
                # BUILT-IN SOURCES
                lsp.score_offset = 4;
                dictionary = {
                  name = "Dict";
                  module = "blink-cmp-dictionary";
                  min_keyword_length = 3;
                };
                emoji = {
                  name = "Emoji";
                  module = "blink-emoji";
                  score_offset = 1;
                };
                ripgrep = {
                  name = "Ripgrep";
                  module = "blink-ripgrep";
                  async = true;
                  score_offset = 1;
                };
                spell = {
                  name = "Spell";
                  module = "blink-cmp-spell";
                  score_offset = 1;
                };
                calc = {
                  name = "calc";
                  module = "blink.compat.source";
                  score_offset = 2;
                };
                npm = {
                  name = "npm";
                  module = "blink.compat.source";
                  score_offset = -3;
                };
              }
              // lib.optionalAttrs config.plugins.codeium-nvim.enable {
                codeium = {
                  name = "codeium";
                  module = "blink.compat.source";
                  score_offset = 100;
                };
              };
          };
        };
      };

      blink-cmp-dictionary.enable = true;
      blink-cmp-spell.enable = true;
      blink-copilot.enable = true;
      blink-emoji.enable = true;
      blink-ripgrep.enable = true;
      blink-compat.enable = true;
    }
    (lib.mkIf config.plugins.blink-cmp.enable {
      cmp-calc.enable = true;

      lsp.capabilities = # Lua
        ''
          capabilities = require('blink.cmp').get_lsp_capabilities(capabilities)
        '';
    })
  ];
}
