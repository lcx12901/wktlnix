{ config, lib, pkgs, ... }:
let
  cfg = config.wktlnix.services.openclaw;
in
{
  config = lib.mkIf cfg.enable {
    programs.openclaw.instances.default.config.models = {
      mode = "merge";
      providers = {
        deepseek = {
          api = "openai-completions";
          baseUrl = "https://api.deepseek.com/v1";
          apiKey = "\${DEEPSEEK_API_KEY}";
          models = [
            {
              id = "deepseek-v4-flash";
              name = "DeepSeek V4 Flash";
              input = [ "text" ];
              contextWindow = 1000000;
              maxTokens = 128000;
              cost = {
                input = 0.14;
                output = 0.28;
                cacheRead = 0.0028;
                cacheWrite = 0;
              };
            }
            {
              id = "deepseek-v4-pro";
              name = "DeepSeek V4 Pro";
              input = [ "text" ];
              contextWindow = 1000000;
              maxTokens = 384000;
              cost = {
                input = 0.435;
                output = 0.87;
                cacheRead = 0.0145;
                cacheWrite = 0;
              };
            }
          ];
        };
      };
    };
  };
}
