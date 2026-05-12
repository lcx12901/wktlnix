{ pkgs }:

let
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
in
[
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
]
