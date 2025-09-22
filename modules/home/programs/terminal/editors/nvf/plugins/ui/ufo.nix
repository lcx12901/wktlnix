{ lib, ... }:
let
  inherit (lib.generators) mkLuaInline;
  inherit (lib.nvim.binds) mkKeymap;
in
{
  programs.nvf.settings = {
    vim = {
      ui.nvim-ufo = {
        enable = true;

        setupOpts = {
          preview.mappings = {
            scrollB = "<C-B>";
            scrollF = "<C-F>";
            scrollU = "<C-U>";
            scrollD = "<C-D>";
          };

          provider_selector = mkLuaInline ''
            function(_, filetype, buftype)
              local function handleFallbackException(bufnr, err, providerName)
                if type(err) == "string" and err:match "UfoFallbackException" then
                  return require("ufo").getFolds(bufnr, providerName)
                else
                  return require("promise").reject(err)
                end
              end

              return (filetype == "" or buftype == "nofile") and "indent" -- only use indent until a file is opened
                or function(bufnr)
                  return require("ufo")
                    .getFolds(bufnr, "lsp")
                    :catch(function(err) return handleFallbackException(bufnr, err, "treesitter") end)
                    :catch(function(err) return handleFallbackException(bufnr, err, "indent") end)
                end
            end
          '';
        };
      };

      keymaps = [
        (mkKeymap "n" "zR" ''function() require("ufo").openAllFolds() end'' { desc = "Open all folds"; })
        (mkKeymap "n" "zM" ''function() require("ufo").closeAllFolds() end'' {
          desc = "Close all folds";
        })
        (mkKeymap "n" "zr" ''function() require("ufo").openFoldsExceptKinds() end'' { desc = "Fold less"; })
        (mkKeymap "n" "zm" ''function() require("ufo").closeFoldsWith() end'' { desc = "Fold more"; })
        (mkKeymap "n" "zp" ''function() require("ufo").peekFoldedLinesUnderCursor() end'' {
          desc = "Peek fold";
        })
      ];

      options = {
        foldcolumn = "1";
        foldexpr = "0";
        foldenable = true;
        foldlevel = 99;
        foldlevelstart = 99;
      };
    };
  };
}
