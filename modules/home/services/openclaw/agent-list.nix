{ config, lib, pkgs, ... }:
let
  cfg = config.wktlnix.services.openclaw;
in
{
  config = lib.mkIf cfg.enable {
    programs.openclaw.instances.default.config.agents.list = [
      {
        id = "nova";
        skills = [
          "self-improving-agent"
          "multi-search-engine"
          "sovereign-commit-craft"
          "capability-evolver-pro"
          "code-review"
        ];
      }
      {
        id = "evaluator";
        name = "质量评估专家";
        workspace = "${config.home.homeDirectory}/.openclaw/workspace/evaluator";
        bootstrapMaxChars = 5000;
        thinkingDefault = "high";
        skills = [
          "code-review"
          "self-improving-agent"
        ];
        model = {
          primary = "deepseek/deepseek-v4-pro";
        };
      }
      {
        id = "researcher";
        name = "研究专家";
        workspace = "${config.home.homeDirectory}/.openclaw/workspace/researcher";
        bootstrapMaxChars = 6000;
        thinkingDefault = "medium";
        skills = [
          "multi-search-engine"
          "self-improving-agent"
        ];
        model = {
          primary = "deepseek/deepseek-v4-flash";
        };
      }
      {
        id = "frontend-dev";
        name = "前端开发专家";
        workspace = "${config.home.homeDirectory}/.openclaw/workspace/frontend-dev";
        bootstrapMaxChars = 8000;
        bootstrapTotalMaxChars = 30000;
        thinkingDefault = "low";
        skills = [
          "vue"
          "vite"
          "vitest"
          "pinia"
          "unocss"
          "vue-best-practices"
          "vue-testing-best-practices"
          "leaferjs"
          "multi-search-engine"
          "self-improving-agent"
        ];
        model = {
          primary = "deepseek/deepseek-v4-flash";
        };
      }
      {
        id = "backend-dev";
        name = "后端开发专家";
        workspace = "${config.home.homeDirectory}/.openclaw/workspace/backend-dev";
        bootstrapMaxChars = 6000;
        thinkingDefault = "low";
        skills = [
          "multi-search-engine"
          "self-improving-agent"
          "code-review"
        ];
        model = {
          primary = "deepseek/deepseek-v4-flash";
        };
      }
      {
        id = "product-manager";
        name = "产品经理专家";
        workspace = "${config.home.homeDirectory}/.openclaw/workspace/product-manager";
        bootstrapMaxChars = 8000;
        thinkingDefault = "medium";
        skills = [
          "user-story-mapping"
          "roadmap-planning"
          "user-story-splitting"
          "discovery-process"
          "prd-development"
          "prioritization-advisor"
          "company-research"
          "multi-search-engine"
          "self-improving-agent"
        ];
        model = {
          primary = "deepseek/deepseek-v4-flash";
        };
      }
      {
        id = "ui-designer";
        name = "UI 设计专家";
        workspace = "${config.home.homeDirectory}/.openclaw/workspace/ui-designer";
        bootstrapMaxChars = 8000;
        bootstrapTotalMaxChars = 30000;
        thinkingDefault = "low";
        skills = [
          "ui-ux-pro-max"
          "design-system"
          "design"
          "banner-design"
          "brand"
          "slides"
          "ui-styling"
          "design-review"
          "react"
          "tailwindcss"
          "shadcn-ui"
          "responsive-design"
          "a11y"
          "multi-search-engine"
          "self-improving-agent"
        ];
        model = {
          primary = "deepseek/deepseek-v4-flash";
        };
      }
    ];
  };
}
