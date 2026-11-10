{
  osConfig,
  config,
  lib,
  pkgs,
  ...
}:
let
  inherit (lib)
    mkIf
    mkEnableOption
    getExe
    ;

  persist = osConfig.wktlnix.system.persist.enable;

  cfg = config.wktlnix.programs.terminal.tools.mnemos;

  mnemos = pkgs.wktlnix.mnemos-continuity;
in
{
  options.wktlnix.programs.terminal.tools.mnemos = {
    enable = mkEnableOption "mnemos (agent continuity MCP server)";
  };

  config = mkIf cfg.enable {
    home = {
      packages = [ mnemos ];

      # 记忆（SQLite）、配置与 embeddings 模型都在 ~/.mnemos。
      persistence = lib.mkIf persist {
        "/persist".directories = [
          ".mnemos"
        ];
      };
    };

    # 单元名与 `mnemos daemon install --write` 生成的完全一致（默认 agent id
    # 为 mnemos-agent），`mnemos doctor` 才会把它们认作已排程的 upkeep。
    # 上游模板见 mnemos/setup/scheduler.py：systemd_units() + JOBS。
    systemd.user = {
      services = {
        mnemos-mnemos-agent-maintain = {
          Unit.Description = "Mnemos maintain (decay and connection discovery)";
          Service = {
            Type = "oneshot";
            ExecStart = "${getExe mnemos} consolidate";
          };
        };
        mnemos-mnemos-agent-maintain-deep = {
          Unit.Description = "Mnemos maintain-deep (softening and reflection)";
          Service = {
            Type = "oneshot";
            ExecStart = "${getExe mnemos} consolidate --deep";
          };
        };
      };

      timers = {
        mnemos-mnemos-agent-maintain = {
          Unit.Description = "Mnemos maintain schedule (every 4 hours)";
          Timer = {
            OnUnitActiveSec = "4h";
            OnBootSec = "15min";
          };
          Install.WantedBy = [ "timers.target" ];
        };
        mnemos-mnemos-agent-maintain-deep = {
          Unit.Description = "Mnemos maintain-deep schedule (daily at 03:00)";
          Timer = {
            OnCalendar = "*-*-* 03:00:00";
            # 睡过 03:00 的话，醒来补跑当天的深度整理。
            Persistent = true;
          };
          Install.WantedBy = [ "timers.target" ];
        };
      };
    };
  };
}
