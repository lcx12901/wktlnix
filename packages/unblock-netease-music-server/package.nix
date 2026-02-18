{
  stdenv,
  fetchFromGitHub,
  ...
}:
stdenv.mkDerivation {
  pname = "unblock-netease-music-server";
  version = "2025-02-08";

  src = fetchFromGitHub {
    owner = "UnblockNeteaseMusic";
    repo = "server";
    rev = "7aa15ad92d44159d8f1ffcd94338207947cdbff2";
    hash = "sha256-DFN8kgrapafkUS5Q0fwnC8B2w+bzWUiNs2J0v9rOGDA=";
  };

  installPhase = ''
    mkdir -p $out/app
    cp -r $src/precompiled/* $out/app/
  '';
}
