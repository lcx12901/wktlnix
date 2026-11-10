{ lib, pkgs }:

let
  inherit (lib) getExe;

  antfuSkills = pkgs.fetchFromGitHub {
    owner = "antfu";
    repo = "skills";
    rev = "feb0f3aba6566426f12230e7fc7a10d97c1293bb";
    sha256 = "sha256-o/OH4HGRhBH9p08UfUX8K31JuISSIDO9O4zZDrwzJL4=";
  };
in
(pkgs.formats.yaml { }).generate "omp-config.yml" {
  modelRoles = {
    default = "opencode-go/mimo-v2.6-flash:xhigh";
    plan = "opencode-go/mimo-v2.6-flash:xhigh";
    slow = "opencode-go/mimo-v2.6-flash:xhigh";
    designer = "opencode-go/mimo-v2.6-flash:xhigh";
    smol = "opencode-go/mimo-v2.6-flash:xhigh";
    vision = "opencode-go/qwen3.5-plus:high";
  };
  setupVersion = 2;
  startup.quiet = true;
  theme = {
    dark = "dark-catppuccin";
  };
  symbolPreset = "nerd";
  colorBlindMode = true;
  statusLine = {
    preset = "nerd";
    separator = "ascii";
  };
  compaction = {
    enabled = true;
    reserveTokens = 32768;
    keepRecentTokens = 20000;
    autoContinue = true;
  };
  python.interpreter = "${getExe pkgs.python3}";

  skills.customDirectories = [
    "${antfuSkills}/skills"
  ];
}
