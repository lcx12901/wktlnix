{ config, lib, ... }:
{
  plugins = {
    auto-session = {
      enable = true;

      settings = {
        bypass_save_filetypes = [ "alpha" ];
      };
    };

    which-key.settings.spec = lib.optionals config.plugins.auto-session.enable [
      {
        __unkeyed = "<leader>S";
        group = "Session Manager";
        icon = "󰘛";
      }
    ];
  };

  keymaps = lib.optionals config.plugins.auto-session.enable [
    {
      mode = "n";
      key = "<leader>SF";
      action = "<Cmd>SessionSearch<CR>";
      options.desc = "Session search";
    }
    {
      mode = "n";
      key = "<leader>SS";
      action = "<Cmd>SessionSave<CR>";
      options.desc = "Select a session to load";
    }
  ];
}
