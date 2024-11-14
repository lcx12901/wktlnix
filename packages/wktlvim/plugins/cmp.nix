_: let
  get_bufnrs.__raw = ''
    function()
      local buf_size_limit = 1024 * 1024 -- 1MB size limit
      local bufs = vim.api.nvim_list_bufs()
      local valid_bufs = {}
      for _, buf in ipairs(bufs) do
        if vim.api.nvim_buf_is_loaded(buf) and vim.api.nvim_buf_get_offset(buf, vim.api.nvim_buf_line_count(buf)) < buf_size_limit then
          table.insert(valid_bufs, buf)
        end
      end
      return valid_bufs
    end
  '';
in {
  opts.completeopt = [
    "menu"
    "menuone"
    "noselect"
  ];

  plugins = {
    cmp = {
      enable = true;
      autoEnableSources = true;

      settings = {
        mapping = {
          "<Up>" =
            # Lua
            "cmp.mapping.select_prev_item { behavior = cmp.SelectBehavior.Select }";
          "<Down>" =
            # Lua
            "cmp.mapping.select_next_item { behavior = cmp.SelectBehavior.Select }";
          "<C-P>".__raw =
            # Lua
            ''
              cmp.mapping(function()
                if cmp.visible() then
                  cmp.select_prev_item()
                else
                  cmp.complete()
                end
              end)
            '';
          "<C-N>".__raw =
            # Lua
            ''
              cmp.mapping(function()
                if cmp.visible() then
                  cmp.select_next_item()
                else
                  cmp.complete()
                end
              end)
            '';
          "<C-K>" =
            # Lua
            "cmp.mapping(cmp.mapping.select_prev_item(), { 'i', 'c' })";
          "<C-J>" =
            # Lua
            "cmp.mapping(cmp.mapping.select_next_item(), { 'i', 'c' })";
          "<C-U>" =
            # Lua
            "cmp.mapping(cmp.mapping.scroll_docs(-4), { 'i', 'c' })";
          "<C-D>" =
            # Lua
            "cmp.mapping(cmp.mapping.scroll_docs(4), { 'i', 'c' })";
          "<C-Space>" =
            # Lua
            "cmp.mapping(cmp.mapping.complete(), { 'i', 'c' })";
          "<C-Y>" =
            # Lua
            "cmp.config.disable";
          "<C-E>" =
            # Lua
            "cmp.mapping(cmp.mapping.abort(), { 'i', 'c' })";
          "<CR>" =
            # Lua
            "cmp.mapping(cmp.mapping.confirm { select = false }, { 'i', 'c' })";
          "<Tab>".__raw =
            # Lua
            ''
              cmp.mapping(function(fallback)
                if cmp.visible() then
                  cmp.select_next_item()
                elseif vim.api.nvim_get_mode().mode ~= "c" and luasnip.expand_or_locally_jumpable() then
                  luasnip.expand_or_jump()
                elseif has_words_before() then
                  cmp.complete()
                else
                  fallback()
                end
              end, { "i", "s" })
            '';
          "<S-Tab>".__raw =
            # Lua
            ''
              cmp.mapping(function(fallback)
                if cmp.visible() then
                  cmp.select_prev_item()
                elseif vim.api.nvim_get_mode().mode ~= "c" and luasnip.jumpable(-1) then
                  luasnip.jump(-1)
                else
                  fallback()
                end
              end, { "i", "s" })
            '';
        };

        preselect =
          # Lua
          "cmp.PreselectMode.None";

        snippet.expand =
          # Lua
          "function(args) require('luasnip').lsp_expand(args.body) end";

        sources = [
          {
            name = "nvim_lsp";
            priority = 1000;
            option = {
              inherit get_bufnrs;
            };
          }
          {
            name = "nvim_lsp_signature_help";
            priority = 1000;
            option = {
              inherit get_bufnrs;
            };
          }
          {
            name = "nvim_lsp_document_symbol";
            priority = 1000;
            option = {
              inherit get_bufnrs;
            };
          }
          {
            name = "luasnip";
            priority = 750;
          }
          {
            name = "buffer";
            priority = 500;
            option = {
              inherit get_bufnrs;
            };
          }
          {
            name = "path";
            priority = 300;
          }
          {
            name = "cmdline";
            priority = 300;
          }
          {
            name = "spell";
            priority = 300;
          }
          {
            name = "fish";
            priority = 250;
          }
          {
            name = "git";
            priority = 250;
          }
          {
            name = "npm";
            priority = 250;
          }
        ];

        window = {
          completion.__raw = ''cmp.config.window.bordered()'';
          documentation.__raw = ''cmp.config.window.bordered()'';
        };
      };
    };

    friendly-snippets.enable = true;
    luasnip.enable = true;

    lspkind = {
      enable = true;

      cmp = {
        enable = true;

        menu = {
          buffer = "";
          calc = "";
          cmdline = "";
          codeium = "󱜙";
          emoji = "󰞅";
          git = "";
          luasnip = "󰩫";
          neorg = "";
          nvim_lsp = "";
          nvim_lua = "";
          path = "";
          spell = "";
          treesitter = "󰔱";
          nixpkgs_maintainers = "";
        };
      };
    };
  };
}
