{ pkgs, ... }:
{
  extraPlugins = [
    pkgs.vimPlugins.treesj
  ];

  extraConfigLua = ''
    require('treesj').setup({--[[ your config ]]})
  '';
}
