{
  lib,
  stdenvNoCC,
  _sources,
  ...
}:
stdenvNoCC.mkDerivation {
  inherit (_sources.v2ray-rules-dat) pname src;

  version = _sources.v2ray-rules-dat.date;

  installPhase = ''
    runHook preInstall
    install -Dm444 -t "$out/share" $src/{geoip,geosite}.dat
    runHook postInstall
  '';

  meta = {
    description = "V2Ray routing rules file enhanced version";
    homepage = "https://github.com/Loyalsoldier/v2ray-rules-dat";
    maintainers = with lib.maintainers; [ lcx12901 ];
  };
}
