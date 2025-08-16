{ lib, config, ... }:
{
  programs.nvf.settings = {
    vim.statusline.lualine = {
      enable = true;

      disabledFiletypes = [
        "alpha"
        "startify"
        "neo-tree"
        "copilot-chat"
        "ministarter"
        "Avante"
        "AvanteInput"
        "trouble"
        "dapui_scopes"
        "dapui_breakpoints"
        "dapui_stacks"
        "dapui_watches"
        "dapui_console"
        "dashboard"
        "snacks_dashboard"
        "AvanteSelectedFiles"
      ];

      activeSection = {
        a = [
          ''
            {
              "mode",
              icons_enabled = true,
              separator = {
                left = '▎',
                right = ''
              },
            }
          ''
          ''
            {
              "",
              draw_empty = true,
              separator = { left = '', right = '' }
            }
          ''
        ];

        b = [
          ''
            {
              "branch",
              icon = '',
              separator = { left = '', right = '' }
            }
          ''
        ];

        c = [
          ''
            {
              "filetype",
              colored = true,
              icon_only = true,
              icon = { align = 'left' }
            }
          ''
          ''
            {
              "filename",
              symbols = {modified = ' ', readonly = ' '},
              separator = {right = ''}
            }
          ''
          ''
            {
              "diff",
              colored = true,
              symbols = { added = ' ', modified = ' ', removed = ' ' }, -- Changes the diff symbols
              separator = { left = '', right = '' }
            }
          ''
        ];

        x = [
          ''
            {
              "diagnostics",
              sources = {'nvim_lsp', 'nvim_diagnostic', 'nvim_diagnostic', 'vim_lsp', 'coc'},
              symbols = {error = '󰅙  ', warn = '  ', info = '  ', hint = '󰌵 '},
              colored = true,
              update_in_insert = false,
              always_visible = false,
              diagnostics_color = {
                color_error = { fg = 'red' },
                color_warn = { fg = 'yellow' },
                color_info = { fg = 'cyan' },
              },
            }
          ''
          (lib.optionalString config.programs.nvf.settings.vim.assistant.copilot.enable ''{ "copilot" }'')
        ];

        y = [
          ''
            {
              -- Lsp server name
              function()
                local buf_ft = vim.bo.filetype
                local excluded_buf_ft = { toggleterm = true, NvimTree = true, ["neo-tree"] = true, TelescopePrompt = true }

                if excluded_buf_ft[buf_ft] then
                  return ""
                  end

                local bufnr = vim.api.nvim_get_current_buf()
                local clients = vim.lsp.get_clients({ bufnr = bufnr })

                if vim.tbl_isempty(clients) then
                  return "No Active LSP"
                end

                local active_clients = {}
                for _, client in ipairs(clients) do
                  table.insert(active_clients, client.name)
                end

                return table.concat(active_clients, ", ")
              end,
              icon = ' ',
              separator = {left = ''},
            }
          ''
          ''
            {
              "",
              draw_empty = true,
              separator = { left = '', right = '' }
            }
          ''
        ];

        z = [
          ''
            {
              "",
              draw_empty = true,
              separator = { left = '', right = '' }
            }
          ''
          ''
            {
              "progress",
              separator = {left = ''}
            }
          ''
          ''
            {"location"}
          ''
        ];
      };
    };
  };
}
