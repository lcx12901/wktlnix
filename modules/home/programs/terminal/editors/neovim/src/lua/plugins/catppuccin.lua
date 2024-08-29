return {
  "catppuccin/nvim",
  name = "catppuccin",
  opts = function(_, opts)
    opts.flavour = "frappe" -- latte, frappe, macchiato, mocha
    opts.transparent_background = true -- setting the background color.
  end,
}
