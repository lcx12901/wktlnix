# This file was generated by nvfetcher, please do not modify it manually.
{ fetchgit, fetchurl, fetchFromGitHub, dockerTools }:
{
  glow-yazi = {
    pname = "glow-yazi";
    version = "c76bf4fb612079480d305fe6fe570bddfe4f99d3";
    src = fetchFromGitHub {
      owner = "Reledia";
      repo = "glow.yazi";
      rev = "c76bf4fb612079480d305fe6fe570bddfe4f99d3";
      fetchSubmodules = false;
      sha256 = "sha256-DPud1Mfagl2z490f5L69ZPnZmVCa0ROXtFeDbEegBBU=";
    };
    date = "2025-02-23";
  };
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
  miller-yazi = {
    pname = "miller-yazi";
    version = "40e02654725a9902b689114537626207cbf23436";
    src = fetchFromGitHub {
      owner = "Reledia";
      repo = "miller.yazi";
      rev = "40e02654725a9902b689114537626207cbf23436";
      fetchSubmodules = false;
      sha256 = "sha256-GXZZ/vI52rSw573hoMmspnuzFoBXDLcA0fqjF76CdnY=";
    };
    date = "2024-08-28";
  };
  ouch-yazi = {
    pname = "ouch-yazi";
    version = "ce6fb75431b9d0d88efc6ae92e8a8ebb9bc1864a";
    src = fetchFromGitHub {
      owner = "ndtoan96";
      repo = "ouch.yazi";
      rev = "ce6fb75431b9d0d88efc6ae92e8a8ebb9bc1864a";
      fetchSubmodules = false;
      sha256 = "sha256-oUEUGgeVbljQICB43v9DeEM3XWMAKt3Ll11IcLCS/PA=";
    };
    date = "2025-01-31";
  };
  v2ray-rules-dat = {
    pname = "v2ray-rules-dat";
    version = "36abb182759b748c803fb981df1c8a77f3dd609d";
    src = fetchFromGitHub {
      owner = "Loyalsoldier";
      repo = "v2ray-rules-dat";
      rev = "36abb182759b748c803fb981df1c8a77f3dd609d";
      fetchSubmodules = false;
      sha256 = "sha256-bUj8U9Y3Kny8kUQbbcDxSmp4X1tlAyeqyKPDsg0so60=";
    };
    date = "2025-03-25";
  };
  waydroid_script = {
    pname = "waydroid_script";
    version = "3cfa1e43e7da4b0c07a4c83d331e4776012e2acd";
    src = fetchFromGitHub {
      owner = "huakim";
      repo = "waydroid_script";
      rev = "3cfa1e43e7da4b0c07a4c83d331e4776012e2acd";
      fetchSubmodules = false;
      sha256 = "sha256-O29v/lF2YCUhyCo+M7Sesoes0MObHsS2tutW88rOM/U=";
    };
    date = "2024-12-15";
  };
}
