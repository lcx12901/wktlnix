{
  inputs,
  vimUtils,
}:
vimUtils.buildVimPlugin {
  pname = "fittencode-nvim";
  src = inputs.fittencode-nvim;
  version = inputs.fittencode-nvim.shortRev;
}
