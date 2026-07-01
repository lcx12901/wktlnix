{
  config,
  lib,
  pkgs,
  ...
}:

let
  cfg = config.wktlnix.programs.graphical.games.gaming-optimization;
in
{
  options.wktlnix.programs.graphical.games.gaming-optimization = {
    enable = lib.mkEnableOption "AMD GPU gaming performance optimization";
  };

  config = lib.mkIf cfg.enable {
    environment.variables = {
      # RADV 测试：启用额外优化（gpl=图形管道库, nggc=下一代几何收集）
      RADV_PERFTEST = "gpl,nggc";
      # RADV 低延迟：减少输入延迟（AMD 专用）
      RADV_ANTILAG = "1";
      # DXVK 异步渲染：减少着色器编译卡顿
      DXVK_ASYNC = "1";
      # 禁用 AMDVLK，使用 RADV（更好的游戏兼容性）
      AMD_VULKAN_DISABLE = "1";
      # MangoHud FPS 显示（可选，可通过 game scope 覆盖）
      MANGOHUD = "1";
    };

    boot = {
      kernelPackages =
        let
          kp = pkgs.linuxPackages_cachyos-gcc;
        in
        lib.mkForce (
          kp.cachyOverride {
            cachyVars = kp.kernel.cachyConfig.cachyVars // {
              "_processor_opt" = "GENERIC_V3";
            };
          }
        );
      kernelParams = [
        # GPU 恢复：出错时自动重置，防止桌面冻结
        "amdgpu.gpu_recovery=1"
        # VM 工作模式：仅图形渲染，禁用计算队列（减少开销）
        "amdgpu.vm_update_mode=1"
        "nowatchdog"
        "modprobe.blacklist=sp5100_tco" # AMD平台
        "modprobe.blacklist=iTCO_wdt" # Intel平台
      ];
    };

    nix.settings.system-features = [
      "gccarch-x86-64-v3"
    ];

    chaotic.nyx.cache.enable = true;

    # cachyOS kernel 调度规则
    services.scx = {
      enable = true;
      scheduler = "scx_lavd";
      extraArgs = [ "--performance" ]; # 性能模式
      package = pkgs.scx.full;
    };
  };
}
