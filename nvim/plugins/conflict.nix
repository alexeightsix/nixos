{ pkgs }:
{
  plugin = pkgs.vimPlugins.git-conflict-nvim;
  config = ''
    lua << EOF
      ${builtins.readFile ./config/conflict.lua}
    EOF
  '';
}
