{ pkgs, namespace, ... }:
{
  extraPlugins =  [
    pkgs.vimPlugins.goto-preview
    pkgs.${namespace}.logger-nvim
  ];

  extraConfigLua = ''
    require("goto-preview").setup({ default_mappings = true })
  '';
}
