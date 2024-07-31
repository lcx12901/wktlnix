{
  lib,
  pkgs,
  ...
}: {
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
  };
}
