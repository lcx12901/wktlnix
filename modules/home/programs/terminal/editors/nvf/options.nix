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
        cmdheight = 0;
        tabstop = 2;
        shiftwidth = 2;
        expandtab = true;
        swapfile = false;
        undofile = true;
        writebackup = false;
        colorcolumn = "100";
        laststatus = 3;
        report = 9001;
      };
    };
  };
}
