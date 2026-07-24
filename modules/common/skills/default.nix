{ pkgs, lib }:

let
  # Fetch a GitHub repository once
  fetchRepo =
    {
      owner,
      repo,
      rev,
      sha256,
    }:
    pkgs.fetchFromGitHub {
      inherit
        owner
        repo
        rev
        sha256
        ;
    };

  # antfu/skills repository
  antfuSkillsRepo = fetchRepo {
    owner = "antfu";
    repo = "skills";
    rev = "a74f281a27dadc02397bc1a174b0f2c97531b6ae";
    sha256 = "sha256-30PslbWFbtoip1B+WW5DjQhyTo0R+umqGSylsXzdTUs=";
  };

  qingsheng = fetchRepo {
    owner = "tomwong001";
    repo = "qingsheng-skill";
    rev = "ea23b10376b146abfcff20f71876889a0453a7e7";
    sha256 = "sha256-Rd8D8Rkzc3q+bnpA3JT4U96LXgk7g0FJBbQoPPTdtbU=";
  };

  # Local skills directory (this module's directory)
  localSkillsDir = ./.;

  # Auto-discover skills from a repo's skills directory
  # Returns: { name = { repo; path; }; }
  discoverSkills =
    repo: skillsDir:
    let
      entries = builtins.readDir (repo + "/${skillsDir}");
      # Filter to only directories (actual skills)
      dirs = lib.filterAttrs (_: kind: kind == "directory") entries;
      # Filter to only directories that contain SKILL.md
      validSkills = lib.filterAttrs (
        name: _: builtins.pathExists (repo + "/${skillsDir}/${name}/SKILL.md")
      ) dirs;
      # Map to skill definitions
      defs = lib.mapAttrsToList (name: _: {
        inherit name;
        value = {
          inherit repo;
          path = "${skillsDir}/${name}";
        };
      }) validSkills;
    in
    lib.listToAttrs defs;

  # Pick specific skills from a repo (instead of auto-discovering all)
  # Supports two formats:
  #   - String: "skill-name" (uses original name)
  #   - AttrSet: { name = "custom-name"; path = "original-path"; } (supports renaming)
  # Returns: { name = { repo; path; }; }
  pickSkills =
    repo: skillsDir: skillNames:
    let
      processSkill =
        skill:
        if builtins.isString skill then
          {
            name = skill;
            value = {
              inherit repo;
              path = "${skillsDir}/${skill}";
            };
          }
        else
          {
            inherit (skill) name;
            value = {
              inherit repo;
              path = "${skillsDir}/${skill.path}";
            };
          };
      defs = map processSkill skillNames;
    in
    lib.listToAttrs defs;

  # Skill sources: list of { repo, skillsDir, skills? } to scan
  # If skills is provided, only those are included; otherwise auto-discover all
  skillSources = [
    # Local skills (defined in this directory)
    {
      repo = localSkillsDir;
      skillsDir = ".";
    }
    # Remote skill repositories
    {
      repo = antfuSkillsRepo;
      skillsDir = "skills";
    }
    {
      repo = qingsheng;
      skillsDir = ".";
      # qingsheng-skill is a single skill, rename to match repo name
      skills = [
        {
          name = "qingsheng";
          path = "skill";
        }
      ];
    }
  ];

  # Build skill definitions from sources
  buildSkillDefs =
    sources:
    let
      processSource =
        source:
        if source ? skills then
          pickSkills source.repo source.skillsDir source.skills
        else
          discoverSkills source.repo source.skillsDir;
    in
    lib.foldl' (acc: source: acc // processSource source) { } sources;

  # Auto-discover and merge all skills from all sources
  skillDefs = buildSkillDefs skillSources;

  # Build all skills into a single directory
  # Each skill goes into its own subdirectory: $out/<skill-name>/
  buildSkills =
    skills:
    let
      # Create a mapping of skill name -> derivation
      drvMap = lib.mapAttrs (
        name: def:
        pkgs.runCommand "skill-${name}" { } ''
          mkdir -p $out
          cp -r ${def.repo}/${def.path}/* $out/
        ''
      ) skills;
    in
    pkgs.runCommand "skills-collection" { } ''
      mkdir -p $out
      ${lib.concatStringsSep "\n" (
        map (name: "mkdir -p $out/${name} && cp -r ${drvMap.${name}}/* $out/${name}/") (
          builtins.attrNames drvMap
        )
      )}
    '';

  # All skills aggregated
  allSkills = buildSkills skillDefs;

  # Harness-specific skill filters
  harnessSkillFilters = {
    # opencode = { exclude = [ "hermes-only-skill" ]; };
  };

  # Filter skills for a specific harness
  skillsForHarness =
    harnessName:
    let
      exclude = (harnessSkillFilters.${harnessName} or { }).exclude or [ ];
      shouldKeep = name: !(lib.elem name exclude);

      shouldKeepPath =
        path:
        let
          relPath = lib.removePrefix (toString allSkills + "/") (toString path);
          topLevel = if relPath == "" then "" else lib.head (lib.splitString "/" relPath);
        in
        topLevel == "" || shouldKeep topLevel;
    in
    if exclude == [ ] then
      allSkills
    else
      builtins.filterSource (path: _: shouldKeepPath path) allSkills;

in
{
  inherit
    skillDefs
    allSkills
    skillsForHarness
    ;

  # Filtered skills for each harness
  opencode = skillsForHarness "opencode";
}
