# This file was generated by nvfetcher, please do not modify it manually.
{ fetchFromGitHub, dockerTools }:
{
  logger-nvim = {
    pname = "logger-nvim";
    version = "63dd10c9b9a159fd6cfe08435d9606384ff103c5";
    src = fetchFromGitHub {
      owner = "rmagatti";
      repo = "logger.nvim";
      rev = "63dd10c9b9a159fd6cfe08435d9606384ff103c5";
      fetchSubmodules = false;
      sha256 = "sha256-4xQFk7+3NWEx1XUZApy4Ldi2xdsna+HdkOmq9vWP3B0=";
    };
    date = "2025-03-09";
  };
  v2ray-rules-dat = {
    pname = "v2ray-rules-dat";
    version = "f7a316e48676600a64491649180d9adc323efe9c";
    src = fetchFromGitHub {
      owner = "Loyalsoldier";
      repo = "v2ray-rules-dat";
      rev = "f7a316e48676600a64491649180d9adc323efe9c";
      fetchSubmodules = false;
      sha256 = "sha256-I3vNFCgJSyLbkc1soUvqhZEoutw1CPSZM/ly/+pPd/E=";
    };
    date = "2025-04-14";
  };
  waydroid_script = {
    pname = "waydroid_script";
    version = "767267ac1798c1a4530cad3bbafd1d8d9d6556e6";
    src = fetchFromGitHub {
      owner = "huakim";
      repo = "waydroid_script";
      rev = "767267ac1798c1a4530cad3bbafd1d8d9d6556e6";
      fetchSubmodules = false;
      sha256 = "sha256-lKXO6LOXegc3bWZEjjd91bC3QU3wf974cBOaFG2a3IQ=";
    };
    date = "2025-04-07";
  };
}
