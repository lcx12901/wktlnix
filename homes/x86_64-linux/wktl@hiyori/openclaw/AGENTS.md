# OpenClaw Skills 管理

## 架构

```
openclaw/
├── default.nix    # 主配置，通过 import ./skills.nix 引入 skills
├── skills.nix     # 所有 skill 的集中定义
└── documents/     # workspace 文档
```

## Skills 与 Plugins 的区别

| | customPlugins | skills |
|---|---|---|
| 适用对象 | 带 `openclawPlugin` flake 输出的插件 | 普通 Clawhub skill（SKILL.md + 脚本） |
| 接入方式 | `builtins.getFlake` 解析 flake 输入 | `fetchFromGitHub` 下载源码 |
| 部署方式 | 插件目录 | 复制到 workspace 的 `skills/<name>/` |

**self-improving-agent** 属于 skill，因此使用 `skills` 机制。

## 如何添加新的 Skill

编辑 `skills.nix`，在 `let` 中添加 fetch，在列表中添加条目：

```nix
{ pkgs, lib }:

let
  existingSkill = pkgs.fetchFromGitHub {
    owner = "author";
    repo = "some-skill";
    rev = "<commit-hash>";
    hash = "sha256-<sri-hash>";
  };

  newSkill = pkgs.fetchFromGitHub {
    owner = "author";
    repo = "new-skill";
    rev = "<full-commit-hash>";
    hash = "sha256-<sri-hash>";
  };
in [
  {
    name = "existing-skill";
    source = "${existingSkill}";
    mode = "copy";
  }
  {
    name = "new-skill";
    source = "${newSkill}";
    mode = "copy";
  }
]
```

## 获取 SRI Hash

`fetchFromGitHub` 的 `hash` 属性需要 SRI 格式（`sha256-<base64>`），不要直接用 `nix-prefetch-url --unpack` 的输出（那是 base32 格式）。

正确做法：

```bash
# 1. 先获取 base32 hash
nix-prefetch-url --unpack "https://github.com/owner/repo/archive/<commit>.tar.gz"

# 2. 转换为 SRI 格式
nix hash convert --hash-algo sha256 "<base32-hash>"
```

或者一次性完成：

```bash
nix-prefetch-github owner repo --rev <commit>
```

然后把输出的 `hash` 值填入 `skills.nix`。

## 验证

```bash
cd /home/wktl/Coding/wktlnix
nix flake check
```

这会评估所有 NixOS 配置（包括 openclaw module），确保 skills 定义能正确求值。
