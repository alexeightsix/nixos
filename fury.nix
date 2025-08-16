{ config, pkgs, ... }:

let
  fury-renegade-rgb = pkgs.rustPlatform.buildRustPackage rec {
    pname = "fury-renegade-rgb";
    version = "0.1.0";

    src = pkgs.fetchFromGitHub {
      owner = "ARitz-Cracker";
      repo = "fury-renegade-rgb";
      rev = "562e1eabb7bfc0d24ce76cfb6a794f811313a3a3";
      sha256 = "sha256-RozWoIw08lfXKbEuFbXldT1NBXQ5AHjTHxpqBWv3kCQ=";
    };

    cargoHash = "sha256-Irogq3Yjg3MSQWnMFOLsAt401AQVd6EGnDzYNXLZYLM=";

    doCheck = false;
  };
in {
  hardware.i2c.enable = true;

  users.users.alex = { extraGroups = [ "i2c" ]; };

  users.groups.i2c = { };

  environment.systemPackages = with pkgs; [ fury-renegade-rgb ];

  systemd.services.rgb = {
    description = "Disable RGB";
    wantedBy = [ "multi-user.target" ];
    serviceConfig = {
      ExecStart =
        "${fury-renegade-rgb}/bin/fury-renegade-rgb -b /dev/i2c-7 -2 -4 brightness --value 0";
      Restart = "on-failure";
    };
  };
}

