{ config, lib, ... }:
{
  plugins = {
    mini = {
      enable = true;

      modules = {
        map = {
          # __raw = lua code
          # __unkeyed.* = no key, just the value
          integrations = {
            "__unkeyed.builtin_search".__raw = "require('mini.map').gen_integration.builtin_search()";
            "__unkeyed.gitsigns".__raw = "require('mini.map').gen_integration.gitsigns()";
            "__unkeyed.diagnostic".__raw = "require('mini.map').gen_integration.diagnostic()";
          };

          symbols = {
            encode.__raw = ''require('mini.map').gen_encode_symbols.dot "3x2"'';
          };

          window = {
            side = "right";
            width = 12;
            winblend = 5;
            show_integration_count = true;
          };
        };
      };
    };
  };

  keymaps = lib.mkIf (config.plugins.mini.enable && lib.hasAttr "map" config.plugins.mini.modules) [
    {
      mode = "n";
      key = "<leader>um";
      action.__raw = "MiniMap.toggle";
      options = {
        desc = "MiniMap toggle";
        silent = true;
      };
    }
  ];
}
