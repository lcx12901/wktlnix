{
  lib,
  stdenvNoCC,
  fetchurl,
  nix-update-script,
  namespace,
}:
stdenvNoCC.mkDerivation rec {
  name = "${namespace}.country-mmdb";
  version = "20240512";

  src = fetchurl {
    url = "https://github.com/Dreamacro/maxmind-geoip/releases/download/${version}/Country.mmdb";
    sha256 = "sha256-vWtiTcuTcAL6E083rHPVhqduIs6tuAOph/EdwLFXHek=";
  };

  dontUnpack = true;

  installPhase = ''
    runHook preInstall
    mkdir -p $out/var/lib/private/mihomo
    install -Dm 0644 $src -D $out/var/lib/private/mihomo/Country.mmdb
    runHook postInstall
  '';

  passthru = {
    updateScript = nix-update-script {};
  };

  meta = with lib; {
    description = "Create smarter, safer digital experiences with accurate data";
    homepage = "https://github.com/Dreamacro/maxmind-geoip";
    license = licenses.unfree;
    maintainers = ["lcx12901"];
  };
}