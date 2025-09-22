{ lib, ... }:
let
  inherit (lib.nvim.binds) mkKeymap;
in
{
  programs.nvf.settings = {
    vim = {
      lazy.plugins = {
        noice-nvim = {
          package = "noice-nvim";
          event = "DeferredUIEnter";
        };
      };

      notify.nvim-notify.enable = true;

      ui.noice = {
        enable = true;

        setupOpts = {
          format = {
            cmdline = {
              pattern = "^:";
              icon = "";
              lang = "vim";
              opts = {
                border = {
                  text = {
                    top = "Cmd";
                  };
                };
              };
            };

            filter = {
              pattern = "^:%s*!";
              icon = "";
              lang = "bash";
              opts = {
                border = {
                  text = {
                    top = "Bash";
                  };
                };
              };
            };
          };

          messages = {
            view = "mini";
            view_error = "mini";
            view_warn = "mini";
          };

          lsp = {
            override = {
              "vim.lsp.util.convert_input_to_markdown_lines" = true;
              "vim.lsp.util.stylize_markdown" = true;
              "cmp.entry.get_documentation" = true;
            };

            progress.enabled = true;
            signature.enabled = true;
          };

          popupmenu.backend = "nui";

          presets = {
            bottom_search = false;
            command_palette = true;
            long_message_to_split = true;
            inc_rename = true;
            lsp_doc_border = true;
          };

          routes = [
            {
              filter = {
                event = "msg_show";
                kind = "search_count";
              };
              opts = {
                skip = true;
              };
            }
            {
              filter = {
                event = "notify";
                find = "No information available";
              };
              opts = {
                skip = true;
              };
            }
          ];

          views = {
            cmdline_popup = {
              border = {
                style = "single";
              };
            };

            confirm = {
              border = {
                style = "single";
                text = {
                  top = "";
                };
              };
            };
          };
        };
      };

      keymaps = [
        (mkKeymap "n" "<leader>fn" "<cmd>Noice snacks<CR>" { desc = "Find notifications"; })
      ];
    };
  };
}
