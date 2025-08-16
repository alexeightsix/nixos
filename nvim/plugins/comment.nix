{ pkgs }:
{
  plugin = pkgs.vimPlugins.comment-nvim;
  config = ''
    lua << EOF
      ${builtins.readFile ./config/comment.lua}
    EOF
  '';
}
