{ config, lib, pkgs, ... }:
let
  cfg = config.wktlnix.services.openclaw;
in
{
  config = lib.mkIf cfg.enable {
    programs.openclaw.instances.default.config.plugins = {
      enabled = true;
      load.paths = [ "${config.home.homeDirectory}/.openclaw/plugins/memory-lancedb-pro" ];
      slots.memory = "memory-lancedb-pro";
      entries."memory-lancedb-pro" = {
        enabled = true;
        hooks.allowConversationAccess = true;
        config = {
          embedding = {
            provider = "openai-compatible";
            apiKey = "ollama";
            model = "nomic-embed-text";
            baseURL = "http://127.0.0.1:11434/v1";
            dimensions = 768;
          };
          autoCapture = true;
          autoRecall = true;
          smartExtraction = true;
          enableManagementTools = true;
          extractMinMessages = 6;
          autoRecallMinLength = 50;
          autoRecallMinRepeated = 20;
          recallMode = "adaptive";
          workspaceBoundary.userMdExclusive = {
            enabled = true;
            filterRecall = true;
          };
          sessionCompression = {
            enabled = true;
            minScoreToKeep = 0.4;
          };
          memoryCompaction = {
            enabled = true;
            minAgeDays = 7;
            similarityThreshold = 0.92;
            cooldownHours = 24;
          };
          selfImprovement = {
            skipSubagentBootstrap = true;
            ensureLearningFiles = true;
          };
          extractMaxChars = 8000;
          llm = {
            auth = "api-key";
            apiKey = "\${DEEPSEEK_API_KEY}";
            model = "deepseek-v4-flash";
            baseURL = "https://api.deepseek.com/v1";
            timeoutMs = 30000;
          };
          retrieval = {
            mode = "hybrid";
            rerank = "cross-encoder";
            rerankProvider = "siliconflow";
            rerankApiKey = "\${SILICONFLOW_API_KEY}";
            rerankModel = "BAAI/bge-reranker-v2-m3";
            rerankEndpoint = "https://api.siliconflow.cn/v1/rerank";
            rerankTimeoutMs = 30000;
            hardMinScore = 0.5;
          };
          sessionMemory = {
            enabled = false;
          };
        };
      };
    };
  };
}
