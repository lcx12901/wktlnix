{
  config,
  lib,
  pkgs,
  namespace,
  ...
}: let
  inherit (lib) mkIf optionals;
  inherit (lib.types) attrs;
  inherit (lib.${namespace}) mkBoolOpt mkOpt;

  cfg = config.${namespace}.system.networking;
in {
  options.${namespace}.system.networking = {
    enable = mkBoolOpt false "Whether or not to enable networking support";
    hosts = mkOpt attrs {} "An attribute set to merge with <option>networking.hosts</option>";
    optimizeTcp = mkBoolOpt false "Optimize TCP connections";
  };

  config = mkIf cfg.enable {
    boot = {
      extraModprobeConfig = "options bonding max_bonds=0";

      kernelModules =
        ["af_packet"]
        ++ optionals cfg.optimizeTcp [
          "tls"
          "tcp_bbr"
        ];

      kernel.sysctl = {
        # TCP hardening
        # 防止伪造的ICMP错误填满日志
        "net.ipv4.icmp_ignore_bogus_error_responses" = 1;
        # 反向路径过滤使内核进行源验证从所有接口收到的数据包
        # 这可以减少 IP 欺骗
        "net.ipv4.conf.default.rp_filter" = 1;
        "net.ipv4.conf.all.rp_filter" = 1;
        # 不接受IP源路由数据包（我们不是路由器）
        "net.ipv4.conf.all.accept_source_route" = 0;
        "net.ipv6.conf.all.accept_source_route" = 0;
        # 不要发送 ICMP 重定向（同样，我们在路由器上）
        "net.ipv4.conf.all.send_redirects" = 0;
        "net.ipv4.conf.default.send_redirects" = 0;
        # 拒绝 ICMP 重定向（MITM 缓解措施）
        "net.ipv4.conf.all.accept_redirects" = 0;
        "net.ipv4.conf.default.accept_redirects" = 0;
        "net.ipv4.conf.all.secure_redirects" = 0;
        "net.ipv4.conf.default.secure_redirects" = 0;
        "net.ipv6.conf.all.accept_redirects" = 0;
        "net.ipv6.conf.default.accept_redirects" = 0;
        "net.ipv4.tcp_syncookies" = 1;
        # 防止某些类型的网络攻击（如 TIME-WAIT Assassination）
        "net.ipv4.tcp_rfc1337" = 1;
        # other
        "net.ipv4.conf.all.log_martians" = true;
        "net.ipv4.conf.default.log_martians" = true;
        "net.ipv4.icmp_echo_ignore_broadcasts" = true;
        "net.ipv6.conf.default.accept_ra" = 0;
        "net.ipv6.conf.all.accept_ra" = 0;
        "net.ipv4.tcp_timestamps" = 0;
        "net.ipv4.conf.all.forwarding" = true;
        "net.ipv6.conf.all.forwarding" = true;

        # TCP optimization
        # TCP Fast Open 是一种 TCP 扩展，通过打包来减少网络延迟发送方初始 TCP SYN 中的数据
        # 设置 3 启用 TCP 快速打开传入和传出连接
        "net.ipv4.tcp_fastopen" = 3;
        # # 缓解缓冲区膨胀 + 吞吐量和延迟略有改善
        "net.ipv4.tcp_congestion_control" = "bbr";
        "net.core.default_qdisc" = "cake";
      };
    };

    # network tools that are helpful and nice to have
    environment.systemPackages = with pkgs; [
      mtr
      tcpdump
      traceroute
    ];

    wktlnix = {
      user = {
        extraGroups = [
          "network"
          # "networkmanager"
          # "wireshark"
        ];
      };
    };

    networking = {
      # hosts =
      #   {
      #     "127.0.0.1" = cfg.hosts."127.0.0.1" or [];
      #   }
      #   // cfg.hosts;

      nameservers = ["1.1.1.1" "8.8.8.8" "8.8.4.4"];
    };

    services = {
      dnsmasq = {
        enable = true;

        # resolveLocalQueries = true;

        settings = {
          server = ["1.1.1.1" "8.8.8.8" "8.8.4.4"];
        };
      };

      # resolved = {
      #   enable = true;
      #   domains = ["~."];
      #   dnsovertls = "true";
      #   fallbackDns = ["114.114.114.114"];
      # };
    };
  };
}
