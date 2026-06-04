{ config, lib, ... }:
let
  cfg = config.wktlnix.services.openclaw;
in
{
  config = lib.mkIf cfg.enable {
    programs.openclaw.instances.default.config.agents.list = [
      {
        id = "nova";
        skills = [
          "self-improvement"
          "multi-search-engine"
          "sovereign-commit-craft"
          "Capability Evolver"
          "audit-code"
          "antfu"
          "vue"
          "vite"
          "vitest"
          "pinia"
          "unocss"
          "leafer-ai"
          "design-review"
          "React"
          "Tailwind CSS"
          "shadcn-ui"
          "responsive-design"
          "a11y"
        ];
      }
      {
        id = "evaluator";
        name = "质量评估专家";
        workspace = "${config.home.homeDirectory}/.openclaw/workspace/evaluator";
        bootstrapMaxChars = 5000;
        thinkingDefault = "high";
        skills = [
          "audit-code"
          "self-improvement"
          "multi-search-engine"
          "sovereign-commit-craft"
          "Capability Evolver"
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
          "self-improvement"
          "company-research"
          "discovery-process"
          "discovery-interview-prep"
          "pestel-analysis"
          "tam-sam-som-calculator"
          "opportunity-solution-tree"
          "jobs-to-be-done"
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
          "antfu"
          "vue"
          "vite"
          "vitest"
          "vitepress"
          "pinia"
          "unocss"
          "pnpm"
          "nuxt"
          "slidev"
          "tsdown"
          "turborepo"
          "leafer-ai"
          "vue-router-best-practices"
          "vue-best-practices"
          "vue-testing-best-practices"
          "vueuse-functions"
          "web-design-guidelines"
          "multi-search-engine"
          "self-improvement"
          "audit-code"
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
          "self-improvement"
          "audit-code"
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
          "acquisition-channel-advisor"
          "ai-shaped-readiness-advisor"
          "altitude-horizon-framework"
          "business-health-diagnostic"
          "company-research"
          "context-engineering-advisor"
          "customer-journey-map"
          "customer-journey-mapping-workshop"
          "director-readiness-advisor"
          "discovery-interview-prep"
          "discovery-process"
          "eol-message"
          "epic-breakdown-advisor"
          "epic-hypothesis"
          "executive-onboarding-playbook"
          "feature-investment-advisor"
          "finance-based-pricing-advisor"
          "finance-metrics-quickref"
          "jobs-to-be-done"
          "lean-ux-canvas"
          "multi-search-engine"
          "opportunity-solution-tree"
          "organic-growth-advisor"
          "pestel-analysis"
          "pm-skill-creator"
          "pol-probe"
          "pol-probe-advisor"
          "positioning-statement"
          "positioning-workshop"
          "prd-development"
          "press-release"
          "prioritization-advisor"
          "problem-framing-canvas"
          "problem-statement"
          "product-sense-interview-answer"
          "product-strategy-session"
          "proto-persona"
          "recommendation-canvas"
          "roadmap-planning"
          "saas-economics-efficiency-metrics"
          "saas-revenue-growth-metrics"
          "self-improvement"
          "skill-authoring-workflow"
          "storyboard"
          "tam-sam-som-calculator"
          "user-story"
          "user-story-mapping"
          "user-story-mapping-workshop"
          "user-story-splitting"
          "vp-cpo-readiness-advisor"
          "workshop-facilitation"
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
          "ckm:design-system"
          "ckm:design"
          "ckm:banner-design"
          "ckm:brand"
          "ckm:slides"
          "ckm:ui-styling"
          "design-review"
          "React"
          "Tailwind CSS"
          "shadcn-ui"
          "responsive-design"
          "a11y"
          "web-design-guidelines"
          "multi-search-engine"
          "self-improvement"
        ];
        model = {
          primary = "deepseek/deepseek-v4-flash";
        };
      }
    ];
  };
}
