{
  lib,
  config,
  ...
}:
{
  plugins.colorizer = {
    enable = true;
  };

  keymaps = lib.mkIf config.plugins.colorizer.enable [
    {
      mode = "n";
      key = "<Leader>uC";
      action.__raw = ''
        function ()
          vim.g.colorizing_enabled = not vim.g.colorizing_enabled
          vim.cmd('ColorizerToggle')
          vim.notify(string.format("Colorizing %s", bool2str(vim.g.colorizing_enabled), "info"))
        end
      '';
      options = {
        desc = "Colorizing toggle";
        silent = true;
      };
    }
  ];
}
