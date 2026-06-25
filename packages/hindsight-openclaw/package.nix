{
  buildNpmPackage,
  fetchurl,
}:

let
  version = "0.6.0";
in
buildNpmPackage {
  pname = "hindsight-openclaw";
  inherit version;

  src = fetchurl {
    url = "https://registry.npmjs.org/@vectorize-io/hindsight-openclaw/-/hindsight-openclaw-${version}.tgz";
    hash = "sha256-hAc+tVlHxe8ks+U3b+n0bRpgJ5/1rF/jzN88Rkns9h0=";
  };

  npmDepsHash = "sha256-uySF7BWOey4MfWVnHwgQkON3ZTl399VlNUyb5bfonEo=";

  # Pre-generated shrinkwrap (built offline, committed to repo)
  postPatch = ''
    cp ${./npm-shrinkwrap.json} ./npm-shrinkwrap.json
    rm -f package-lock.json
  '';

  # No build step needed
  dontNpmBuild = true;

  installPhase = ''
    runHook preInstall

    # Copy everything to output
    mkdir -p $out
    cp -r . $out/

    runHook postInstall
  '';
}
