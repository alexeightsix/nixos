{ config, pkgs, ... }: {
  config = {
    boot = {
      loader = {
        grub = {
          enable = true;
          device = "/dev/vda";
          useOSProber = true;
        };
      };

      blacklistedKernelModules = [
        "pcspkr"
        "snd_pcsp"
      ];
    };

    hardware.bluetooth = {
      enable = true;
      powerOnBoot = true;
    };

    networking = {
      hostName = "nixos";
      networkmanager = {
        enable = true;
      };
      wireless = {
        enable = false;
      };
      firewall = {
        enable = true;
      };
    };

    programs.tmux = {
      enable = true;
    };

    programs.neovim = {
      enable = true;
      viAlias = true;
      defaultEditor = true;
    };

    services = {
      picom = {
        enable = true;
      };
      openssh = {
        enable = true;
        ports = [ 22 ];
        settings = {
          PasswordAuthentication = true;
          AllowUsers = [ "root" "alex" ];
          UseDns = true;
          X11Forwarding = false;
          PermitRootLogin = "yes";
        };
      };

      getty = {
        autologinUser = "alex";
      };

      xserver = {
        enable = true;
        xkb = {
          options = "caps:escape";
        };
        displayManager = {
          lightdm = {
            enable = true;
          };
        };
        desktopManager = {
          wallpaper = {
            mode = "scale";
          };
        };
        windowManager = {
          i3 = {
            enable = true;
            extraPackages = with pkgs; [
              dmenu
              i3status
              i3blocks
              i3status-rust
            ];
          };
        };
        xkb = {
          layout = "us";
          variant = "";
        };
      };
    };

    users = {
      users = {
        alex = {
          isNormalUser = true;
          extraGroups = [ "wheel" "docker" "i2c" ];
        };
      };
    };

    nixpkgs = {
      config = {
        allowUnfree = true;
        permittedInsecurePackages = [ "beekeeper-studio-5.1.5" ];
      };
    };

    time = {
      timeZone = "America/Toronto";
    };

    programs.zsh.enable = true;

    users.users.alex = {
      shell = pkgs.zsh;
    };

    i18n = {
      defaultLocale = "en_CA.UTF-8";
    };

    virtualisation = {
      docker = {
        enable = true;
      };
    };

    fonts.packages = with pkgs; [
      dina-font
      fira-code
      fira-code-symbols
      font-awesome_4
      liberation_ttf
      mplus-outline-fonts.githubRelease
      nerd-fonts.jetbrains-mono
      noto-fonts
      noto-fonts-cjk-sans
      noto-fonts-emoji
      proggyfonts
    ];

    system.stateVersion = "25.05";
    system.copySystemConfiguration = true;

    environment = {
      variables = {
        TERMINAL = "alacritty";
      };
      systemPackages = with pkgs; [
        alacritty
        arandr
        ast-grep
        astro-language-server
        beekeeper-studio
        blade-formatter
        blueman
        blueprint-compiler
        bluez
        bluez-tools
        btrfs-assistant
        cargo
        chromium
        clang-tools
        cmake
        cronie
        delta
        dmenu
        docker-compose-language-service
        dockerfile-language-server-nodejs
        fastfetch
        fd
        feh
        filezilla
        firefox
        flameshot
        flatpak
        fzf
        gettext
        gimp
        git
        gnome-tweaks
        gnumake
        go
        golangci-lint
        golangci-lint-langserver
        golangci-lint-langserver
        gopls
        gparted
        gpick
        gtk4
        i3
        i3status-rust
        inetutils
        intelephense
        jetbrains.goland
        jq
        lazydocker
        lazygit
        libadwaita
        libvirt
        lua-language-server
        lua51Packages.lua
        lua51Packages.luautf8
        htop
        luajit
        luajitPackages.luarocks
        luajitPackages.luarocks
        luajitPackages.luautf8
        mariadb
        ncdu
        nixfmt-classic
        nmap
        nodePackages.prettier
        nodejs_24
        pavucontrol
        php84
        php84Packages.composer
        piper
        postgresql
        prettierd
        python3
        qemu
        rclone
        ripgrep
        rsync
        rubocop
        ruby
        ruby-lsp
        rust-analyzer
        rustc
        slack
        snapper
        stylua
        tailwindcss-language-server
        templ
        tree-sitter
        typescript-language-server
        virt-manager
        vlc
        volumeicon
        vscode-langservers-extracted
        wget
        xclip
        xfce.xfce4-power-manager
        zig
        zip
        zls
        zoom-us

        (pkgs.writeShellScriptBin "sound" ''
          	    exec ${pkgs.pavucontrol}/bin/pavucontrol "$@"
          	'')
      ];
    };
  };
}
