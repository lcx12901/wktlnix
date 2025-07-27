{
  inputs,
  lib,
  pkgs,
  ...
}:
let
  inherit (lib.generators) mkLuaInline;
  inherit (inputs.nvf.lib.nvim.dag) entryAnywhere;
in
{
  programs.nvf.settings = {
    vim = {
      startPlugins = [ "nvim-ts-autotag" ];

      pluginRC.html-autotag = entryAnywhere ''
        require('nvim-ts-autotag').setup({})
      '';

      treesitter = {
        enable = true;
        grammars = with pkgs.vimPlugins.nvim-treesitter.builtGrammars; [
          vue
          html
        ];
      };

      lsp.servers.vue_ls = {
        enable = true;

        capabilities = mkLuaInline "capabilities";
        on_attach = mkLuaInline ''
          function(client, _)
            client.server_capabilities.documentFormattingProvider = nil
          end
        '';

        cmd = [
          "${lib.getExe pkgs.vue-language-server}"
          "--stdio"
        ];

        settings = {
          vue.inlayHints = {
            destructuredProps.enabled = true;
            inlineHandlerLoading.enabled = true;
            missingProps.enabled = true;
            optionsWrapper.enabled = true;
            vBindShorthand.enabled = true;
          };
        };
      };
    };
  };
}
