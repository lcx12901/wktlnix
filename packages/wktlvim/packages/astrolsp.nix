{ pkgs, ... }:
let
  version = "2.1.0";
in
{
  extraPlugins = [
    (pkgs.vimUtils.buildVimPlugin {
      inherit version;

      name = "astrolsp";

      src = pkgs.fetchFromGitHub {
        owner = "astronvim";
        repo = "astrolsp";
        rev = "v${version}";
        hash = "sha256-vdoiSiuSVzgZQ5gVtkdz+DNrcHoV21nBOTynKUf1JUU=";
      };
    })
  ];

  extraConfigLuaPre = ''
    require('astrolsp').setup({
      features = {
        codelens = true,
        inlay_hints = true,
        semantic_tokens = true,
      },
      capabilities = vim.lsp.protocol.make_client_capabilities(),
      config = {},
      flags = {},
      formatting = { format_on_save = { enabled = true }, disabled = {} },
      handlers = { function(server, server_opts) require("lspconfig")[server].setup(server_opts) end },
      lsp_handlers = {
        ["textDocument/hover"] = vim.lsp.with(vim.lsp.handlers.hover, { border = "rounded", silent = true }),
        ["textDocument/signatureHelp"] = vim.lsp.with(
          vim.lsp.handlers.signature_help,
          { border = "rounded", silent = true, focusable = false }
        ),
      },
      servers = {},
      on_attach = nil,
    })
  '';
}
