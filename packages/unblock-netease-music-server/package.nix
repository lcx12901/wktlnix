{
  stdenv,
  fetchFromGitHub,
  ...
}:
stdenv.mkDerivation {
  pname = "unblock-netease-music-server";
  version = "2025-11-06";

  src = fetchFromGitHub {
    owner = "UnblockNeteaseMusic";
    repo = "server";
    rev = "47d6b1d918f8dbf6160b8fa07cd17a9480285005";
    hash = "sha256-qTX//oqwZuz/RyR6YJt4oGx2G0IcTiV7n6OXP+rUORM=";
  };

  installPhase = ''
    mkdir -p $out/app
    cp -r $src/precompiled/* $out/app/
    cp -r $src/*.crt $out/app/
    cp $src/*.key $out/app/
  '';
}
