{
  config,
  lib,
  namespace,
  ...
}:
let
  inherit (lib) mkIf;
  inherit (lib.${namespace}) mkBoolOpt;

  cfg = config.${namespace}.system.time;
in
{
  options.${namespace}.system.time = {
    enable = mkBoolOpt false "Whether or not to configure time related settings.";
  };

  config = mkIf cfg.enable {
    time.timeZone = "Asia/Shanghai";

    networking.timeServers = [
      "ntp.tuna.tsinghua.edu.cn"
      "cn.ntp.org.cn"
      "cn.pool.ntp.org"
    ];

    services.chrony.enable = true;
  };
}
