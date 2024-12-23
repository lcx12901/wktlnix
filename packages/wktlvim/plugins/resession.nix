{ pkgs, ... }:
{
  extraPlugins = [
    pkgs.vimPlugins.resession-nvim
  ];

  extraConfigLua = ''
    require("resession").setup({
      autosave = {
        enabled = true,
        interval = 60,
        notify = false,
      },
    })
  '';

  keymaps = [
    {
      mode = "n";
      key = "<Leader>Sl";
      action.__raw = ''
        function() require("resession").load "Last Session" end
      '';
      options = {
        desc = "Load last session";
      };
    }
    {
      mode = "n";
      key = "<Leader>Ss";
      action.__raw = ''
        function() require("resession").save() end
      '';
      options = {
        desc = "Save this session";
      };
    }
    {
      mode = "n";
      key = "<Leader>SS";
      action.__raw = ''
        function() require("resession").save(vim.fn.getcwd(), { dir = "dirsession" }) end
      '';
      options = {
        desc = "Save this dirsession";
      };
    }
    {
      mode = "n";
      key = "<Leader>St";
      action.__raw = ''
        function() require("resession").save_tab() end
      '';
      options = {
        desc = "Save this tab's session";
      };
    }
    {
      mode = "n";
      key = "<Leader>Sd";
      action.__raw = ''
        function() require("resession").delete() end
      '';
      options = {
        desc = "Delete a session";
      };
    }
    {
      mode = "n";
      key = "<Leader>SD";
      action.__raw = ''
        function() require("resession").delete(nil, { dir = "dirsession" }) end
      '';
      options = {
        desc = "Delete a dirsession";
      };
    }
    {
      mode = "n";
      key = "<Leader>Sf";
      action.__raw = ''
        function() require("resession").load() end
      '';
      options = {
        desc = "Load a session";
      };
    }
    {
      mode = "n";
      key = "<Leader>SF";
      action.__raw = ''
        function() require("resession").load(nil, { dir = "dirsession" }) end
      '';
      options = {
        desc = "Load a dirsession";
      };
    }
    {
      mode = "n";
      key = "<Leader>S.";
      action.__raw = ''
        function() require("resession").load(vim.fn.getcwd(), { dir = "dirsession" }) end
      '';
      options = {
        desc = "Load current dirsession";
      };
    }
  ];
}
