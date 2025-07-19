{ pkgs, ... }:
{
  programs.nvf.settings = {
    vim.clipboard = {
      enable = true;

      registers = "unnamedplus";

      providers.wl-copy = {
        enable = true;
        package = pkgs.wl-clipboard;
      };
    };

    vim.enableLuaLoader = true;

    vim.withRuby = false;

    # vim.autocomplete.nvim-cmp.setupOpts.completion.completeopt = "fuzzy,menuone,noselect,popup";

    vim.options = {
      cmdheight = 0;
      tabstop = 2;
      shiftwidth = 2;
      expandtab = true;
      writebackup = false;
      colorcolumn = "100";
      laststatus = 3;
      report = 9001;
    };
  };
}
