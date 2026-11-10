{
  lib,
  python3Packages,
  fetchurl,
}:
let
  # nixpkgs 没有 ulid-py；mnemos 用它给 engram 生成 ULID。发行的 wheel
  # （py2.py3-none-any，纯 Python）可直接安装，无需构建依赖。
  ulid-py = python3Packages.buildPythonPackage {
    pname = "ulid-py";
    version = "1.1.0";
    format = "wheel";
    src = fetchurl {
      url = "https://files.pythonhosted.org/packages/42/7c/a12c879fe6c2b136a718c142115ff99397fbf62b4929d970d58ae386d55f/ulid_py-1.1.0-py2.py3-none-any.whl";
      hash = "sha256-tWoPgJ75DWAgshuJqHpI7cfAOuqA5e1RdBcugtduOYc=";
    };
  };
in
python3Packages.buildPythonApplication {
  pname = "mnemos-continuity";
  version = "0.6.6";

  src = fetchurl {
    url = "https://files.pythonhosted.org/packages/b1/b9/baaff562086160d0301b0d07747f5f921ceb95db5eac42b2c120790aeb79/mnemos_continuity-0.6.6.tar.gz";
    hash = "sha256-UCVbEyq1wj9PgiNBxzTrwYZKtpZTKlTFeASi261Mn/M=";
  };

  pyproject = true;
  build-system = [ python3Packages.hatchling ];

  # mcp 是核心依赖（pyproject 注释：MCP server 是主产品），版本要求
  # >=1.30,<3，nixpkgs 的 2.3.0 满足；mnemos/mcp_compat.py 兼容 1.x/2.x。
  # embeddings extra（sentence-transformers/torch，约 700 MB）默认不装：
  # 上游自己的注释写明 continuity 路径不用 embeddings，召回退化为按词匹配，
  # `mnemos doctor` 会报告当前安装的检索级别。
  dependencies = [
    python3Packages.mcp
    python3Packages.pyyaml
    ulid-py
  ];

  meta = {
    description = "MCP server that gives an AI agent memory that survives between sessions";
    homepage = "https://github.com/Riley-Coyote/mnemos-mcp";
    license = lib.licenses.asl20;
    mainProgram = "mnemos";
    platforms = lib.platforms.unix;
  };
}
