{ config, ... }:
let
  inherit (config) icons;
in
{
  diagnostics = {
    underline = false;
    virtual_text = false;
    update_in_insert = false;
    severity_sort = true;

    float = {
      border = "rounded";
    };
    jump = {
      severity.__raw = "vim.diagnostic.severity.WARN";
    };

    signs = {
      text = {
        "__rawKey__vim.diagnostic.severity.ERROR" = icons.DiagnosticError;
        "__rawKey__vim.diagnostic.severity.WARN" = icons.DiagnosticWarn;
        "__rawKey__vim.diagnostic.severity.HINT" = icons.DiagnosticHint;
        "__rawKey__vim.diagnostic.severity.INFO" = icons.DiagnosticInfo;
      };
      texthl = {
        "__rawKey__vim.diagnostic.severity.ERROR" = "DiagnosticError";
        "__rawKey__vim.diagnostic.severity.WARN" = "DiagnosticWarn";
        "__rawKey__vim.diagnostic.severity.HINT" = "DiagnosticHint";
        "__rawKey__vim.diagnostic.severity.INFO" = "DiagnosticInfo";
      };
    };
  };
}
