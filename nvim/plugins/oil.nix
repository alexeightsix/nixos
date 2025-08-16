{ pkgs }:
{
  plugin = pkgs.vimPlugins.oil-nvim;
  config = ''
    lua << EOF
      ${builtins.readFile ./config/oil.lua}
    EOF
  '';
}
