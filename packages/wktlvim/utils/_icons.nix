{ lib, ... }:
let
  inherit (lib) types;
in
{
  options = {
    icons = lib.mkOption {
      type = with types; attrs;
      description = "A set of icons from astrovim.";
      default = {
        ActiveLSP = "";
        ActiveTS = "";
        ArrowLeft = "";
        ArrowRight = "";
        Bookmarks = "";
        BufferClose = "󰅖";
        DapBreakpoint = "";
        DapBreakpointCondition = "";
        DapBreakpointRejected = "";
        DapLogPoint = "󰛿";
        DapStopped = "󰁕";
        Debugger = "";
        DefaultFile = "󰈙";
        Diagnostic = "󰒡";
        DiagnosticError = "";
        DiagnosticHint = "󰌵";
        DiagnosticInfo = "󰋼";
        DiagnosticWarn = "";
        Ellipsis = "…";
        Environment = "";
        FileNew = "";
        FileModified = "";
        FileReadOnly = "";
        FoldClosed = "";
        FoldOpened = "";
        FoldSeparator = " ";
        FolderClosed = "";
        FolderEmpty = "";
        FolderOpen = "";
        Git = "󰊢";
        GitAdd = "";
        GitBranch = "";
        GitChange = "";
        GitConflict = "";
        GitDelete = "";
        GitIgnored = "◌";
        GitRenamed = "➜";
        GitSign = "▎";
        GitStaged = "✓";
        GitUnstaged = "✗";
        GitUntracked = "★";
        LSPLoading1 = "";
        LSPLoading2 = "󰀚";
        LSPLoading3 = "";
        MacroRecording = "";
        Package = "󰏖";
        Paste = "󰅌";
        Refresh = "";
        Search = "";
        Selected = "❯";
        Session = "󱂬";
        Sort = "󰒺";
        Spellcheck = "󰓆";
        Tab = "󰓩";
        TabClose = "󰅙";
        Terminal = "";
        Window = "";
        WordFile = "󰈭";
      };
    };
  };
}
