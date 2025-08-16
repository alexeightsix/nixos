{ pkgs }:
{
  plugin = pkgs.vimPlugins.gitsigns-nvim;
  config = ''
    lua << EOF
      ${builtins.readFile ./config/git_signs.lua}
    EOF
  '';
}
