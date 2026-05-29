{ pkgs }:

let
  # Core skills
  selfImprovingAgent = pkgs.fetchFromGitHub {
    owner = "peterskoett";
    repo = "self-improving-agent";
    rev = "109f3ff4c0ad725fff94b8ab4d882aab9728b828";
    hash = "sha256-EfRqAlXbYMhOmsC7HPebmru9RQBOeog0Ve2kvXY5BrA=";
  };

  openclawMasterSkills = pkgs.fetchFromGitHub {
    owner = "LeoYeAI";
    repo = "openclaw-master-skills";
    rev = "262a6243eed2cfeb62e6de72fac7d2ab50e9c40f";
    hash = "sha256-dGNS1EV+PD6NolyFbX3bGboukT2LmTasx7/rM9jjsN8=";
  };

  sovereignCommitCraft =
    pkgs.runCommand "sovereign-commit-craft"
      {
        src = pkgs.fetchurl {
          url = "https://wry-manatee-359.convex.site/api/v1/download?slug=sovereign-commit-craft";
          hash = "sha256-zqAiZ4MuWWOGvdX8X9u0hV2OTd8vG6P75wLKVXd0xQg=";
        };
        buildInputs = [ pkgs.unzip ];
      }
      ''
        unzip $src
        mkdir -p $out
        cp EXAMPLES.md README.md SKILL.md $out/
      '';

  capabilityEvolverPro =
    pkgs.runCommand "capability-evolver-pro"
      {
        src = pkgs.fetchurl {
          url = "https://wry-manatee-359.convex.site/api/v1/download?slug=capability-evolver-pro";
          hash = "sha256-r/683YxAEMcljTLnshH6aUYeViPf7CVXwVBSenhzUtg=";
        };
        buildInputs = [ pkgs.unzip ];
      }
      ''
        unzip $src
        mkdir -p $out
        cp SKILL.md handler.ts $out/
      '';

  # PM Agent skills
  productManagerSkills = pkgs.fetchFromGitHub {
    owner = "deanpeters";
    repo = "Product-Manager-Skills";
    rev = "main";
    hash = "sha256-bBNtzTVwrlCh8itSNKMIKvbPXV1+39W/VrK090lxncE=";
  };

  # Code review skill (audit-code)
  auditCode =
    pkgs.runCommand "audit-code"
      {
        src = pkgs.fetchurl {
          url = "https://wry-manatee-359.convex.site/api/v1/download?slug=audit-code";
          hash = "sha256-NKyzepsM2scSspwBTOlJ+p12rMb8lX3WwKKp35mNy7M=";
        };
        buildInputs = [ pkgs.unzip ];
      }
      ''
        unzip $src
        mkdir -p $out
        cp -r * $out/
      '';

  antfuSkills = pkgs.fetchFromGitHub {
    owner = "antfu";
    repo = "skills";
    rev = "50deaeb269d80d92db7a2c5a677290309ae307fc";
    hash = "sha256-FAyqk2uhWwXt1fmZZdftnjPSvNFAtB73M2AJueHy4TY=";
  };

  antfuSkillList =
    let
      dir = builtins.readDir "${antfuSkills}/skills";
    in
    pkgs.lib.mapAttrsToList (name: _: {
      inherit name;
      source = "${antfuSkills}/skills/${name}";
      mode = "copy";
    }) dir;

  leaferjsSkills = pkgs.fetchFromGitHub {
    owner = "leaferjs";
    repo = "ai-docs";
    tag = "v2.1.2";
    hash = "sha256-B4jbvnXZpl7/zw9jE2UnmrpdlLNLz6FiVL2CsG3fusk=";
  };

  pmSkillList =
    let
      dir = builtins.readDir "${productManagerSkills}/skills";
    in
    pkgs.lib.mapAttrsToList (name: _: {
      inherit name;
      source = "${productManagerSkills}/skills/${name}";
      mode = "copy";
    }) dir;

in
[
  # Core skills
  {
    name = "self-improving-agent";
    source = "${selfImprovingAgent}";
    mode = "copy";
  }
  {
    name = "multi-search-engine";
    source = "${openclawMasterSkills}/skills/multi-search-engine";
    mode = "copy";
  }
  {
    name = "sovereign-commit-craft";
    source = "${sovereignCommitCraft}";
    mode = "copy";
  }
  {
    name = "capability-evolver-pro";
    source = "${capabilityEvolverPro}";
    mode = "copy";
  }

  # Code review skill (audit-code)
  {
    name = "code-review";
    source = "${auditCode}";
    mode = "copy";
  }
  {
    name = "leaferjs";
    source = "${leaferjsSkills}/skills/leafer-ai";
    mode = "copy";
  }
]
++ antfuSkillList
++ pmSkillList
