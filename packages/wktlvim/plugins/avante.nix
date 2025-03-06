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

      package = pkgs.vimPlugins.avante-nvim.overrideAttrs {
        patches = [
          # Patch blink support
          (pkgs.fetchpatch {
            url = "https://github.com/doodleEsc/avante.nvim/commit/a5438d0f16208b7ae9e97ae354bed5ec16b4f9ed.patch";
            hash = "sha256-KyfO9dE27yMXOQhpit7jmzkvnfM7b5kr2Acoh011lXA=";
          })
        ];
      };

      lazyLoad.settings.event = [ "DeferredUIEnter" ];

      settings = {
        mappings = {
          files = {
            add_current = "<leader>a.";
          };
        };

        provider = "siliconflow_chat";
        auto_suggestions_provider = "siliconflow_suggestions";
        vendors = {
          siliconflow_chat = {
            __inherited_from = "openai";
            api_key_name = "DEEPSEEK_API_KEY";
            endpoint = "https://api.siliconflow.cn/v1";
            model = "deepseek-ai/DeepSeek-R1";
            disable_tools = true;
          };
          siliconflow_suggestions = {
            __inherited_from = "openai";
            api_key_name = "DEEPSEEK_API_KEY";
            endpoint = "https://api.siliconflow.cn/v1";
            model = "Qwen/Qwen2.5-Coder-32B-Instruct";
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
