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
    rev = "50deaeb269d80d92db7a2c5a677290309ae307fc";
    sha256 = "sha256-FAyqk2uhWwXt1fmZZdftnjPSvNFAtB73M2AJueHy4TY=";
  };

  # Auto-discover skills from a repo's skills directory
  # Returns: { name = { repo; path; }; }
  discoverSkills =
    repo: skillsDir:
    let
      entries = builtins.readDir (repo + "/${skillsDir}");
      # Filter to only directories (actual skills)
      dirs = lib.filterAttrs (_: kind: kind == "directory") entries;
      # Map to skill definitions
      defs = lib.mapAttrsToList (name: _: {
        inherit name;
        value = {
          inherit repo;
          path = "${skillsDir}/${name}";
        };
      }) dirs;
    in
    lib.listToAttrs defs;

  # Skill sources: list of { repo, skillsDir } to scan
  skillSources = [
    {
      repo = antfuSkillsRepo;
      skillsDir = "skills";
    }
  ];

  # Auto-discover and merge all skills from all sources
  skillDefs = lib.foldl' (
    acc: source: acc // discoverSkills source.repo source.skillsDir
  ) { } skillSources;

  # Build all skills into a single directory
  # Each skill goes into its own subdirectory: $out/<skill-name>/
  buildSkills =
    skills:
    let
      derivations = lib.mapAttrsToList (
        name: def:
        pkgs.runCommand "skill-${name}" { } ''
          mkdir -p $out
          cp -r ${def.repo}/${def.path}/* $out/
        ''
      ) skills;

      # Create a mapping of derivation name -> derivation
      drvMap = lib.listToAttrs (
        map (drv: {
          inherit (drv) name;
          value = drv;
        }) derivations
      );
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
    # hermes = { exclude = [ "opencode-only-skill" ]; };
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
  inherit skillDefs allSkills skillsForHarness;

  # Filtered skills for each harness
  opencode = skillsForHarness "opencode";
  hermes = skillsForHarness "hermes";
}
