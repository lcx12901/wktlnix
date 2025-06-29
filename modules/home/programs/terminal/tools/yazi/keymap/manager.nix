{
  mgr = {
    prepend_keymap = [
      {
        on = [ "l" ];
        run = "plugin smart-enter";
        desc = "Enter the child directory, or open the file";
      }
      {
        on = [ "<Enter>" ];
        run = "plugin smart-enter";
        desc = "Enter the child directory, or open the file";
      }
    ];

    keymaps = [
      # Find
      {
        on = [ "/" ];
        run = "find --smart";
      }
      {
        on = [ "?" ];
        run = "find --previous --smart";
      }
      {
        on = [ "n" ];
        run = "find_arrow";
      }
      {
        on = [ "N" ];
        run = "find_arrow --previous";
      }
    ];
  };
}
