{
  inputs,
  lib,
  pkgs,
  ...
}:
let
  inherit (inputs.nvf.lib.nvim.binds) mkKeymap;
in
{
  programs.nvf.settings = {
    vim = {
      assistant.copilot = {
        enable = true;

        setupOpts = {
          panel.enabled = false;
          suggestion.enabled = false;
          lsp_binary = lib.getExe pkgs.copilot-language-server;
        };
      };

      lazy.plugins."CopilotChat.nvim" = {
        package = pkgs.vimPlugins.CopilotChat-nvim;
        setupModule = "CopilotChat";
        cmd = [
          "CopilotChat"
          "CopilotChatAgents"
          "CopilotChatLoad"
          "CopilotChatModels"
          "CopilotChatOpen"
          "CopilotChatPrompts"
          "CopilotChatToggle"
        ];
      };

      binds.whichKey.register = {
        "<leader>a" = "Copilot";
      };

      keymaps = [
        (mkKeymap "n" "<leader>aCc" "<cmd>CopilotChat<CR>" { desc = "Open Chat"; })
        (mkKeymap "n" "<leader>aCq" ''
          function()
            local input = vim.fn.input("Quick Chat: ")
            if input ~= "" then
              require("CopilotChat").ask(input, { selection = require("CopilotChat.select").buffer })
            end
          end
        '' { desc = "Quick Chat"; })
        (mkKeymap "n" "<leader>aCh" ''
          function()
            local actions = require("CopilotChat.actions")
            require("CopilotChat.integrations.telescope").pick(actions.help_actions())
          end
        '' { desc = "Help Actions"; })
        (mkKeymap "n" "<leader>aCp" ''
          function()
            local actions = require("CopilotChat.actions")
            require("CopilotChat.integrations.telescope").pick(actions.prompt_actions())
          end
        '' { desc = "Prompt Actions"; })
        (mkKeymap "n" "<leader>aCa" "<cmd>CopilotChatAgents<CR>" { desc = "List Available Agents"; })
        (mkKeymap "n" "<leader>aCl" "<cmd>CopilotChatLoad<CR>" { desc = "Load Chat History"; })
        (mkKeymap "n" "<leader>aCm" "<cmd>CopilotChatModels<CR>" { desc = "List Available Models"; })
        (mkKeymap "n" "<leader>aCo" "<cmd>CopilotChatOpen<CR>" { desc = "Open Chat Window"; })
        (mkKeymap "n" "<leader>aCt" "<cmd>CopilotChatToggle<CR>" { desc = "Toggle Chat Window"; })
      ];
    };
  };
}
