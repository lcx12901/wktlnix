{
  userCommands = {
    # Takes an argument that determines what method to use for buf_request
    PeekDefinition = {
      nargs = 1;
      command.__raw = ''
        function(opts)
          local function preview_location_callback(_, result)
            if result == nil or vim.tbl_isempty(result) then
                vim.notify('No location found to preview')
              return nil
            end
            if not result[1] then
                vim.notify('Cant peek location')
              return nil
            end
          local buf, _ = vim.lsp.util.preview_location(result[1])
            if buf then
                local cur_buf = vim.api.nvim_get_current_buf()
                vim.bo[buf].filetype = vim.bo[cur_buf].filetype
            end
          end

          local params = vim.lsp.util.make_position_params()
          return vim.lsp.buf_request(0, opts.fargs[1], params, preview_location_callback)
        end
      '';
    };
  };
}
