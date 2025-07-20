{ lib, pkgs, ... }:
let
  inherit (lib.generators) mkLuaInline;
in
{
  programs.nvf.settings = {
    vim.autocomplete = {
      enableSharedCmpSources = true;

      blink-cmp = {
        enable = true;

        friendly-snippets.enable = true;

        mappings = {
          complete = "<C-L>";
        };

        sourcePlugins = {
          emoji.enable = true;
          ripgrep.enable = true;
          spell.enable = true;
          copilot = {
            enable = true;
            package = pkgs.vimPlugins.blink-copilot;
            module = "blink-copilot";
          };
        };

        setupOpts = {
          cmdline = {
            keymap = {
              preset = "enter";
              "<A-Space>" = [
                "show"
                "show_documentation"
                "hide_documentation"
              ];
              "<Up>" = [
                "select_prev"
                "fallback"
              ];
              "<Down>" = [
                "select_next"
                "fallback"
              ];
              "<C-N>" = [
                "select_next"
                "show"
              ];
              "<C-P>" = [
                "select_prev"
                "show"
              ];
              "<C-J>" = [
                "select_next"
                "fallback"
              ];
              "<C-K>" = [
                "select_prev"
                "fallback"
              ];
              "<C-U>" = [
                "scroll_documentation_up"
                "fallback"
              ];
              "<C-D>" = [
                "scroll_documentation_down"
                "fallback"
              ];
              "<C-e>" = [
                "hide"
                "fallback"
              ];
              "<CR>" = [
                "accept"
                "fallback"
              ];
              "<Tab>" = [
                "select_next"
                "snippet_forward"
                (mkLuaInline ''
                  function(cmp)
                    if has_words_before() or vim.api.nvim_get_mode().mode == "c" then return cmp.show() end
                  end
                '')
                "fallback"
              ];
              "<S-Tab>" = [
                "select_prev"
                "snippet_backward"
                (mkLuaInline ''
                  function(cmp)
                    if vim.api.nvim_get_mode().mode == "c" then return cmp.show() end
                  end
                '')
                "fallback"
              ];
            };
          };

          completion = {
            ghost_text.enabled = true;
            documentation = {
              auto_show = true;
              window.border = "rounded";
            };
            list.selection = {
              auto_insert = false;
              preselect = false;
            };
            menu = {
              auto_show = true;
              border = "rounded";
              winhighlight = "Normal:NormalFloat,FloatBorder:FloatBorder,CursorLine:PmenuSel,Search:None";
              draw = {
                treesitter = [ "lsp" ];
                columns = [
                  (mkLuaInline ''{ "label" }'')
                  (mkLuaInline ''{ "kind_icon", "kind", gap = 1 }'')
                  (mkLuaInline ''{ "source_name" }'')
                ];
                components = {
                  kind_icon = {
                    ellipsis = false;
                    text = mkLuaInline ''
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

          appearance = {
            use_nvim_cmp_as_default = true;
            kind_icons = {
              Copilot = "";
            };
          };

          keymap = {
            preset = "enter";
          };

          signature = {
            enabled = true;
            window.border = "rounded";
          };

          sources = {
            providers = {
              lsp.score_offset = 4;
              emoji = {
                module = "blink-emoji";
                score_offset = 1;
              };
              ripgrep = {
                module = "blink-ripgrep";
                async = true;
                score_offset = 1;
              };
              spell = {
                module = "blink-cmp-spell";
                score_offset = 1;
              };
              copilot = {
                module = lib.mkForce "blink-copilot";
                score_offset = 100;
                async = true;
              };
            };
          };
        };
      };
    };
  };
}
