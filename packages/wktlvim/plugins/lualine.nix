{ config, lib, ... }:
let
  inherit (config) icons;
  cond.__raw = ''
    function()
      local buf_size_limit = 1024 * 1024 -- 1MB size limit
      if vim.api.nvim_buf_get_offset(0, vim.api.nvim_buf_line_count(0)) > buf_size_limit then
        return false
      end

      return true
    end
  '';
in
{
  plugins.lualine = {
    enable = true;

    lazyLoad.settings.event = "BufEnter";

    settings = {
      options = {
        disabled_filetypes = {
          __unkeyed-1 = "alpha";
          __unkeyed-2 = "neo-tree";
          winbar = [
            "aerial"
            "dap-repl"
            "neotest-summary"
          ];
        };

        globalstatus = true;

        component_separators = {
          left = "";
          right = "";
        };
      };

      sections = {
        lualine_a = [ "mode" ];
        lualine_b = [
          {
            __unkeyed = "branch";
            icon = icons.GitBranch;
          }
        ];
        lualine_c = [
          "filetype"
          {
            __unkeyed = "diff";
            symbols = {
              added = "${icons.GitAdd} ";
              modified = "${icons.GitChange} ";
              removed = "${icons.GitDelete} ";
            };
          }
        ];

        lualine_x = [
          {
            __unkeyed = "diagnostics";
            symbols = {
              error = "${icons.DiagnosticError} ";
              warn = "${icons.DiagnosticWarn} ";
              info = "${icons.DiagnosticInfo} ";
              hint = "${icons.DiagnosticHint} ";
            };
          }

          # Show active language server
          {
            __unkeyed.__raw = ''
              function()
                local buf_client_names = {}
                for _, client in ipairs(vim.lsp.get_clients()) do
                  local filetypes = client.config.filetypes
                  if filetypes and vim.fn.index(filetypes, vim.api.nvim_buf_get_option(0, 'filetype')) ~= -1 then
                    table.insert(buf_client_names, client.name)
                  end
                end
                local bufnr = vim.api.nvim_buf_get_number(0)
                vim.list_extend(
                    buf_client_names,
                    vim.tbl_map(function(c) return c.name end, require("conform").list_formatters_to_run(bufnr))
                )
                return table.concat(buf_client_names, ", ")
              end
            '';
            icon = "${icons.ActiveLSP} ";
            color = {
              fg = "#95de64";
              gui = "bold";
            };
          }
          "encoding"
          "fileformat"
        ];

        lualine_y = [ "progress" ];

        lualine_z = [
          {
            __unkeyed = "location";
            inherit cond;
          }
        ];
      };

      tabline = lib.mkIf (!config.plugins.bufferline.enable) {
        lualine_a = [
          # NOTE: not high priority since i use bufferline now, but should fix left separator color
          {
            __unkeyed = "buffers";
            symbols = {
              alternate_file = "";
            };
          }
        ];
        lualine_z = [ "tabs" ];
      };

      winbar = {
        lualine_c = [
          {
            __unkeyed = "navic";
            inherit cond;
          }
        ];

        # TODO: Need to dynamically hide/show component so navic takes precedence on smaller width
        lualine_x = [
          {
            __unkeyed = "filename";
            newfile_status = true;
            path = 3;
            # Shorten path names to fit navic component
            shorting_target = 150;
          }
        ];
      };
    };
  };
}
