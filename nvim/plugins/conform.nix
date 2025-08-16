{ pkgs }:
{
  plugin = pkgs.vimPlugins.conform-nvim;
  config = ''
    lua << EOF
      ${builtins.readFile ./config/conform.lua}
    EOF
  '';
}
