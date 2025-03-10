{ pkgs, namespace, ... }:
{
  extraPlugins = [
    pkgs.${namespace}.fittencode-nvim
  ];

  extraConfigLua = ''
    require("fittencode").setup({
      completion_mode ='source',
      source_completion = {
        engine = "blink",
      }
    })
  '';
}
