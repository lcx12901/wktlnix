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
  version = "1.1.0-beta.10";

  src = fetchFromGitHub {
    owner = "CortexReach";
    repo = "memory-lancedb-pro";
    rev = "02b97bb7ba0123c127179b3f0d8f249b136fce11";
    hash = "sha256-u7EHHSh4cWSJrTWiCnxqh/98JDzTMc7dsrn2qLJMqCM=";
  };

  npmDepsHash = "sha256-pPGJn9mVbncyHxPtULSv56d4T4OQjXHWyCV3WI+2OfQ=";
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
