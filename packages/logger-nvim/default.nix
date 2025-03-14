
{
  vimUtils,
  _sources,
...
}:
vimUtils.buildVimPlugin {
  inherit (_sources.logger-nvim) pname src version;
}
