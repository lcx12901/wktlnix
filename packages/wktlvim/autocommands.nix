{
  lib,
  config,
  ...
}: {
  autoCmd = [
    # Remove trailing whitespace on save
    {
      event = "BufWrite";
      command = "%s/\\s\\+$//e";
    }

    # Handle performance on large files
    {
      event = "BufEnter";
      pattern = ["*"];
      callback.__raw = ''
        function()
          local buf_size_limit = 1024 * 1024 -- 1MB size limit
          if vim.api.nvim_buf_get_offset(0, vim.api.nvim_buf_line_count(0)) > buf_size_limit then
            ${lib.optionalString config.plugins.indent-blankline.enable ''require("ibl").setup_buffer(0, { enabled = false })''}
            ${lib.optionalString (lib.hasAttr "indentscope" config.plugins.mini.modules) ''vim.b.miniindentscope_disable = true''}
            ${lib.optionalString config.plugins.illuminate.enable ''require("illuminate").pause_buf()''}

            -- Disable line numbers and relative line numbers
            vim.cmd("setlocal nonumber norelativenumber")

            -- Disable syntax highlighting
            -- vim.cmd("syntax off")

            -- Disable matchparen
            vim.cmd("let g:loaded_matchparen = 1")

            -- Disable cursor line and column
            vim.cmd("setlocal nocursorline nocursorcolumn")

            -- Disable folding
            vim.cmd("setlocal nofoldenable")

            -- Disable sign column
            vim.cmd("setlocal signcolumn=no")

            -- Disable swap file and undo file
            vim.cmd("setlocal noswapfile noundofile")
          end
        end
      '';
    }

    # Enable spellcheck for some filetypes
    {
      event = "FileType";
      pattern = [
        "tex"
        "latex"
        "markdown"
      ];
      command = "setlocal spell spelllang=en_us";
    }
  ];
}
