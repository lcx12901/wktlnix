{
  programs.nvf.settings = {
    vim.tabline.nvimBufferline = {
      enable = true;

      mappings = {
        closeCurrent = "<leader>bc";
        cycleNext = "<leader>b[";
        cyclePrevious = "<leader>b]";
        moveNext = "<leader>bm[";
        movePrevious = "<leader>bm]";
        pick = "<leader>bp";
        sortByDirectory = "<leader>bsd";
        sortByExtension = "<leader>bse";
        sortById = "<leader>bsi";
      };
    };
  };
}
