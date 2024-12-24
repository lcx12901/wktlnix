_: {
  manager = {
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
  };
}
