{ lib, ... }:
let
  inherit (lib) mapAttrs;

  agentsBasePath = ./agents;

  agents = {
    refactorer = {
      name = "refactorer";
      description = "Code refactoring specialist for improving code structure, readability, and maintainability without changing behavior. Use for focused refactoring tasks in isolated context.";
      tools = [
        "Read"
        "Edit"
        "Write"
        "Grep"
        "Glob"
        "Bash"
      ];
      model = "github-copilot/gpt-5-mini";
      permission = {
        edit = "ask";
        bash = "ask";
      };
      content = builtins.readFile (agentsBasePath + "/refactorer.md");
    };
  };

  renderOpenCodeTools =
    agent:
    let
      allowed = map lib.toLower agent.tools;
      isAllowed = t: lib.elem t allowed;
      coreTools = [
        "bash"
        "edit"
        "write"
      ];
      coreToolLines = map (t: "  ${t}: ${if isAllowed t then "true" else "false"}") coreTools;
    in
    lib.concatStringsSep "\n" coreToolLines;

  renderOpenCodeFrontmatter = agent: ''
    ---
    description: ${agent.description}
    mode: all
    model: ${agent.model.opencode or agent.model}

    tools:
    ${renderOpenCodeTools agent}
    ---
  '';

  renderOpenCodeAgent = agent: ''
    ${lib.trim (renderOpenCodeFrontmatter agent)}

    ${lib.trim agent.content}
  '';

  renderAgents = mapAttrs (_name: renderOpenCodeAgent) agents;
in
{
  inherit agents renderAgents;
}
