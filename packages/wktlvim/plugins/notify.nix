{config, ...}: let
  inherit (config) icons;
in {
  plugins.notify = {
    enable = true;
    fps = 60;
    stages = "fade";

    maxHeight.__raw = "function() return math.floor(vim.o.lines * 0.75) end";
    maxWidth.__raw = "function() return math.floor(vim.o.columns * 0.75) end";

    icons = {
      debug = icons.Debugger;
      error = icons.DiagnosticError;
      info = icons.DiagnosticInfo;
      trace = icons.DiagnosticHint;
      warn = icons.DiagnosticWarn;
    };

    onOpen = ''
      function(win)
        local buf = vim.api.nvim_win_get_buf(win)
        vim.api.nvim_buf_set_option(buf, "filetype", "markdown")
        vim.api.nvim_win_set_config(win, { zindex = 175 })
        vim.wo[win].conceallevel = 3
        vim.wo[win].spell = false
      end
    '';
  };

  keymaps = [
    {
      mode = "n";
      key = "<Leader>uD";
      action.__raw = "function() require('notify').dismiss { pending = true, silent = true } end";
      options.desc = "Dismiss notifications";
    }
    {
      mode = "n";
      key = "<Leader>fn";
      action.__raw = "function() TelescopeWithTheme('notify', {}, 'notify') end";
      options.desc = "Find notifications";
    }
  ];
}
