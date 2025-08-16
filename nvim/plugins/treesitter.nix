{ pkgs }:
{
  plugin = pkgs.vimPlugins.nvim-treesitter.withAllGrammars;
  config = ''
    lua << EOF
      ${builtins.readFile ./config/treesitter.lua}
    EOF
  '';
}
