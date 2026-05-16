{
  stdenv,
  fetchurl,
  unzip,
}:
stdenv.mkDerivation {
  pname = "rime-yuhaostar";
  version = "v3.11.0";
  src = fetchurl {
    url = "https://github.com/forfudan/yuhao-ime-release/releases/download/v3.11.0/xingchen_v3.11.0.zip";
    name = "xingchen_v3.11.0.zip";
    sha256 = "sha256-o9Ht+Va0ccr0N2hjuN+3F6biXFUdsrfxh/RF8c70t6U=";
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