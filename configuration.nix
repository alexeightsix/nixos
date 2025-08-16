{ config, pkgs, ... }: {
  imports = [
    ./hardware-configuration.nix
    ./base.nix
    ./home.nix
  ];
}

