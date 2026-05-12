{ pkgs }:

let
  selfImprovingAgent = pkgs.fetchFromGitHub {
    owner = "peterskoett";
    repo = "self-improving-agent";
    rev = "109f3ff4c0ad725fff94b8ab4d882aab9728b828";
    hash = "sha256-EfRqAlXbYMhOmsC7HPebmru9RQBOeog0Ve2kvXY5BrA=";
  };
in
[
  {
    name = "self-improving-agent";
    source = "${selfImprovingAgent}";
    mode = "copy";
  }
]
