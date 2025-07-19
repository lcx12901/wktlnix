{ inputs, ... }:
let
  inherit (inputs.nvf.lib.nvim.binds) mkKeymap;
in
{
  programs.nvf.settings = {
    vim.binds = {
      cheatsheet = {
        enable = true;
      };

      whichKey = {
        enable = true;
      };
    };

    vim.keymaps = [
      (mkKeymap "n" "<Space>" "<NOP>" { })
      (mkKeymap "n" "<esc>" "<cmd>noh<CR>" { })
      (mkKeymap "n" "<BS>" "<BS>x" { })
      (mkKeymap "n" "Y" "y$" { })
      (mkKeymap "n" "<C-c>" "<cmd>b#<CR>" { })
      (mkKeymap "n" "<leader>[" "<C-w>h" { desc = "Left window"; })
      (mkKeymap "n" "<leader>]" "<C-w>l" { desc = "Right window"; })
      (mkKeymap "n" "<leader>." "<C-w>j" { desc = "Up window"; })
      (mkKeymap "n" "<leader>," "<C-w>k" { desc = "Down window"; })
      (mkKeymap "n" "<C-[>" "<cmd>cnext<CR>" { })
      (mkKeymap "n" "<C-]>" "<cmd>cprev<CR>" { })
      (mkKeymap "n" "<C-Up>" "<cmd>resize -2<CR>" { })
      (mkKeymap "n" "<C-Down>" "<cmd>resize +2<CR>" { })
      (mkKeymap "n" "<C-Left>" "<cmd>vertical resize -2<CR>" { })
      (mkKeymap "n" "<C-Right>" "<cmd>vertical resize +2<CR>" { })
      (mkKeymap "n" "<M-k>" "<cmd>move-2<CR>" { })
      (mkKeymap "n" "<M-j>" "<cmd>move+<CR>" { })
      (mkKeymap "n" "<leader>q" "<Cmd>confirm q<CR>" { desc = "Quit"; })
      (mkKeymap "n" "<leader>w" "<cmd>w<CR>" { desc = "Save"; })
      (mkKeymap "n" "<leader>W" "<Cmd>w!<CR>" { desc = "Force write"; })
      (mkKeymap "n" "|" "<Cmd>vsplit<CR>" { desc = "Vertical split"; })
      (mkKeymap "n" "-" "<Cmd>split<CR>" { desc = "Horizontal split"; })
      (mkKeymap "n" "<TAB>" "<cmd>bnext<CR>" { desc = "Next buffer (default)"; })
      (mkKeymap "n" "<S-TAB>" "<cmd>bprevious<CR>" { desc = "Previous buffer (default)"; })
      (mkKeymap "n" "<C-H>" "<C-w>h" { desc = "Move to left split"; })
      (mkKeymap "n" "<C-J>" "<C-w>j" { desc = "Move to below split"; })
      (mkKeymap "n" "<C-K>" "<C-w>k" { desc = "Move to above split"; })
      (mkKeymap "n" "<C-L>" "<C-w>l" { desc = "Move to right split"; })
      (mkKeymap "n" "<C-L>" "<C-w>l" { desc = "Move to right split"; })
      (mkKeymap "n" "<C-L>" "<C-w>l" { desc = "Move to right split"; })

      (mkKeymap "v" "<BS>" "x" { desc = "Backspace delete in visual"; })
      (mkKeymap "v" "<S-TAB>" "<gv" { desc = "Unindent line"; })
      (mkKeymap "v" "<TAB>" ">gv" { desc = "Indent line"; })
      (mkKeymap "v" "K" "<cmd>m '<-2<CR>gv=gv<cr>" { })
      (mkKeymap "v" "J" "<cmd>m '<cmd>m '>+1<CR>gv=gv<cr>" { })

      (mkKeymap "i" "<C-k>" "<C-o>gk" { })
      (mkKeymap "i" "<C-h>" "<Left>" { })
      (mkKeymap "i" "<C-l>" "<Right>" { })
      (mkKeymap "i" "<C-j>" "<C-o>gk" { })
    ];
  };
}
