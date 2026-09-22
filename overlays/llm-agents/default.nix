{ inputs }:
final: _prev:
let
  inherit (final.stdenv.hostPlatform) system;

  llmAgents = inputs.llm-agents.packages.${system};
in
{
  llm-agents.opencode = llmAgents.opencode;
}
