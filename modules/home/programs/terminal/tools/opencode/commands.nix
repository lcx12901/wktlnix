{ lib, ... }:
let
  commands = lib.file.importSubdirs ./commands { };
  aiAgents = import ./agents.nix { inherit lib; };

  agentModels = lib.mapAttrs (_name: agent: agent.model) aiAgents.agents;

  commandAgents = {
    "explain-code" = "explore";
    "extract-interface" = "explore";
    "find-usages" = "explore";
    "summarize-module" = "explore";
    "refactor-suggest" = "refactorer";
    "generate-tests" = "test-runner";
    "initialization" = "explore";
    "changelog" = "explore";
  };

  normalizeCommand =
    name: command:
    let
      agent = command.agent or (commandAgents.${name} or "explore");
      model = command.model or (agentModels.${agent} or null);
    in
    {
      commandName = command.commandName or name;
      description = command.description or null;
      allowedTools = command.allowedTools or null;
      argumentHint = command.argumentHint or null;
      prompt = command.prompt or "";
      inherit agent model;
    };

  normalizedCommands = lib.mapAttrs normalizeCommand commands;

  renderOpenCodeFrontmatter = command: ''
    ---
    ${lib.optionalString (command.description != null) "description: ${command.description}"}
    ${lib.optionalString (command.agent != null) "agent: ${command.agent}"}
    ${lib.optionalString (command.model != null) "model: ${command.model}"}
    ---
  '';

  renderOpenCodeMarkdown = command: ''
    ${lib.trim (renderOpenCodeFrontmatter command)}

    ${lib.trim command.prompt}
  '';

  renderCommands = lib.mapAttrs (_name: renderOpenCodeMarkdown) normalizedCommands;
in
{
  inherit renderCommands;
}
