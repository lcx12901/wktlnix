{
  config,
  pkgs,
  ...
}:
let
  # OKX 官方 agent skills（行情/交易/资产/机器人/聪明钱/情绪等）
  okxSkills = pkgs.fetchFromGitHub {
    owner = "okx";
    repo = "agent-skills";
    rev = "d9d6710505ebb02f581e462f92a4a352f6119c6c";
    hash = "sha256-VXz8Uh4hXEgqU9z88OUp9Fr22mLDCdaXwSLQflcCf84=";
  };
in
{
  nix.settings = {
    allowed-users = [ config.services.hermes-agent.user ];
  };

  wktlnix.services.hermes-agent = {
    enable = true;
    environmentFiles = [ config.sops.secrets."emilia-hermes-env".path ];
    settings.skills.external_dirs = [ "${okxSkills}/skills" ];

    extraPackages = [
      pkgs.wktlnix.okx-trade-cli
      pkgs.direnv
      pkgs.logrotate
    ];
  };

  sops = {
    secrets = {
      "emilia-hermes-env" = {
        mode = "0400";
        owner = config.services.hermes-agent.user;
        group = config.services.hermes-agent.group;
        restartUnits = [ "hermes-agent.service" ];
      };
      "okx-config/hermes" = {
        path = "${config.services.hermes-agent.stateDir}/.okx/config.toml";
        mode = "0600";
        owner = config.services.hermes-agent.user;
        group = config.services.hermes-agent.group;
        restartUnits = [ "hermes-agent.service" ];
      };

      "hindsight-tenant-api-key" = {
        restartUnits = [ "hermes-agent.service" ];
      };
    };

    templates = {
      "hermes-hindsight-config" = {
        path = "${config.services.hermes-agent.stateDir}/.hermes/hindsight/config.json";
        owner = config.services.hermes-agent.user;
        group = config.services.hermes-agent.group;
        mode = "0600";
        content = builtins.toJSON {
          mode = "local_external";
          api_url = "https://hindsight.milet.lincx.top";
          api_key = config.sops.placeholder."hindsight-tenant-api-key";
          bank_id = "emilia-hermes";
          recall_budget = "mid";
          memory_mode = "hybrid";
          recall_prefetch_method = "recall";
          recall_types = "observation";
          observation_scopes = "combined";
          auto_retain = true;
          retain_every_n_turns = 3;
          retain_async = true;
          retain_context = "猫娘 Nova 与主人的对话：A 股量化研究与欧易自动交易";
          timeout = 120;
          # 以下内容仅为留档，不会对服务端进行生效 (bug #18774)
          bank_mission = ''
            你是猫娘 Nova，主人的双领域记忆体，负责 A 股量化研究 + 欧易（OKX）自动交易这两摊事喵。
            职责：替主人记住研究过什么、验证过什么、部署过什么，跨对话保持连贯，让每一轮研究都接着上一轮走。
            回答关于股票量化（数据源、因子、策略假设、回测框架与结果、风控参数）与欧易自动交易（策略部署、订单与仓位、止盈止损、API/机器人配置、盈亏记录）的问题时，只讲检索到的记忆，禁止编造数据、结果、策略细节或交易记录——涉及真金白银的事，准确性永远优先于可爱喵。
            明确区分事实与推测、回测与实盘、历史与现状，涉及数字时标注时间与上下文；记忆冲突时指出冲突，以最新状态为准；不确定就如实说"这条我不确定"，绝不硬编。
          '';
          bank_retain_mission = ''
            优先保留（按重要性排序）：
            1. 用户的偏好、约束、规则与纠正——数据源、回测方法、风控参数、交易纪律的明确要求（如仓位上限、止损规则）；
            2. 研究假设、策略思路与推演过程——提出、验证、推翻或修订的每个环节；
            3. 数据相关事实：数据源、字段含义、清洗规则、已知的数据问题与坑；
            4. 回测结果：关键数字与指标（收益、夏普、回撤、胜率）及其参数上下文，并标注为回测而非实盘；
            5. 实盘交易记录（欧易）：开平仓与委托、成交价、仓位变化、保证金、已实现盈亏、手续费与资金费率；
            6. 风控事件：止损/止盈触发、强平、滑点异常、API 限流与报错、订单失败原因；
            7. 策略与机器人配置变更：参数调整、版本演进、运行状态与已知问题；
            8. 代码与工具层面的事实：库的选择、环境配置、踩过的坑、性能结论；
            9. 市场观察与事件（有时间点的）：影响股票或加密市场的宏观/微观事件与当时的判断；
            10. 代理（hermes）自己执行过的研究/交易动作、发现与建议（assistant 类事实）。
            不保留：寒暄、过程性闲聊、一次性命令输出、重复信息、未经验证的猜测（除非明确标注为假设）。'';
          observations_mission = ''
            观察应提炼为与主人 A 股量化研究 + 欧易（OKX）自动交易相关的持久事实：
            已验证的研究结论与策略状态、数据源与工具偏好、交易纪律与风控规则、API/机器人配置的当前状态、有时间标注的重要市场判断。
            忽略一次性闲聊与临时事件。
          '';
        };
      };
    };
  };

  systemd.tmpfiles.rules = [
    "L+ ${config.services.hermes-agent.stateDir}/.hermes/SOUL.md 0640 ${config.services.hermes-agent.user} ${config.services.hermes-agent.group} - ${builtins.toFile "hermes-soul.md" (builtins.readFile ./SOUL.md)}"
  ];

  systemd.services.hermes-agent.after = [ "sops-install-secrets.service" ];
}
