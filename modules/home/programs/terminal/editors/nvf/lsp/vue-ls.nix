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
          function(client, bufnr)
            attach_keymaps(client, bufnr);
            client.server_capabilities.documentFormattingProvider = nil
            client.server_capabilities.semanticTokensProvider.full = true
          end
        '';

        on_init = mkLuaInline ''
          function(client)
            client.handlers['tsserver/request'] = function(_, result, context)
              local ts_clients = vim.lsp.get_clients({ bufnr = context.bufnr, name = 'ts_ls' })
              local vtsls_clients = vim.lsp.get_clients({ bufnr = context.bufnr, name = 'vtsls' })
              local clients = {}

              vim.list_extend(clients, ts_clients)
              vim.list_extend(clients, vtsls_clients)

              if #clients == 0 then
                vim.notify('Could not find `vtsls` or `ts_ls` lsp client, `vue_ls` would not work without it.', vim.log.levels.ERROR)
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
                  local response = r and r.body
                  -- TODO: handle error or response nil here, e.g. logging
                  -- NOTE: Do NOT return if there's an error or no response, just return nil back to the vue_ls to prevent memory leak
                  local response_data = { { id, response } }

                  ---@diagnostic disable-next-line: param-type-mismatch
                  client:notify('tsserver/response', response_data)
                end)
            end
          end
        '';

        cmd = [
          "${lib.getExe pkgs.vue-language-server}"
          "--stdio"
        ];
      };
    };
  };
}
