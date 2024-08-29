-- AstroCommunity: import any community modules here
-- We import this file in `lazy_setup.lua` before the `plugins/` folder.
-- This guarantees that the specs are processed before any user plugins.

---@type LazySpec
return {
  "AstroNvim/astrocommunity",
  -- Motion
  { import = "astrocommunity.motion.mini-surround" },
  -- https://github.com/echasnovski/mini.ai
  { import = "astrocommunity.motion.mini-ai" },
  { import = "astrocommunity.motion.flash-nvim" },
  { import = "astrocommunity.pack.lua" },

  -- Language Support
  ---- Frontend & NodeJS
  { import = "astrocommunity.pack.typescript-all-in-one" },
  { import = "astrocommunity.pack.html-css" },
  -- { import = "astrocommunity.pack.vue" },
  { import = "astrocommunity.pack.prisma" },
  ---- Configuration Language
  { import = "astrocommunity.pack.markdown" },
  { import = "astrocommunity.pack.json" },
  { import = "astrocommunity.pack.yaml" },
  { import = "astrocommunity.pack.toml" },
  ---- Backend / System
  { import = "astrocommunity.pack.lua" },
  { import = "astrocommunity.pack.rust" },
  { import = "astrocommunity.pack.python" },
  ---- Operation & Cloud Native
  { import = "astrocommunity.pack.bash" },
  { import = "astrocommunity.pack.docker" },

  -- colorscheme
  { import = "astrocommunity.colorscheme.catppuccin" },

  { import = "astrocommunity.recipes.neovide" },
}
