{
  buildNpmPackage,
  fetchFromGitHub,
  nodejs_22,
  ...
}:
let
  nodejs = nodejs_22;
in
buildNpmPackage {
  pname = "memory-lancedb-pro";
  version = "2026.05.15";

  src = fetchFromGitHub {
    owner = "CortexReach";
    repo = "memory-lancedb-pro";
    rev = "38eba06cc459d9d9f1f8eadb418f3ae446502188";
    hash = "sha256-bxKDSzJI4KRT7geyiWwaGHIaiSbhCsqkxEu1//5wKKM=";
  };

  npmDepsHash = "sha256-wqX0kAzxEtgAHPvGLby8/p4tqxARLvV6LV9otNaJwNA=";
  inherit nodejs;

  dontNpmBuild = true;
  doCheck = false;

  installPhase = ''
    runHook preInstall

    mkdir -p $out

    install -Dm0644 package.json $out/package.json
    install -Dm0644 package-lock.json $out/package-lock.json
    install -Dm0644 openclaw.plugin.json $out/openclaw.plugin.json
    install -Dm0644 index.ts $out/index.ts
    install -Dm0644 cli.ts $out/cli.ts

    cp -r --no-preserve=mode,ownership,timestamps,links src skills node_modules $out/

    runHook postInstall
  '';
}