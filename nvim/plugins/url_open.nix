{ pkgs }:
{
  plugin = pkgs.vimPlugins.url-open;
  config = ''
    lua << EOF
      ${builtins.readFile ./config/url_open.lua}
    EOF
  '';
}
