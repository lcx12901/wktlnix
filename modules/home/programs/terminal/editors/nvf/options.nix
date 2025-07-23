{ pkgs, ... }:
{
  programs.nvf.settings = {
    vim = {
      clipboard = {
        enable = true;

        registers = "unnamedplus";

        providers.wl-copy = {
          enable = true;
          package = pkgs.wl-clipboard;
        };
      };

      enableLuaLoader = true;

      withRuby = false;

      options = {
        # UI settings
        cmdheight = 0; # Minimal command line height
        laststatus = 3; # Always show status line
        updatetime = 100;
        relativenumber = true;
        hidden = true;
        incsearch = true;
        ignorecase = true;
        smartcase = true;
        fileencoding = "utf-8";
        termguicolors = true;
        showmode = false;
        showtabline = 2;
        timeoutlen = 500;
        title = true;
        virtualedit = "block";
        lazyredraw = false;
        synmaxcol = 240;
        showmatch = true;
        matchtime = 1;
        startofline = true;
        pumheight = 10;
        linebreak = true;
        breakindent = true;
        history = 100;
        infercase = true;

        # Indentation
        tabstop = 2; # Number of spaces per tab
        shiftwidth = 2; # Number of spaces for each indentation
        expandtab = true; # Use spaces instead of tabs
        autoindent = true;
        copyindent = true;
        preserveindent = true;
        softtabstop = 0;
        textwidth = 0;

        # File handling
        swapfile = false; # Disable swap file
        undofile = true; # Enable persistent undo
        writebackup = false; # Disable backup before overwriting

        # Misc
        report = 9001; # Threshold for reporting changed lines
        wrap = false; # Disable line wrapping
      };
    };
  };
}
