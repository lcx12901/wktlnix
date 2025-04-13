{
  config,
  lib,
  pkgs,
  ...
}:
{
  extraPlugins = lib.mkIf config.plugins.avante.enable [
    pkgs.vimPlugins.img-clip-nvim
  ];

  plugins = {
    avante = {
      enable = true;

      lazyLoad.settings.event = [ "DeferredUIEnter" ];

      settings = {
        mappings = {
          files = {
            add_current = "<leader>a.";
          };
        };

        provider = "siliconflow_chat";
        vendors = {
          siliconflow_chat = {
            __inherited_from = "openai";
            api_key_name = "DEEPSEEK_API_KEY";
            endpoint = "https://api.siliconflow.cn/v1";
            model = "deepseek-ai/DeepSeek-R1";
            disable_tools = true;
          };
        };
      };
    };

    which-key.settings.spec = lib.optionals config.plugins.avante.enable [
      {
        __unkeyed-1 = "<leader>a";
        group = "Avante";
        icon = "";
      }
    ];
  };

  keymaps = lib.optionals config.plugins.avante.enable [
    {
      mode = "n";
      key = "<leader>ac";
      action = "<CMD>AvanteClear<CR>";
      options.desc = "avante: clear";
    }
  ];
}
