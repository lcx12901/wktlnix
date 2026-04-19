{
  inputs,
  pkgs,
  ...
}:
let
  uiUxProMaxSrc = pkgs.fetchFromGitHub {
    owner = "nextlevelbuilder";
    repo = "ui-ux-pro-max-skill";
    rev = "b7e3af80f6e331f6fb456667b82b12cade7c9d35";
    sha256 = "0fjfr15ky6yj9w26fc0mk7jsv46lqb89987s1h47yk48vrkaf0dn";
  };

  uiUxProMax =
    pkgs.runCommand "opencode-ui-ux-pro-max"
      {
        nativeBuildInputs = [ pkgs.python3 ];
      }
      ''
        workdir="$(mktemp -d)"
        cp "${uiUxProMaxSrc}/.claude/skills/ui-ux-pro-max/SKILL.md" "$workdir/SKILL.md"
        cp -r "${uiUxProMaxSrc}/src/ui-ux-pro-max/scripts" "$workdir/"
        cp -r "${uiUxProMaxSrc}/src/ui-ux-pro-max/data" "$workdir/"
        chmod -R u+w "$workdir"

        python3 "${./skills/adapt-ui-ux-pro-max.py}" "$workdir"

        mkdir -p "$out"
        cp -r "$workdir"/. "$out"/
      '';
in
{
  antfu = "${inputs.antfu-skills}/skills";
  ui-ux-pro-max = "${uiUxProMax}";
}
