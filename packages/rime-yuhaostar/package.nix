{
  stdenv,
  fetchurl,
  unzip,
}:
stdenv.mkDerivation {
  pname = "rime-yuhaostar";
  version = "v3.10.0";
  src = fetchurl {
    url = "https://github.com/forfudan/yuhao-ime-release/releases/download/v3.10.0/star_xingchen_v3.10.0.zip";
    name = "yustar_v3.10.0.zip";
    sha256 = "sha256-fw4DxYyONb1ZkoIiLc/TRPw5jBy7RcM1JLF4HfEvgrQ=";
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
