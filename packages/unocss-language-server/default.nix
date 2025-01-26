{
  lib,
  buildNpmPackage,
  fetchurl,
  ...
}:
buildNpmPackage rec {
  pname = "unocss-language-server";

  version = "0.1.5";

  src = fetchurl {
    url = "https://registry.npmjs.org/unocss-language-server/-/unocss-language-server-${version}.tgz";
    sha256 = "sha256-kreygtkQG7Dhd0MPs2Ee2rr60++yCxHcSNcpEFcQ8ng=";
  };

  npmDepsHash = "sha256-GqZqVUcNHP5+4t7p5vc4sUGa7XqJbePSpQxfKcWu4Lo=";

  postPatch = ''
    ln -s ${./package-lock.json} package-lock.json
  '';

  dontNpmBuild = true;

  meta = {
    description = "A language server for unocss";
    homepage = "https://github.com/xna00/unocss-language-server#readme";
    changelog = "https://github.com/vuejs/language-tools/releases/tag/v${version}";
    license = lib.licenses.mit;
    maintainers = with lib.maintainers; [ lcx12901 ];
    mainProgram = "unocss-language-server";
  };
}
