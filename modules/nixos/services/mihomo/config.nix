{
  port = 7890;
  socks-port = 7891;
  allow-lan = true;
  mode = "Rule";
  log-level = "info";
  external-controller = ":9090";
  routing-mark = 6666;
  unified-delay = true;
  tcp-concurrent = true;
  geodata-mode = true;
  geodata-loader = "standard";
  geo-auto-update = false;
  find-process-mode = "strict";
  global-client-fingerprint = "chrome";

  profile = {
    store-selected = true;
    store-fake-ip = true;
  };

  dns = {
    enable = true;
    ipv6 = true;
    enhanced-mode = "fake-ip";
    fake-ip-range = "198.18.0.1/16";
    fake-ip-filter = [
      "*"
      "+.lan"
      "+.local"
    ];
    prefer-h3 = true;
    nameserver-policy = {
      "geosite:cn" = [
        "https://dns.alidns.com/dns-query#h3=true"
      ];
    };
    nameserver = [
      "https://doh2.fly.dev/dns-query"
      "https://namlaf919j.cloudflare-gateway.com/dns-query"
      "https://2owhqznrdt.cloudflare-gateway.com/dns-query"
    ];
  };

  sniffer = {
    enable = true;
    sniff = {
      TLS = {
        ports = [
          443
          8443
        ];
      };
      HTTP = {
        ports = [
          80
          "8080-8880"
        ];
        override-destination = true;
      };
    };
  };

  tun = {
    enable = true;
    stack = "mixed";
    dns-hijack = [
      "any:53"
      "tcp://any:53"
    ];
    auto-route = true;
    auto-redirect = true;
    auto-detect-interface = true;
    strict-route = true;
  };

  proxy-providers = {
    nodes = {
      type = "file";
      path = "./nodes.yaml";
    };
  };

  proxy-groups = [
    {
      name = "手动选择";
      type = "select";
      interval = 300;
      url = "http://cp.cloudflare.com/";
      icon = "https://raw.githubusercontent.com/Orz-3/mini/master/Color/Static.png";
      use = [ "nodes" ];
    }
    {
      name = "负载均衡";
      type = "load-balance";
      interval = 300;
      url = "http://cp.cloudflare.com/";
      icon = "https://raw.githubusercontent.com/Orz-3/mini/master/Color/Available.png";
      use = [ "nodes" ];
    }
    {
      name = "Game";
      type = "select";
      interval = 300;
      url = "http://cp.cloudflare.com/";
      icon = "https://raw.githubusercontent.com/Orz-3/mini/master/Color/Pornhub.png";
      use = [ "nodes" ];
      proxies = [ "DIRECT" ];
    }
    {
      name = "fallback";
      type = "select";
      interval = 300;
      url = "http://cp.cloudflare.com/";
      icon = "https://raw.githubusercontent.com/Orz-3/mini/master/Color/Personal.png";
      proxies = [
        "负载均衡"
        "手动选择"
        "DIRECT"
      ];
    }
  ];

  rules = [
    "PROCESS-NAME,aria2c,DIRECT"
    "PROCESS-NAME,inadyn,DIRECT"
    "PROCESS-NAME,cs2,Game"
    "DST-PORT,4950/4955,Game"
    "DST-PORT,6696-6699,Game"
    "DOMAIN-SUFFIX,warframe.com,Game"
    "GEOSITE,tiktok,fallback"
    "GEOSITE,category-ads-all,REJECT"
    "GEOSITE,CN,DIRECT"
    "GEOIP,CN,DIRECT"
    "GEOSITE,geolocation-cn,DIRECT"
    "DOMAIN-SUFFIX,lincx.top,DIRECT"
    "DOMAIN-SUFFIX,nnkj.eu.org,DIRECT"
    "DOMAIN-SUFFIX,lincx.eu.org,DIRECT"
    "DOMAIN-SUFFIX,steamcommunity.com,fallback"
    "DOMAIN-SUFFIX,steampowered.com,fallback"
    "DOMAIN-SUFFIX,fastly.steamstatic.com,fallback"
    "GEOSITE,steam,DIRECT"
    "MATCH,fallback"
  ];
}
