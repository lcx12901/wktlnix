{
  buildNpmPackage,
  fetchurl,
}:
buildNpmPackage rec {
  pname = "unocss-language-server";
  version = "0.1.5";
  src = fetchurl {
    url = "https://registry.npmjs.org/unocss-language-server/-/unocss-language-server-${version}.tgz";
    hash = "sha256-kreygtkQG7Dhd0MPs2Ee2rr60++yCxHcSNcpEFcQ8ng=";
  };

  npmDepsHash = "sha256-VvXkQQ4FxFK7umqEX50yNlfQNihqEyYdK09k74t8Sq8=";

  dontNpmBuild = true;

  # Manually generate the current version of the package-lock
  postPatch = ''
    ln -s ${./package-lock.json} package-lock.json
  '';
}
