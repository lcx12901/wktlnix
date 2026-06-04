{ config, lib, pkgs, ... }:
let
  cfg = config.wktlnix.services.openclaw;
in
{
  config = lib.mkIf cfg.enable {
    programs.openclaw.instances.default.config = {
      browser = {
        executablePath = "${pkgs.chromium}/bin/chromium";
        headless = true;
        noSandbox = true;
        extraArgs = [
          "--disable-gpu"
          "--disable-dev-shm-usage"
          "--no-zygote"
        ];
        tabCleanup = {
          enabled = true;
          idleMinutes = 30;
        };
      };

      tools.web.fetch.ssrfPolicy.allowRfc2544BenchmarkRange = true;

      gateway = {
        mode = "local";
        auth = {
          token = "\${OPENCLAW_GATEWAY_TOKEN}";
        };
      };

      session = {
        maintenance = {
          mode = "enforce";
          pruneAfter = "30d";
        };
        reset = {
          mode = "idle";
          idleMinutes = 240;
        };
      };
    };
  };
}
