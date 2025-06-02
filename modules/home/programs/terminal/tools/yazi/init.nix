{
  config,
  lib,
}:
let
  enabledPlugins = config.programs.yazi.plugins;
in
{
  initLua =
    lib.optionalString (lib.hasAttr "full-border" enabledPlugins) ''
      require("full-border"):setup()
    ''
    + lib.optionalString (lib.hasAttr "git" enabledPlugins) ''
      require("git"):setup()
    ''
    # Lua
    + ''
      -- Cross session yank
      require("session"):setup({
        sync_yanked = true,
      })

      function Linemode:custom()
        local year = os.date("%Y")
        local time = (self._file.cha.mtime or 0) // 1

        if time > 0 and os.date("%Y", time) == year then
          time = os.date("%b %d %H:%M", time)
        else
          time = time and os.date("%b %d  %Y", time) or ""
        end

        local size = self._file:size()
        return ui.Line(string.format(" %s %s ", size and ya.readable_size(size):gsub(" ", "") or "-", time))
      end
    '';
}
