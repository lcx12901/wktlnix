{
  autoGroups = {
    bufferline.clear = true;
    neotree.clear = true;
  };

  autoCmd = [
    # Remove trailing whitespace on save
    {
      event = "BufWrite";
      command = "%s/\\s\\+$//e";
    }
    # {
    #   desc = "Update buffers when adding new buffers";
    #   event = [
    #     "BufAdd"
    #     "BufEnter"
    #     "TabNewEntered"
    #   ];
    #   group = "bufferline";
    #
    #   callback.__raw = ''
    #     function(args)
    #       local buf_utils = require "astrocore.buffer"
    #       if not vim.t.bufs then vim.t.bufs = {} end
    #       if not buf_utils.is_valid(args.buf) then return end
    #       if args.buf ~= buf_utils.current_buf then
    #         buf_utils.last_buf = buf_utils.is_valid(buf_utils.current_buf) and buf_utils.current_buf or nil
    #         buf_utils.current_buf = args.buf
    #       end
    #       local bufs = vim.t.bufs
    #       if not vim.tbl_contains(bufs, args.buf) then
    #         table.insert(bufs, args.buf)
    #         vim.t.bufs = bufs
    #       end
    #       vim.t.bufs = vim.tbl_filter(buf_utils.is_valid, vim.t.bufs)
    #       require("astrocore").event "BufsUpdated"
    #     end
    #   '';
    # }
  ];
}
