{
  config,
  lib,
  pkgs,
  ...
}:
let
  cfg = config.wktlnix.services.openclaw;
in
{
  config = lib.mkIf cfg.enable {
    programs.openclaw.config = {
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
