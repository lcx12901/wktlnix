{
  helpers,
  pkgs,
  ...
}:
let
  version = "1.11.0";

  # https://github.com/AstroNvim/AstroNvim/blob/v4.27.2/lua/astronvim/plugins/_astrocore.lua#L35
  features = {
    # set global limits for large files
    large_buf = {
      size = 1024 * 256;
      lines = 10000;
    };
    # enable autopairs at start
    autopairs = true;
    # enable completion at start
    cmp = true;
    # enable diagnostics by default
    diagnostics_mode = 3;
    # highlight URLs by default
    highlighturl = true;
    # disable notifications
    notifications = true;
  };

  options = {
    g.markdown_recommended_style = 0;
    t.bufs.__raw = ''
      (function()
        if not vim.t.bufs then vim.t.bufs = vim.api.nvim_list_bufs() end
        return vim.t.bufs
      end)()
    '';
  };

  # https://github.com/AstroNvim/AstroNvim/blob/v4.27.2/lua/astronvim/plugins/_astrocore.lua#L67
  rooter = {
    enabled = true;
    autochdir = false;
    notify = false;
    scope = "global";

    detector = [
      "lsp"
      [
        ".git"
        "_darcs"
        ".hg"
        ".bzr"
        ".svn"
      ]
      [
        "lua"
        "MakeFile"
        "package.json"
      ]
    ];

    ignore = {
      dirs = { };
      servers = { };
    };
  };

  # https://github.com/AstroNvim/AstroNvim/blob/v4.27.2/lua/astronvim/plugins/_astrocore.lua#L78
  sessions = {
    autosave = {
      cwd = true;
      last = true;
    };

    ignore = {
      buftypes = { };
      dirs = { };
      filetypes = [
        "gitcommit"
        "gitrebase"
      ];
    };
  };
in
{
  extraPlugins = [
    (pkgs.vimUtils.buildVimPlugin {
      inherit version;

      name = "astrocore";

      src = pkgs.fetchFromGitHub {
        owner = "astronvim";
        repo = "astrocore";
        rev = "v${version}";
        hash = "sha256-MXVr0tJEgkghjchC3yhJAItJYpvw0z9xaZzIk1Czepk=";
      };

      patches = [
        ./init.lua.patch
        ./mason.lua.patch
      ];
    })
  ];

  extraConfigLuaPre = ''
    require("astrocore").setup({
      diagnostics = {},
      features = ${helpers.toLuaObject features},
      options = ${helpers.toLuaObject options},
      rooter = ${helpers.toLuaObject rooter},
      sessions = ${helpers.toLuaObject sessions},

      on_keys = {
        auto_hlsearch = {
          function(char)
            if vim.fn.mode() == "n" then
              local new_hlsearch = vim.tbl_contains({ "<CR>", "n", "N", "*", "#", "?", "/" }, vim.fn.keytrans(char))
              if vim.opt.hlsearch:get() ~= new_hlsearch then vim.opt.hlsearch = new_hlsearch end
            end
          end,
        },
      },
    })
  '';
}
