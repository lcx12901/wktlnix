{
  stdenvNoCC,
  fetchurl,
  runCommand,
  nodejs,
  pnpm_11,
  fetchPnpmDeps,
  pnpmConfigHook,
}:

let
  pnpm = pnpm_11;
  version = "0.6.0";

  # Unpacked tarball + pnpm-lock.yaml merged into a single source.
  # fetchPnpmDeps requires pnpm-lock.yaml in the source root, but the npm
  # registry tarball doesn't ship one.  We generate it locally and merge.
  src = runCommand "hindsight-openclaw-src" { } ''
    mkdir -p $out
    tar xzf ${
      fetchurl {
        url = "https://registry.npmjs.org/@vectorize-io/hindsight-openclaw/-/hindsight-openclaw-${version}.tgz";
        hash = "sha256-hAc+tVlHxe8ks+U3b+n0bRpgJ5/1rF/jzN88Rkns9h0=";
      }
    } -C $out --strip-components=1
    cp ${./pnpm-lock.yaml} $out/pnpm-lock.yaml
  '';
in
stdenvNoCC.mkDerivation rec {
  pname = "hindsight-openclaw";
  inherit version;
  inherit src;

  nativeBuildInputs = [
    nodejs
    pnpmConfigHook
    pnpm
  ];

  pnpmDeps = fetchPnpmDeps {
    inherit
      pname
      version
      src
      pnpm
      ;
    fetcherVersion = 4;
    hash = "sha256-tH09vDhje5eWSIv9rH23WnCjGYb0sUlb7lfFW9ld7aI=";
  };

  # No build step needed
  dontNpmBuild = true;

  installPhase = ''
    runHook preInstall

    mkdir -p $out
    cp -r . $out/

    runHook postInstall
  '';
}
