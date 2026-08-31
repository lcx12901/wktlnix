{
  buildNpmPackage,
  fetchurl,
  jq,
  lib,
  runCommand,
}:
let
  version = "1.4.4";

  tarball = fetchurl {
    url = "https://registry.npmjs.org/@okx_ai/okx-trade-cli/-/okx-trade-cli-${version}.tgz";
    hash = "sha256-rX56NW0SPr17FJbvZTcwfRzmUoW4wDDbo8zU9doYGAg=";
  };

  # 已发布 tarball 的 devDependencies 含 "file:../core"（@agent-tradekit/core），
  # 该相对路径在独立构建时不成立，会令 npm ci 失败——故剥离 devDependencies，
  # 并用仓库内的 package-lock.json（已按剥离后的 package.json 重新生成）构建。
  src = runCommand "okx-trade-cli-src" { } ''
    mkdir -p $out
    tar -xzf ${tarball} -C $out --strip-components=1
    ${jq}/bin/jq 'del(.devDependencies)' $out/package.json > $out/package.json.tmp
    mv $out/package.json.tmp $out/package.json
    cp ${./package-lock.json} $out/package-lock.json
  '';
in
buildNpmPackage {
  pname = "okx-trade-cli";
  inherit version src;

  npmDepsHash = "sha256-ls2HxEd8Ra1sOF3BsHTyclP5Fy/pcGeAXExThnpIPEA=";

  # 已发布 tarball 自带预构建 dist/，无需 npm run build
  dontNpmBuild = true;

  meta = {
    description = "OKX 官方命令行工具（@okx_ai/okx-trade-cli）：行情、交易、资产与策略机器人管理";
    license = lib.licenses.mit;
    platforms = lib.platforms.linux;
    mainProgram = "okx";
  };
}
