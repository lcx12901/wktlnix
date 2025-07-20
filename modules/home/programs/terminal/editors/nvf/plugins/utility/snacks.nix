{
  inputs,
  config,
  lib,
  ...
}:
let
  inherit (lib.generators) mkLuaInline;
  inherit (inputs.nvf.lib.nvim.binds) mkKeymap;
in
{
  programs.nvf.settings = {
    vim.utility.snacks-nvim = {
      enable = true;

      setupOpts = {
        image.enabled = true;
        indent.enabled = true;
        scroll.enabled = true;
        lazygit.enabled = true;
        bufdelete.enabled = true;
        zen.enabled = true;

        statuscolumn = {
          enabled = true;

          folds = {
            open = true;
            git_hl = config.programs.nvf.settings.vim.git.gitsigns.enable;
          };
        };

        picker = {
          actions = {
            calculate_file_truncate_width = mkLuaInline ''
              function(self)
                local width = self.list.win:size().width
                self.opts.formatters.file.truncate = width - 6
              end
            '';
          };

          win = {
            list = {
              on_buf = mkLuaInline ''
                function(self)
                  self:execute 'calculate_file_truncate_width'
                end
              '';
            };
            preview = {
              on_buf = mkLuaInline ''
                function(self)
                   self:execute 'calculate_file_truncate_width'
                 end
              '';
              on_close = mkLuaInline ''
                function(self)
                  self:execute 'calculate_file_truncate_width'
                end
              '';
            };
          };
          layouts = {
            select = {
              layout = {
                relative = "cursor";
                width = 70;
                min_width = 0;
                row = 1;
              };
            };
          };
        };
      };
    };

    vim.keymaps = [
      # bufdelete
      (mkKeymap "n" "<C-w>" "<cmd>lua Snacks.bufdelete.delete()<cr>" { desc = "Close buffer"; })
      (mkKeymap "n" "<leader>bc" "<cmd>lua Snacks.bufdelete.other()<cr>" {
        desc = "Close all buffers but current";
      })
      (mkKeymap "n" "<leader>bC" "<cmd>lua Snacks.bufdelete.all()<cr>" { desc = "Close all buffers"; })

      # lazygit
      (mkKeymap "n" "<leader>tl" "<cmd>lua Snacks.lazygit()<CR>" { desc = "Open lazygit"; })

      # picker
      (mkKeymap "n" "<leader><space>" "<cmd>lua Snacks.picker.smart()<cr>" { desc = "Smart Find Files"; })
      (mkKeymap "n" "<leader>:" "<cmd>lua Snacks.picker.command_history()<cr>" {
        desc = "Command History";
      })
      (mkKeymap "n" "<leader>fa" "<cmd>lua Snacks.picker.autocmds()<cr>" { desc = "Find autocmds"; })
      (mkKeymap "n" "<leader>fb" "<cmd>lua Snacks.picker.buffers()<cr>" { desc = "Find buffers"; })
      (mkKeymap "n" "<leader>fc" "<cmd>lua Snacks.picker.commands()<cr>" { desc = "Find commands"; })
      (mkKeymap "n" "<leader>fe" "<cmd>lua Snacks.explorer()<cr>" { desc = "File Explorer"; })
      (mkKeymap "n" "<leader>ff" "<cmd>lua Snacks.picker.files()<cr>" { desc = "Find files"; })
      (mkKeymap "n" "<leader>fF" "<cmd>lua Snacks.picker.files({hidden = true, ignored = true})<cr>" {
        desc = "Find files (All files)";
      })
      (mkKeymap "n" "<leader>fh" "<cmd>lua Snacks.picker.help()<cr>" { desc = "Find help tags"; })
      (mkKeymap "n" "<leader>fk" "<cmd>lua Snacks.picker.keymaps()<cr>" { desc = "Find keymaps"; })
      (mkKeymap "n" "<leader>fm" "<cmd>lua Snacks.picker.man()<cr>" { desc = "Find man pages"; })
      (mkKeymap "n" "<leader>fo" "<cmd>lua Snacks.picker.recent()<cr>" { desc = "Find old files"; })
      (mkKeymap "n" "<leader>fO" "<cmd>lua Snacks.picker.smart()<cr>" { desc = "Find Smart (Frecency)"; })
      (mkKeymap "n" "<leader>fp" "<cmd>lua Snacks.picker.projects()<cr>" { desc = "Find projects"; })
      (mkKeymap "n" "<leader>fq" "<cmd>lua Snacks.picker.qflist()<cr>" { desc = "Find quickfix"; })
      (mkKeymap "n" "<leader>fr" "<cmd>lua Snacks.picker.registers()<cr>" { desc = "Find registers"; })
      (mkKeymap "n" "<leader>fS" ''<CMD>lua Snacks.picker.spelling({layout = { preset = "select" }})<CR>''
        { desc = "Find spelling suggestions"; }
      )
      (mkKeymap "n" "<leader>fu" "<cmd>lua Snacks.picker.undo()<cr>" { desc = "Undo History"; })
      (mkKeymap "n" "<leader>fw" "<cmd>lua Snacks.picker.grep()<cr>" { desc = "Live grep"; })
      (mkKeymap "n" "<leader>fW" "<cmd>lua Snacks.picker.grep({hidden = true, ignored = true})<cr>" {
        desc = "Live grep (All files)";
      })
      (mkKeymap "n" "<leader>f," ''<cmd>lua Snacks.picker.icons({layout = { preset = "select" }})<cr>'' {
        desc = "Find icons";
      })
      (mkKeymap "n" "<leader>f'" "<cmd>lua Snacks.picker.marks()<cr>" { desc = "Find marks"; })
      (mkKeymap "n" "<leader>f/" "<cmd>lua Snacks.picker.lines()<cr>" {
        desc = "Fuzzy find in current buffer";
      })
      (mkKeymap "n" "<leader>f?" "<cmd>lua Snacks.picker.grep_buffers()<cr>" {
        desc = "Fuzzy find in open buffers";
      })
      (mkKeymap "n" "<leader>f<CR>" "<cmd>lua Snacks.picker.resume()<cr>" { desc = "Resume find"; })
      (mkKeymap [ "n" "x" ] "<leader>sw" "<cmd>lua Snacks.picker.grep_word()<cr>" {
        desc = "Search Word (visual or cursor)";
      })
      # lsp
      (mkKeymap "n" "<leader>fd" "<cmd>lua Snacks.picker.diagnostics_buffer()<cr>" {
        desc = "Find buffer diagnostics";
      })

      # zen mode
      (mkKeymap "n" "<leader>uz" "<cmd>lua Snacks.zen()<cr>" { desc = "Toggle Zen Mode"; })
    ];
  };
}
