{ pkgs, ... }:
{
  extraPlugins = [
    pkgs.vimPlugins.resession-nvim
  ];

  extraConfigLua = ''
    require("resession").setup({
      -- buf_filter = function(bufnr) return require("astrocore.buffer").is_restorable(bufnr) end,
      -- tab_buf_filter = function(tabpage, bufnr) return vim.tbl_contains(vim.t[tabpage].bufs, bufnr) end,
      -- extensions = { astrocore = { enable_in_tab = true } },
    })
  '';

  # autoCmd = [
  #   {
  #     event = "VimLeavePre";
  #     desc = "Save session on close";
  #     callback.__raw = ''
  #       function()
  #         local buf_utils = require "astrocore.buffer"
  #         local autosave = buf_utils.sessions.autosave
  #         if autosave and buf_utils.is_valid_session() then
  #           local save = require("resession").save
  #           if autosave.last then save("Last Session", { notify = false }) end
  #           if autosave.cwd then save(vim.fn.getcwd(), { dir = "dirsession", notify = false }) end
  #         end
  #       end
  #     '';
  #   }
  # ];

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
