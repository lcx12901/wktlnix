{ config, lib, pkgs, osConfig, ... }:
let
  cfg = config.wktlnix.services.openclaw;
  allSkills = import ./skills.nix { inherit pkgs; };
  skillManifest = pkgs.writeText "openclaw-skill-manifest.tsv" (
    lib.concatStringsSep "\n" (map (s: "${s.source}\t${s.name}") allSkills) + "\n"
  );
in
{
  config = lib.mkIf cfg.enable {
    systemd.user.services.openclaw-gateway = {
      Service = {
        StandardOutput = lib.mkForce "journal";
        StandardError = lib.mkForce "journal";
      };
      Install = {
        WantedBy = [ "default.target" ];
      };
    };

    home = {
      activation = {
        copyOpenClawMemoryPlugin = lib.hm.dag.entryAfter [ "writeBoundary" ] ''
          mkdir -p "$HOME/.openclaw/plugins"
          pluginDir="$HOME/.openclaw/plugins/memory-lancedb-pro"
          rm -rf "$pluginDir"
          cp -r --no-preserve=mode,ownership,timestamps,links ${pkgs.wktlnix.memory-lancedb-pro}/. "$pluginDir/"
        '';
        copyOpenClawAvatar = lib.hm.dag.entryAfter [ "writeBoundary" ] ''
          mkdir -p "$HOME/.openclaw/workspace/avatar"
          cp -r --no-preserve=mode,ownership,timestamps,links ${./avatar}/. "$HOME/.openclaw/workspace/avatar/"
        '';
        cleanStaleLockFiles = lib.hm.dag.entryAfter [ "writeBoundary" ] ''
          find "$HOME/.openclaw/memory/lancedb-pro" -name ".memory-write.lock" -mmin +60 -delete 2>/dev/null || true
        '';
        setupCacheDir = lib.hm.dag.entryAfter [ "writeBoundary" ] ''
          mkdir -p "$HOME/.openclaw/workspace/.cache"
          find "$HOME/.openclaw/workspace/.cache" -type f -mtime +7 -delete 2>/dev/null || true
        '';
        setupTrajectoryDir = lib.hm.dag.entryAfter [ "writeBoundary" ] ''
          mkdir -p "$HOME/.openclaw/trajectory"
          traj="$HOME/.openclaw/trajectory"
          if [ -f "$traj/cache-traces.jsonl" ] && [ "$(wc -c < "$traj/cache-traces.jsonl" 2>/dev/null || echo 0)" -gt 104857600 ]; then
            mkdir -p "$traj/old"
            ts=$(stat -c %Y "$traj/cache-traces.jsonl" 2>/dev/null || echo "$(date +%s)")
            mv "$traj/cache-traces.jsonl" "$traj/old/cache-traces-$ts.jsonl"
          fi
          find "$traj/old" -name "*.jsonl" -mtime +90 -delete 2>/dev/null || true
        '';
        copySkills =
          lib.hm.dag.entryAfter [ "writeBoundary" ] # bash
            ''
              manifest=${skillManifest}
              target="$HOME/.openclaw/workspace/skills"
              mkdir -p "$target"

              IFS=$'\t'
              while read -r src name _; do
                [ -z "$src" ] && continue
                [ -z "$name" ] && continue
                abs_target="$target/$name"

                if [ -d "$abs_target" ] && [ -f "$abs_target/.nix-hash" ]; then
                  cached_hash=$(cat "$abs_target/.nix-hash" 2>/dev/null || echo "")
                  if [ "$cached_hash" = "$(readlink -f "$src")" ]; then
                    continue
                  fi
                fi

                rm -rf "$abs_target"
                mkdir -p "$abs_target"
                # --no-preserve=links breaks hardlinks -> nlink=1 -> passes gateway security check
                cp -rL --no-preserve=mode,ownership,timestamps,links "$src/." "$abs_target/"
                readlink -f "$src" > "$abs_target/.nix-hash"
              done < ${skillManifest}

              unset IFS
            '';
        copyAgentDocuments =
          lib.hm.dag.entryAfter [ "copySkills" ] # bash
            ''
              runtime_progress="$HOME/.openclaw/workspace/PROGRESS.md"
              preserve_progress=0
              if [ -f "$runtime_progress" ] && [ "$(wc -c < "$runtime_progress")" -gt 200 ]; then
                cp "$runtime_progress" "$runtime_progress.runtime-bak-$$"
                preserve_progress=1
              fi

              mkdir -p "$HOME/.openclaw/workspace"
              cp -r --no-preserve=mode,ownership,timestamps,links ${./documents}/nova/. "$HOME/.openclaw/workspace/"

              if [ "$preserve_progress" = "1" ]; then
                mv "$runtime_progress.runtime-bak-$$" "$runtime_progress"
              fi

              for agent_dir in ${./documents}/*/; do
                agent_name=$(basename "$agent_dir")
                if [ "$agent_name" != "nova" ]; then
                  mkdir -p "$HOME/.openclaw/workspace/$agent_name"
                  cp -r --no-preserve=mode,ownership,timestamps,links "$agent_dir/." "$HOME/.openclaw/workspace/$agent_name/"
                  # Link shared skills so sub-agents can discover them from their workspace
                  ln -sfn ../skills "$HOME/.openclaw/workspace/$agent_name/skills"
                fi
              done
            '';
      };
      persistence = {
        "/persist" = {
          directories = [
            {
              directory = ".openclaw";
              mode = "0700";
            }
          ];
        };
      };
    };

    sops.secrets."${osConfig.networking.hostName}_openclaw_gateway_env" = {
      path = "${config.home.homeDirectory}/.openclaw/.env";
    };
  };
}
