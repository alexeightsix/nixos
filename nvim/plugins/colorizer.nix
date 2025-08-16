{ pkgs }:
{
  plugin = pkgs.vimPlugins.nvim-colorizer-lua;
  config = ''
    lua << EOF
      ${builtins.readFile ./config/colorizer.lua}
    EOF
  '';
}
