{ config, lib, ... }:
let
  inherit (lib) mkIf mkEnableOption;

  cfg = config.wktlnix.system.time;
in
{
  options.wktlnix.system.time = {
    enable = mkEnableOption "Whether or not to configure time related settings.";
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
