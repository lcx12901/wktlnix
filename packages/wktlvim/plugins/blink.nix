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
      vimPlugins.blink-compat
    ]
  );

  plugins = lib.mkMerge [
    {
      blink-cmp = {
        enable = true;
        package = inputs.blink-cmp.packages.${system}.default;

        luaConfig.pre = ''
          require('blink.compat').setup({debug = false, impersonate_nvim_cmp = true})
        '';

        settings = {
          completion = {
            accept.auto_brackets.enabled = true;
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
            default = [
              "buffer"
              "codeium"
              "lsp"
              "path"
              "snippets"
              "emoji"
              "git"
              #"npm"
              "spell"
              #"treesitter"
              # "zsh"
            ];
            providers = {
              calc = {
                name = "calc";
                module = "blink.compat.source";
                score_offset = 2;
              };
              codeium = {
                name = "codeium";
                module = "blink.compat.source";
                score_offset = 3;
              };
              # copilot = {
              #   name = "copilot";
              #   module = "blink-cmp-copilot";
              #   score_offset = 5;
              # };
              emoji = {
                name = "emoji";
                module = "blink.compat.source";
                score_offset = 1;
              };
              git = {
                name = "git";
                module = "blink.compat.source";
                score_offset = 0;
              };
              lsp.score_offset = 4;
              npm = {
                name = "npm";
                module = "blink.compat.source";
                score_offset = -3;
              };
              spell = {
                name = "spell";
                module = "blink.compat.source";
                score_offset = -1;
              };
              #treesitter = {
              #    name = "treesitter";
              #    module = "blink.compat.source";
              #  };
              # zsh = {
              #   name = "zsh";
              #   module = "blink.compat.source";
              #   score_offset = -3;
              # };
            };
          };
        };
      };
    }
    (lib.mkIf config.plugins.blink-cmp.enable {
      cmp-calc.enable = true;
      cmp-emoji.enable = true;
      cmp-git.enable = true;
      #cmp-nixpkgs_maintainers.enable = true;
      cmp-npm.enable = true;
      cmp-spell.enable = true;
      cmp-treesitter.enable = true;
      cmp-zsh.enable = true;

      lsp.capabilities = # Lua
        ''
          capabilities = vim.tbl_deep_extend('force', capabilities, require('blink.cmp').get_lsp_capabilities())
        '';
    })
  ];
}
