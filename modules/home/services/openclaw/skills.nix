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
          hash = "sha256-quHCIQFaohSc5FOOOM65vMOG1I9OMdjfU6vLdoaxgeg=";
        };
        buildInputs = [ pkgs.unzip ];
      }
      ''
        unzip $src
        mkdir -p $out
        cp SKILL.md handler.ts $out/
      '';

  productManagerSkills = pkgs.fetchFromGitHub {
    owner = "deanpeters";
    repo = "Product-Manager-Skills";
    rev = "main";
    hash = "sha256-bBNtzTVwrlCh8itSNKMIKvbPXV1+39W/VrK090lxncE=";
  };

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
    }) dir;

  # ui-ux-pro-max-skill (from GitHub)
  uiUxProMaxRepo = pkgs.fetchFromGitHub {
    owner = "nextlevelbuilder";
    repo = "ui-ux-pro-max-skill";
    rev = "b7e3af80f6e331f6fb456667b82b12cade7c9d35";
    hash = "sha256-tgGnZt6ITH8IDPqglNDC1JCt5ZkVMGcET9IbP0vITjo=";
  };

  uiUxProMax =
    pkgs.runCommand "ui-ux-pro-max"
      {
        src = uiUxProMaxRepo;
        buildInputs = [ pkgs.python3 ];
      }
      ''
        mkdir -p $out
        cp -rL $src/.claude/skills/* $out/
      '';

  uiUxProMaxSkillList =
    let
      dir = builtins.readDir "${uiUxProMax}";
    in
    pkgs.lib.mapAttrsToList (name: _: {
      inherit name;
      source = "${uiUxProMax}/${name}";
    }) dir;

  # ClawHub skills
  designReview =
    pkgs.runCommand "design-review"
      {
        src = pkgs.fetchurl {
          url = "https://wry-manatee-359.convex.site/api/v1/download?slug=design-review";
          hash = "sha256-ae0o88hUtdU76/B0W19rUJbEd+gljrfduuxEV2YbMNc=";
        };
        buildInputs = [ pkgs.unzip ];
      }
      ''
        unzip $src
        mkdir -p $out
        cp -r * $out/
      '';

  react =
    pkgs.runCommand "react"
      {
        src = pkgs.fetchurl {
          url = "https://wry-manatee-359.convex.site/api/v1/download?slug=react";
          hash = "sha256-gQtE3UEEJieHZ2v40Oiw3GYX1qyFRWOnCF42xgezdOQ=";
        };
        buildInputs = [ pkgs.unzip ];
      }
      ''
        unzip $src
        mkdir -p $out
        cp -r * $out/
      '';

  tailwindcss =
    pkgs.runCommand "tailwindcss"
      {
        src = pkgs.fetchurl {
          url = "https://wry-manatee-359.convex.site/api/v1/download?slug=tailwindcss";
          hash = "sha256-8jkEm5xdmf9q11nkKD7MSuJBdLuZWb0eAElYJObuWlY=";
        };
        buildInputs = [ pkgs.unzip ];
      }
      ''
        unzip $src
        mkdir -p $out
        cp -r * $out/
      '';

  shadcnUi =
    pkgs.runCommand "shadcn-ui"
      {
        src = pkgs.fetchurl {
          url = "https://wry-manatee-359.convex.site/api/v1/download?slug=shadcn-ui";
          hash = "sha256-YiU4kU92jHRlqm0bIsS/XBKSNE0fWY1iphLkUbncPMk=";
        };
        buildInputs = [ pkgs.unzip ];
      }
      ''
        unzip $src
        mkdir -p $out
        cp -r * $out/
      '';

  responsiveDesign =
    pkgs.runCommand "responsive-design"
      {
        src = pkgs.fetchurl {
          url = "https://wry-manatee-359.convex.site/api/v1/download?slug=responsive-design";
          hash = "sha256-2RqexgiSCXdScw/5U8rIyQ3Np8FJkvH65/E65AANZas=";
        };
        buildInputs = [ pkgs.unzip ];
      }
      ''
        unzip $src
        mkdir -p $out
        cp -r * $out/
      '';

  a11y =
    pkgs.runCommand "a11y"
      {
        src = pkgs.fetchurl {
          url = "https://wry-manatee-359.convex.site/api/v1/download?slug=a11y";
          hash = "sha256-O3mdINISbCXqfOLl/+QIbxNO8ooYpm9OZbngpFHUZaM=";
        };
        buildInputs = [ pkgs.unzip ];
      }
      ''
        unzip $src
        mkdir -p $out
        cp -r * $out/
      '';

in
[
  {
    name = "self-improving-agent";
    source = "${selfImprovingAgent}";
  }
  {
    name = "multi-search-engine";
    source = "${openclawMasterSkills}/skills/multi-search-engine";
  }
  {
    name = "sovereign-commit-craft";
    source = "${sovereignCommitCraft}";
  }
  {
    name = "capability-evolver-pro";
    source = "${capabilityEvolverPro}";
  }
  {
    name = "code-review";
    source = "${auditCode}";
  }
  {
    name = "leaferjs";
    source = "${leaferjsSkills}/skills/leafer-ai";
  }
  {
    name = "design-review";
    source = "${designReview}";
  }
  {
    name = "react";
    source = "${react}";
  }
  {
    name = "tailwindcss";
    source = "${tailwindcss}";
  }
  {
    name = "shadcn-ui";
    source = "${shadcnUi}";
  }
  {
    name = "responsive-design";
    source = "${responsiveDesign}";
  }
  {
    name = "a11y";
    source = "${a11y}";
  }
]
++ antfuSkillList
++ pmSkillList
++ uiUxProMaxSkillList
