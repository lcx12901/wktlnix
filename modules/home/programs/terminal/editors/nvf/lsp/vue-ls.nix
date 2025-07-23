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
        require('nvim-ts-autotag').setup()
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

        on_attach = mkLuaInline ''
          function(client, _)
            client.server_capabilities.documentFormattingProvider = nil
          end
        '';

        cmd = [
          "${lib.getExe pkgs.vue-language-server}"
          "--stdio"
        ];

        /*
          on_init = mkLuaInline ''
            function(client)
              client.handlers['tsserver/request'] = function(_, result, context)
                local clients = vim.lsp.get_clients({ bufnr = context.bufnr, name = 'vtsls' })
                if #clients == 0 then
                  vim.notify('Could not find `vtsls` lsp client, required by `vue_ls`.', vim.log.levels.ERROR)
                  return
                end
                local ts_client = clients[1]

                local param = unpack(result)
                local id, command, payload = unpack(param)
                ts_client:exec_cmd({
                  title = 'vue_request_forward', -- You can give title anything as it's used to represent a command in the UI, `:h Client:exec_cmd`
                  command = 'typescript.tsserverRequest',
                  arguments = {
                    command,
                    payload,
                  },
                }, { bufnr = context.bufnr }, function(_, r)
                  local response_data = { { id, r.body } }
                  ---@diagnostic disable-next-line: param-type-mismatch
                  client:notify('tsserver/response', response_data)
                end)
              end
            end
          '';
        */
      };
    };
  };
}
