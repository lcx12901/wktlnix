{ config, lib, pkgs, osConfig, ... }:
let
  cfg = config.wktlnix.services.openclaw;
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
          # Prune offloaded files older than 7 days to prevent bloat
          find "$HOME/.openclaw/workspace/.cache" -type f -mtime +7 -delete 2>/dev/null || true
        '';
        setupTrajectoryDir = lib.hm.dag.entryAfter [ "writeBoundary" ] ''
          mkdir -p "$HOME/.openclaw/trajectory"
          # Archive cache-traces > 7 days to old/, keep at most 100 MB recent
          traj="$HOME/.openclaw/trajectory"
          if [ -f "$traj/cache-traces.jsonl" ] && [ "$(wc -c < "$traj/cache-traces.jsonl" 2>/dev/null || echo 0)" -gt 104857600 ]; then
            mkdir -p "$traj/old"
            ts=$(stat -c %Y "$traj/cache-traces.jsonl" 2>/dev/null || echo "$(date +%s)")
            mv "$traj/cache-traces.jsonl" "$traj/old/cache-traces-$ts.jsonl"
          fi
          # Prune old/ archives > 90 days
          find "$traj/old" -name "*.jsonl" -mtime +90 -delete 2>/dev/null || true
        '';
        copyAgentDocuments =
          lib.hm.dag.entryAfter [ "writeBoundary" ] # bash
            ''
              # Backup runtime PROGRESS.md if it has real user content
              # (size > 200 bytes means user has appended history beyond the template)
              runtime_progress="$HOME/.openclaw/workspace/PROGRESS.md"
              preserve_progress=0
              if [ -f "$runtime_progress" ] && [ "$(wc -c < "$runtime_progress")" -gt 200 ]; then
                cp "$runtime_progress" "$runtime_progress.runtime-bak-$$"
                preserve_progress=1
              fi

              # Copy nova documents directly to workspace root
              mkdir -p "$HOME/.openclaw/workspace"
              cp -r --no-preserve=mode,ownership,timestamps,links ${./documents}/nova/. "$HOME/.openclaw/workspace/"

              # Restore runtime PROGRESS.md if we backed it up
              if [ "$preserve_progress" = "1" ]; then
                mv "$runtime_progress.runtime-bak-$$" "$runtime_progress"
              fi

              # Copy other agent documents to their respective workspace subdirectories
              for agent_dir in ${./documents}/*/; do
                agent_name=$(basename "$agent_dir")
                if [ "$agent_name" != "nova" ]; then
                  mkdir -p "$HOME/.openclaw/workspace/$agent_name"
                  cp -r --no-preserve=mode,ownership,timestamps,links "$agent_dir/." "$HOME/.openclaw/workspace/$agent_name/"
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
