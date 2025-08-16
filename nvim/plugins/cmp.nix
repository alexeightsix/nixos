{ pkgs }:
{
  plugin = pkgs.vimPlugins.nvim-cmp;
  config = ''
    lua << EOF
      ${builtins.readFile ./config/cmp.lua}
    EOF
  '';
}
