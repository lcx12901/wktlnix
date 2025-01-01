{ pkgs, ... }:
{
  extraPlugins = with pkgs; [
    vimPlugins.goto-preview
  ];

  extraConfigLua = ''
    require("goto-preview").setup({ default_mappings = true })
  '';
}
