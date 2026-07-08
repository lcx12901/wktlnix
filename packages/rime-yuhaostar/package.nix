{
  stdenv,
  fetchurl,
  unzip,
}:
stdenv.mkDerivation {
  pname = "rime-yuhaostar";
  version = "v3.12.0";
  src = fetchurl {
    url = "https://github.com/forfudan/yuhao-ime-release/releases/download/v3.12.0/xingchen_v3.12.0.zip";
    name = "xingchen_v3.12.0.zip";
    sha256 = "sha256-cRaJqB9iUHrQGIfMCbuksG0FWlMZojTue3cjp5H9Z8k=";
  };
  nativeBuildInputs = [ unzip ];

  sourceRoot = "schema";

  patches = [
    ./key_binder.patch
  ];

  installPhase = ''
    runHook preInstall

    mkdir -p $out/share/rime-data
    cp -rt $out/share/rime-data -- ./*
    rm $out/share/rime-data/default.custom.yaml

    runHook postInstall
  '';
}
