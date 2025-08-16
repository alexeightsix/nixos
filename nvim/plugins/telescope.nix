{ pkgs }:
{
  plugin = pkgs.vimPlugins.telescope-nvim;
  config = ''
    lua << EOF
      ${builtins.readFile ./config/telescope.lua}
    EOF
  '';
}
