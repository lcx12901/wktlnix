{
  config,
  lib,
  pkgs,
  ...
}:
{
  extraPackages = with pkgs; [ ripgrep ];

  plugins.telescope = {
    enable = true;

    extensions = {
      file-browser = {
        enable = true;
        settings = {
          hidden = true;
        };
      };

      frecency = {
        enable = true;
        settings = {
          auto_validate = false;
        };
      };

      live-grep-args.enable = true;

      manix.enable = true;

      ui-select = {
        enable = true;
        settings = {
          __unkeyed.__raw = ''require("telescope.themes").get_dropdown{}'';
        };
      };

      undo = {
        enable = true;
        settings = {
          side_by_side = true;
          layout_strategy = "vertical";
          layout_config = {
            preview_height = 0.8;
          };
        };
      };
    };

    highlightTheme = "Catppuccin Macchiato";

    keymaps = {
      "<Leader>f'" = {
        action = "marks";
        options.desc = "View marks";
      };
      "<Leader>f/" = {
        action = "current_buffer_fuzzy_find";
        options.desc = "Fuzzy find in current buffer";
      };
      "<Leader>f<CR>" = {
        action = "resume";
        options.desc = "Resume action";
      };
      "<Leader>fa" = {
        action = "autocommands";
        options.desc = "View autocommands";
      };
      "<Leader>fC" = {
        action = "commands";
        options.desc = "View commands";
      };
      "<Leader>fb" = {
        action = "buffers";
        options.desc = "View buffers";
      };
      "<Leader>fc" = {
        action = "grep_string";
        options.desc = "Grep string";
      };
      "<Leader>fd" = {
        action = "diagnostics";
        options.desc = "View diagnostics";
      };
      "<Leader>ff" = {
        action = "find_files";
        options.desc = "Find files";
      };
      "<Leader>fh" = {
        action = "help_tags";
        options.desc = "View help tags";
      };
      "<Leader>fk" = {
        action = "keymaps";
        options.desc = "View keymaps";
      };
      "<Leader>fm" = {
        action = "man_pages";
        options.desc = "View man pages";
      };
      "<Leader>fo" = {
        action = "oldfiles";
        options.desc = "View old files";
      };
      "<Leader>fr" = {
        action = "registers";
        options.desc = "View registers";
      };
      "<Leader>fs" = {
        action = "lsp_document_symbols";
        options.desc = "Search symbols";
      };
      "<Leader>fq" = {
        action = "quickfix";
        options.desc = "Search quickfix";
      };
      "<Leader>fw" = lib.mkIf (!config.plugins.telescope.extensions.live-grep-args.enable) {
        action = "live_grep";
        options.desc = "Live grep";
      };
      "<Leader>gB" = {
        action = "git_branches";
        options.desc = "View git branches";
      };
      "<Leader>gC" = {
        action = "git_commits";
        options.desc = "View git commits";
      };
      "<Leader>gs" = {
        action = "git_status";
        options.desc = "View git status";
      };
      "<Leader>gS" = {
        action = "git_stash";
        options.desc = "View git stashes";
      };
    };

    settings = {
      defaults = {
        file_ignore_patterns = [
          "^.git/"
          "^.mypy_cache/"
          "^__pycache__/"
          "^output/"
          "^data/"
          "%.ipynb"
        ];

        set_env.COLORTERM = "truecolor";
      };

      pickers = {
        colorscheme = {
          enable_preview = true;
        };
      };
    };
  };
}
