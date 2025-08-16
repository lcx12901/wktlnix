{
  inputs,
  lib,
  pkgs,
  ...
}:
let
  inherit (lib.generators) mkLuaInline;
  inherit (inputs.nvf.lib.nvim.dag) entryBefore;

  has_words_before = # lua
    ''
      local function has_words_before()
        local line, col = (unpack or table.unpack)(vim.api.nvim_win_get_cursor(0))
        return col ~= 0 and vim.api.nvim_buf_get_lines(0, line - 1, line, true)[1]:sub(col, col):match "%s" == nil
      end
    '';

  get_kind_icon = # lua
    ''
      ---@type function?, function?
      local icon_provider, hl_provider

      local function get_kind_icon(CTX)
        -- Evaluate icon provider
        if not icon_provider then
          local _, mini_icons = pcall(require, "mini.icons")
          if _G.MiniIcons then
            icon_provider = function(ctx)
              local is_specific_color = ctx.kind_hl and ctx.kind_hl:match "^HexColor" ~= nil
              if ctx.item.source_name == "LSP" then
                local icon, hl = mini_icons.get("lsp", ctx.kind or "")
                if icon then
                  ctx.kind_icon = icon
                  if not is_specific_color then ctx.kind_hl = hl end
                end
              elseif ctx.item.source_name == "Path" then
                ctx.kind_icon, ctx.kind_hl = mini_icons.get(ctx.kind == "Folder" and "directory" or "file", ctx.label)
              elseif ctx.item.source_name == "Snippets" then
                ctx.kind_icon, ctx.kind_hl = mini_icons.get("lsp", "snippet")
              end
            end
          end
          if not icon_provider then
            local lspkind_avail, lspkind = pcall(require, "lspkind")
            if lspkind_avail then
              icon_provider = function(ctx)
                if ctx.item.source_name == "LSP" then
                  local icon = lspkind.symbolic(ctx.kind, { mode = "symbol" })
                  if icon then ctx.kind_icon = icon end
                elseif ctx.item.source_name == "Snippets" then
                  local icon = lspkind.symbolic("snippet", { mode = "symbol" })
                  if icon then ctx.kind_icon = icon end
                end
              end
            end
          end
          if not icon_provider then icon_provider = function() end end
        end
        -- Evaluate highlight provider
        if not hl_provider then
          local highlight_colors_avail, highlight_colors = pcall(require, "nvim-highlight-colors")
          if highlight_colors_avail then
            local kinds
            hl_provider = function(ctx)
              if not kinds then kinds = require("blink.cmp.types").CompletionItemKind end
              if ctx.item.kind == kinds.Color then
                local doc = vim.tbl_get(ctx, "item", "documentation")
                if doc then
                  local color_item = highlight_colors_avail and highlight_colors.format(doc, { kind = kinds[kinds.Color] })
                  if color_item and color_item.abbr_hl_group then
                    if color_item.abbr then ctx.kind_icon = color_item.abbr end
                    ctx.kind_hl = color_item.abbr_hl_group
                  end
                end
              end
            end
          end
          if not hl_provider then hl_provider = function() end end
        end
        -- Call resolved providers
        icon_provider(CTX)
        hl_provider(CTX)
        -- Return text and highlight information
        return { text = CTX.kind_icon .. CTX.icon_gap, highlight = CTX.kind_hl }
      end
    '';
in
{
  programs.nvf.settings = {
    vim = {
      luaConfigRC.blink_func = entryBefore [ "lazyConfigs" ] ''
        ${has_words_before}
        ${get_kind_icon}
      '';

      autocomplete = {
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
              accept = {
                auto_brackets = {
                  enabled = true;
                };
              };
              documentation = {
                auto_show = true;
                auto_show_delay_ms = 0;
                window = {
                  border = "rounded";
                  winhighlight = "Normal:NormalFloat,FloatBorder:FloatBorder,CursorLine:PmenuSel,Search:None";
                };
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
                      text = mkLuaInline ''
                        function(ctx) return get_kind_icon(ctx).text end
                      '';
                      highlight = mkLuaInline ''
                        function(ctx) return get_kind_icon(ctx).highlight end
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
                Text = "";
                Field = "";
                Variable = "";
                Class = "";
                Interface = "";
                TypeParameter = "";
                RipgrepRipgrep = "󰛢";
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
  };
}
