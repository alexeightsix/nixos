{ pkgs }:
{
  plugin = pkgs.vimPlugins.dracula-nvim;
  config = ''
    colorscheme dracula
    hi! Normal ctermbg=none ctermfg=none guifg=none guibg=none
    hi SpecialKey    guifg=#61AFEF
    hi SpecialKeyWin guifg=#61AFEF
    set winhighlight=SpecialKey:SpecialKeyWin
  '';
}
