{ pkgs }:
{
  plugin = pkgs.vimPlugins.nvim-treesitter;
  config = ''
    lua << EOF
      ${builtins.readFile ./config/treesitter.lua}
    EOF
  '';
}
