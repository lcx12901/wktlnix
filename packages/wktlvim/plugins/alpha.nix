_:
let
  footer.__raw = ''
    function()
      local version = vim.version()
      local nvim_version_info = " " .. version.major .. "." .. version.minor .. "." .. version.patch

      return {
        "                           " .. nvim_version_info .. " in nixos by @wktl",
        "ただ木の叶舞うところで、火が燃えて、火の影は村を照らしていて、新しい木の叶は芽吹く",
      }
    end
  '';
in
{
  plugins.alpha = {
    enable = true;

    layout = [
      {
        type = "padding";
        val.__raw = ''
          vim.fn.max { 2, vim.fn.floor(vim.fn.winheight(0) * 0.2) }
        '';
      }
      {
        type = "text";
        val = [
          "   █     █░██ ▄█▀▄▄▄█████▓ ██▓      "
          "  ▓█░ █ ░█░██▄█▒ ▓  ██▒ ▓▒▓██▒      "
          "  ▒█░ █ ░█▓███▄░ ▒ ▓██░ ▒░▒██░      "
          "  ░█░ █ ░█▓██ █▄ ░ ▓██▓ ░ ▒██░      "
          "  ░░██▒██▓▒██▒ █▄  ▒██▒ ░ ░██████▒  "
          "  ░ ▓░▒ ▒ ▒ ▒▒ ▓▒  ▒ ░░   ░ ▒░▓  ░  "
          "    ▒ ░ ░ ░ ░▒ ▒░    ░    ░ ░ ▒  ░  "
          "    ░   ░ ░ ░░ ░   ░        ░ ░     "
          "      ░   ░  ░                ░  ░  "
          "                                    "
          "  ███▄    █ ██▒   █▓ ██▓ ███▄ ▄███▓ "
          "  ██ ▀█   █▓██░   █▒▓██▒▓██▒▀█▀ ██▒ "
          " ▓██  ▀█ ██▒▓██  █▒░▒██▒▓██    ▓██░ "
          " ▓██▒  ▐▌██▒ ▒██ █░░░██░▒██    ▒██  "
          " ▒██░   ▓██░  ▒▀█░  ░██░▒██▒   ░██▒ "
          " ░ ▒░   ▒ ▒   ░ ▐░  ░▓  ░ ▒░   ░  ░ "
          " ░ ░░   ░ ▒░  ░ ░░   ▒ ░░  ░      ░ "
          "    ░   ░ ░     ░░   ▒ ░░      ░    "
          "          ░      ░   ░         ░    "
          "                ░                   "
        ];
        opts = {
          position = "center";
          hl = "DashboardHeader";
        };
      }
      {
        type = "padding";
        val = 2;
      }
      {
        type = "text";
        val = footer;
        position = "center";
        opts = {
          position = "center";
          hl = "Keyword";
        };
      }
    ];
  };
}
