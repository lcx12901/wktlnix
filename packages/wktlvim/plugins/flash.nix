{
  plugins.flash = {
    enable = true;
  };

  keymaps = [
    {
      mode = "n";
      key = "s";
      action.__raw = ''
        function() require("flash").jump() end
      '';
      options = {
        desc = "Flash jump";
      };
    }
    {
      mode = "n";
      key = "S";
      action.__raw = ''
        function() require("flash").treesitter() end
      '';
      options = {
        desc = "Flash treesitter";
      };
    }
  ];
}
