{
  lib,
  buildNpmPackage,
  fetchurl,
  ...
}:
buildNpmPackage rec {
  pname = "unocss-language-server";

  version = "0.1.7";

  src = fetchurl {
    url = "https://registry.npmjs.org/unocss-language-server/-/unocss-language-server-${version}.tgz";
    sha256 = "sha256-r3pxqhbe2BxGNQCjbC65uhM8EVq9aB+9tOgiEvz52T4=";
  };

  npmDepsHash = "sha256-Jalcf+qc6okhGNQHWojqLof4rEimUKTShU9xIn1LNZk=";

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
