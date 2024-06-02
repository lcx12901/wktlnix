{
  stdenvNoCC,
  fetchurl,
  nix-update-script,
  namespace,
}:
stdenvNoCC.mkDerivation rec {
  name = "${namespace}.country-mmdb";

  src = fetchurl {
    url = "https://cdn.jsdelivr.net/gh/DustinWin/ruleset_geodata@clash/Country-ASN.mmdb";
    sha256 = "sha256-5rXWMY5OxTImVQgDHaFrkbbUq4/eFJ5DGSYUkKTZt0c=";
  };

  dontUnpack = true;

  installPhase = ''
    runHook preInstall
    install -Dm 0644 $src -D $out/Country-ASN.mmdb
    runHook postInstall
  '';

  passthru = {
    updateScript = nix-update-script {};
  };

  meta = {
    description = "Create smarter, safer digital experiences with accurate data";
    homepage = "https://github.com/Dreamacro/maxmind-geoip";
    maintainers = ["lcx12901"];
  };
}