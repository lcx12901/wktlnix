{
  lib,
  pkgs,
  ...
}: let
  inherit (lib) mkDefault;
in {
  clipboard = {
    # Use system clipboard
    register = "unnamedplus";

    providers = {
      wl-copy = {
        enable = true;
        package = pkgs.wl-clipboard;
      };
    };
  };

  globals = {
    # Disable useless providers
    loaded_ruby_provider = 0; # Ruby
    loaded_perl_provider = 0; # Perl
    loaded_python_provider = 0; # Python 2
  };

  opts = {
    updatetime = 100; # Faster completion

    # Line numbers
    relativenumber = true; # Relative line numbers
    number = true; # Display the absolute line number of the current line
    hidden = true; # Keep closed buffer open in the background
    mouse = "a"; # Enable mouse control
    mousemodel = "extend"; # Mouse right-click extends the current selection
    splitbelow = true; # A new window is put below the current one
    splitright = true; # A new window is put right of the current one

    swapfile = false; # Disable the swap file
    undofile = true; # Automatically save and restore undo history
    incsearch = true; # Incremental search: show match for partly typed search command
    ignorecase = true; # When the search query is lower-case, match both lower and upper-case
    #   patterns
    smartcase = true; # Override the 'ignorecase' option if the search pattern contains upper
    #   case characters
    cursorline = true; # Highlight the screen line of the cursor
    cursorcolumn = false; # Highlight the screen column of the cursor
    fileencoding = "utf-8"; # File-content encoding for the current buffer
    termguicolors = true; # Enables 24-bit RGB color in the |TUI|
    wrap = false; # Prevent text from wrapping

    # Tab options
    tabstop = 2; # Number of spaces a <Tab> in the text stands for (local to buffer)
    shiftwidth = 2; # Number of spaces used for each step of (auto)indent (local to buffer)
    softtabstop = 0; # If non-zero, number of spaces to insert for a <Tab> (local to buffer)
    expandtab = true; # Expand <Tab> to spaces in Insert mode (local to buffer)

    textwidth = 0; # Maximum width of text that is being inserted.  A longer line will be
    #   broken after white space to get this width.
  };
}
