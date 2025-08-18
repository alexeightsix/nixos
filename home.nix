{ config, pkgs, lib, ... }:

let
  home-manager = builtins.fetchTarball
    "https://github.com/nix-community/home-manager/archive/release-25.05.tar.gz";

  dracula-zsh = builtins.fetchGit {
    url = "https://github.com/dracula/zsh";
    rev = "75ea3f5e1055291caf56b4aea6a5d58d00541c41";
  };

  plugins = {
    cmp = import ./nvim/plugins/cmp.nix { inherit pkgs; };
    colorizer = import ./nvim/plugins/colorizer.nix { inherit pkgs; };
    comment = import ./nvim/plugins/comment.nix { inherit pkgs; };
    conflict = import ./nvim/plugins/conflict.nix { inherit pkgs; };
    conform = import ./nvim/plugins/conform.nix { inherit pkgs; };
    copilot = import ./nvim/plugins/copilot.nix { inherit pkgs; };
    dracula = import ./nvim/plugins/dracula.nix { inherit pkgs; };
    fidget = import ./nvim/plugins/fidget.nix { inherit pkgs; };
    gitSigns = import ./nvim/plugins/git_signs.nix { inherit pkgs; };
    oil = import ./nvim/plugins/oil.nix { inherit pkgs; };
    telescope = import ./nvim/plugins/telescope.nix { inherit pkgs; };
    treesitter = import ./nvim/plugins/treesitter.nix { inherit pkgs; };
    undotree = import ./nvim/plugins/undotree.nix { inherit pkgs; };
    urlOpen = import ./nvim/plugins/url_open.nix { inherit pkgs; };
    sense-nvim = pkgs.vimUtils.buildVimPlugin {
      doCheck = false;
      name = "sense.nvim";
      src = pkgs.fetchFromGitHub {
        owner = "boltlessengineer";
        repo = "sense.nvim";
        rev = "74e61f251fffc64c4f29160569ccde087316b798";
        hash = "sha256-I3k8811otMCTppqeCuu5buevJgDyNtn5nreFw8GFlL8=";
      };
    };
  };
in
{
  imports = [ (import "${home-manager}/nixos") ];

  users.users.alex = { isNormalUser = true; };

  home-manager.users.alex = { pkgs, lib, ... }: {

    programs.i3status-rust = {
      enable = true;
      bars = {
        default = {
          theme = "dracula";
          icons = "awesome4";
          blocks = [
            {
              block = "cpu";
              format = " $icon $utilization ";
              interval = 2;
              info_cpu = 20;
              warning_cpu = 50;
              critical_cpu = 90;
            }
            {
              block = "temperature";
              chip = "*-isa-*";
              format = " $icon $max ";
            }
            {
              block = "memory";
              format = " $icon $mem_used_percents ";
              format_alt = " $icon $swap_used_percents ";
            }
            {
              block = "time";
              interval = 5;
              format = " $timestamp.datetime(f:'%a %d/%m %R') ";
            }
          ];
        };
      };
    };

    xsession.windowManager.i3 = {
      enable = true;
      package = pkgs.i3-gaps;

      config = {
        modifier = "Mod4";
        gaps = {
          inner = 0;
          outer = 0;
        };
        fonts = {
          names = [ "pango" ];
          style = "monospace";
          size = 8.0;
        };
        workspaceLayout = "default";
        floating = { modifier = "Mod4"; };
        keybindings = {
          "Mod4+Return" = "exec i3-sensible-terminal";
          "Mod4+q" = "kill";
          "Mod4+Tab" = "workspace next";
          "Mod4+Shift+Tab" = "workspace prev";

          "Mod4+1" = "workspace 1";
          "Mod4+2" = "workspace 2";
          "Mod4+3" = "workspace 3";
          "Mod4+4" = "workspace 4";
          "Mod4+5" = "workspace 5";
          "Mod4+6" = "workspace 6";
          "Mod4+7" = "workspace 7";
          "Mod4+8" = "workspace 8";
          "Mod4+9" = "workspace 9";
          "Mod4+0" = "workspace 10";

          "Mod4+Shift+1" = "move container to workspace 1";
          "Mod4+Shift+2" = "move container to workspace 2";
          "Mod4+Shift+3" = "move container to workspace 3";
          "Mod4+Shift+4" = "move container to workspace 4";
          "Mod4+Shift+5" = "move container to workspace 5";
          "Mod4+Shift+6" = "move container to workspace 6";
          "Mod4+Shift+7" = "move container to workspace 7";
          "Mod4+Shift+8" = "move container to workspace 8";
          "Mod4+Shift+9" = "move container to workspace 9";
          "Mod4+Shift+0" = "move container to workspace 10";

          "Mod4+r" = "mode resize";
          "Mod4+Shift+c" = "reload";
          "Mod4+Shift+r" = "restart";

          "Mod4+b" = "focus up";
          "Mod4+j" = "focus left";
          "Mod4+k" = "focus down";
          "Mod4+o" = "focus right";

          "Mod4+Down" = "focus down";
          "Mod4+Left" = "focus left";
          "Mod4+Right" = "focus right";
          "Mod4+Up" = "focus up";

          "Mod4+Shift+b" = "move up";
          "Mod4+Shift+j" = "move left";
          "Mod4+Shift+k" = "move down";
          "Mod4+Shift+o" = "move right";

          "Mod4+Shift+Left" = "move left";
          "Mod4+Shift+Down" = "move down";
          "Mod4+Shift+Up" = "move up";
          "Mod4+Shift+Right" = "move right";

          "Mod4+h" = "split h";
          "Mod4+v" = "split v";
          "Mod4+f" = "fullscreen toggle";

          "Mod4+s" = "layout stacking";
          "Mod4+g" = "layout tabbed";
          "Mod4+e" = "layout toggle split";

          "Mod4+Shift+space" = "floating toggle";
          "Mod4+space" = "focus mode_toggle";
          "Mod4+a" = "focus parent";

          "Mod4+Shift+s" = "exec --no-startup-id systemctl suspend";
          "Mod4+d" =
            "exec --no-startup-id ${pkgs.dmenu}/bin/dmenu_run -nf '#BBBBBB' -nb '#222222' -sb '#5294e2' -sf '#EEEEEE' -fn 'monospace-10'";
        };
        keycodebindings = {
          "79" = "move container to workspace 7";
          "80" = "move container to workspace 8";
          "81" = "move container to workspace 9";
          "83" = "move container to workspace 4";
          "84" = "move container to workspace 5";
          "85" = "move container to workspace 6";
          "87" = "move container to workspace 1";
          "88" = "move container to workspace 2";
          "89" = "move container to workspace 3";
          "90" = "move container to workspace 10";
        };
        assigns = {
          "3" = [{ class = "^[Ff]irefox$"; }];
          "7" = [
            { class = "TelegramDesktop"; }
            { class = "[zZ]oom.*"; }
            { class = "^[Tt]elegram.*"; }
            { class = "^[sS]lack.*"; }
            { class = "^[tT]eams.*"; }
            { class = "^[dD]iscord.*"; }
          ];
          "9" = [{
            class = "^[zZ]oom$";
            floating = true;
            instance = "yad";
          }];
        };
        modes = {
          resize = {
            Down = "resize grow height 10 px or 10 ppt";
            Escape = "mode default";
            Left = "resize shrink width 10 px or 10 ppt";
            Return = "mode default";
            Right = "resize grow width 10 px or 10 ppt";
            Up = "resize shrink height 10 px or 10 ppt";
          };
        };
        colors = {
          focused = {
            border = "#5294e2";
            background = "#08052b";
            text = "#ffffff";
            indicator = "#8b8b8b";
            childBorder = "#8b8b8b";
          };
          unfocused = {
            border = "#08052b";
            background = "#08052b";
            text = "#b0b5bd";
            indicator = "#383c4a";
            childBorder = "#383c4a";
          };
          focusedInactive = {
            border = "#08052b";
            background = "#08052b";
            text = "#b0b5bd";
            indicator = "#000000";
            childBorder = "#000000";
          };
          urgent = {
            border = "#e53935";
            background = "#e53935";
            text = "#ffffff";
            indicator = "#e1b700";
            childBorder = "#e1b700";
          };
        };

        bars = [{
          mode = "hide";
          hiddenState = "hide";
          position = "bottom";
          trayPadding = 0;
          statusCommand =
            "${pkgs.i3status-rust}/bin/i3status-rs $HOME/.config/i3status-rust/config-default.toml";
          workspaceNumbers = false;
          colors = {
            background = "#383c4a";
            statusline = "#ffffff";
            separator = "#e345ff";
            activeWorkspace = {
              border = "#5294e2";
              background = "#8b8b8b";
              text = "#383c4a";
            };
            focusedWorkspace = {
              border = "#5294e2";
              background = "#5294e2";
              text = "#ffffff";
            };
            inactiveWorkspace = {
              border = "#383c4a";
              background = "#383c4a";
              text = "#b0b5bd";
            };
            urgentWorkspace = {
              border = "#e53935";
              background = "#e53935";
              text = "#ffffff";
            };
            bindingMode = {
              border = "#FF5555";
              background = "#FF5555";
              text = "#F8F8F2";
            };
          };
          extraConfig = ''
            padding 0 0 0 0
            bindsym button1 nop
            bindsym button4 nop
            bindsym button5 nop
            bindsym button6 nop
            bindsym button7 nop
          '';
        }];

      };

      extraConfig = ''
        new_window pixel 0
        for_window [class=(?i)firefox] focus
        for_window [class=TelegramDesktop] focus
        for_window [class="Zoom" instance="yad"] floating enable
        for_window [class="^.*"] border pixel 0
        for_window [class="^[zZ]oom$"] floating enable
      '';
    };

    home.stateVersion = "25.05";
    home.file = {
      "./.background-image".source = ./wallpapers/wallpaper.png;
      "./.config/nvim/after/".source = ./nvim/config/after;
    };

    programs.git = {
      enable = true;
      aliases = { gs = "status"; };
      extraConfig = {
        init = { defaultBranch = "master"; };
        core = { pager = "delta"; };
        interactive = { diffFilter = "delta --color-only"; };
        merge = { conflictStyle = "zdiff3"; };
        user = {
          name = "Alexander Latour";
          email = "alexlatour@gmail.com";
        };
      };
      delta = {
        options = {
          navigate = true;
          dark = true;
        };
      };
    };

    programs.lazydocker = {
      enable = true;
      settings = { gui = { returnImmediately = true; }; };
    };

    programs.lazygit = { enable = true; };

    programs.alacritty = {
      enable = true;
      theme = "dracula";
      settings = {
        cursor = {
          style = {
            shape = "Beam";
            blinking = "Never";
          };
        };
        env = { term = "alacritty"; };
        font = {
          bold = {
            family = "JetBrains Mono Nerd Font";
            style = "Bold";
          };
          bold_italic = {
            family = "JetBrains Mono Nerd Font";
            style = "Bold Italic";
          };
          italic = {
            family = "JetBrains Mono Nerd Font";
            style = "Italic";
          };
          normal = {
            family = "JetBrains Mono Nerd Font";
            style = "Regular";
          };
          size = 10;
        };
        scrolling = {
          history = 99999;
          multiplier = 0;
        };
        window = {
          blur = true;
          opacity = 0.97;
          padding = {
            x = 0;
            y = 5;
          };
        };
      };
    };
    programs.bash = {
      enable = true;
      historySize = 9999;
    };

    programs.tmux = {
      enable = true;

      baseIndex = 1;
      terminal = "tmux-256color";
      keyMode = "vi"; # or "emacs" if you prefer
      mouse = true; # Generally recommended
      escapeTime = 0; # Faster escape sequences
      historyLimit = 10000; # Reasonable history
      focusEvents = true; # Better terminal integration

      # Plugin configuration
      plugins = with pkgs.tmuxPlugins; [ vim-tmux-navigator dracula sensible ];

      # Custom configuration that can't be set via dedicated options
      extraConfig = ''
          set -g @dracula-plugins " "

          # Terminal overrides and additional settings
          set -g default-terminal "alacritty"
          set -g default-terminal "screen-256color"
          set -g repeat-time 300
          set -ga terminal-overrides ",alacritty:Tc"
          set -gw pane-base-index 1
          set -gw xterm-keys on
          set -g renumber-windows on

          # Pane navigation (vim-like)
          bind h select-pane -L
          bind j select-pane -D
          bind k select-pane -U
          bind l select-pane -R

          # Clear screen binding
          bind C-l send-keys C-l

          # Window and pane creation with current path
          bind c new-window -c "#{pane_current_path}"
          bind '"' split-window -c "#{pane_current_path}"
          bind % split-window -h -c "#{pane_current_path}"

        bind -n F1 if-shell 'tmux select-window -t :1' '''''' 'new-window -t :1 -c "#{pane_current_path}"'
        bind -n F2 if-shell 'tmux select-window -t :2' '''''' 'new-window -t :2 -c "#{pane_current_path}"'
        bind -n F3 if-shell 'tmux select-window -t :3' '''''' 'new-window -t :3 -c "#{pane_current_path}"'
        bind -n F4 if-shell 'tmux select-window -t :4' '''''' 'new-window -t :4 -c "#{pane_current_path}"'
        bind -n F5 if-shell 'tmux select-window -t :5' '''''' 'new-window -t :5 -c "#{pane_current_path}"'
        bind -n F6 if-shell 'tmux select-window -t :6' '''''' 'new-window -t :6 -c "#{pane_current_path}"'
        bind -n F7 if-shell 'tmux select-window -t :7' '''''' 'new-window -t :7 -c "#{pane_current_path}"'
        bind -n F8 if-shell 'tmux select-window -t :8' '''''' 'new-window -t :8 -c "#{pane_current_path}"'
      '';
    };

    programs.zsh = {
      enable = true;

      enableCompletion = true;
      autosuggestion = { enable = true; };
      syntaxHighlighting = { enable = true; };

      shellAliases = {
        lg = "lazygit";
        vi = "nvim --clean";
        vim = "nvim";
        untar = "tar -xvzf";
      };

      sessionVariables = { ZSH_AUTOSTART = "false"; };

      oh-my-zsh = {
        enable = true;
        theme = "dracula";
        custom = "${dracula-zsh}";
        plugins = [ "colorize" "git" "docker-compose" "fzf" "tmux" ];
      };
    };

    programs.zoxide = {
      enable = true;
      enableZshIntegration = true;
    };

    programs.atuin = {
      enable = true;
      enableZshIntegration = true;
      flags = [ "--disable-up-arrow" ];
      settings = {
        style = "compact";
        show_preview = true;
        show_help = false;
        show_tabs = false;
      };
    };

    programs.neovim = {
      enable = true;
      extraLuaPackages = with pkgs; [
        luajitPackages.luarocks
        luajitPackages.luautf8
      ];
      plugins = with pkgs.vimPlugins; [
        cmp-nvim-lsp
        cmp-nvim-lsp-signature-help
        cmp-path
        fidget-nvim
        grug-far-nvim
        harpoon2
        indent-blankline-nvim
        lsp_signature-nvim
        mini-icons
        nvim-lspconfig
        openingh-nvim
        plenary-nvim
        rocks-config-nvim
        rocks-nvim
        telescope-fzf-native-nvim
        telescope-live-grep-args-nvim
        vim-fugitive
        vim-illuminate
        vim-tmux-navigator

        plugins.cmp

        plugins.colorizer
        plugins.comment
        plugins.conflict
        plugins.conform
        plugins.copilot
        plugins.dracula
        plugins.fidget
        plugins.gitSigns
        plugins.oil
        plugins.sense-nvim
        plugins.telescope
        plugins.treesitter
        plugins.undotree
        plugins.urlOpen

        nvim-treesitter-parsers.asm
        nvim-treesitter-parsers.astro
        nvim-treesitter-parsers.awk
        nvim-treesitter-parsers.bash
        nvim-treesitter-parsers.blade
        nvim-treesitter-parsers.c
        nvim-treesitter-parsers.cmake
        nvim-treesitter-parsers.comment
        nvim-treesitter-parsers.css
        nvim-treesitter-parsers.csv
        nvim-treesitter-parsers.desktop
        nvim-treesitter-parsers.diff
        nvim-treesitter-parsers.dockerfile
        nvim-treesitter-parsers.editorconfig
        nvim-treesitter-parsers.git_config
        nvim-treesitter-parsers.git_rebase
        nvim-treesitter-parsers.gitattributes
        nvim-treesitter-parsers.gitcommit
        nvim-treesitter-parsers.gitignore
        nvim-treesitter-parsers.go
        nvim-treesitter-parsers.gomod
        nvim-treesitter-parsers.gosum
        nvim-treesitter-parsers.gotmpl
        nvim-treesitter-parsers.html
        nvim-treesitter-parsers.http
        nvim-treesitter-parsers.java
        nvim-treesitter-parsers.javascript
        nvim-treesitter-parsers.jq
        nvim-treesitter-parsers.jsdoc
        nvim-treesitter-parsers.json
        nvim-treesitter-parsers.jsonc
        nvim-treesitter-parsers.llvm
        nvim-treesitter-parsers.lua
        nvim-treesitter-parsers.luadoc
        nvim-treesitter-parsers.make
        nvim-treesitter-parsers.markdown
        nvim-treesitter-parsers.markdown_inline
        nvim-treesitter-parsers.nginx
        nvim-treesitter-parsers.nix
        nvim-treesitter-parsers.odin
        nvim-treesitter-parsers.php
        nvim-treesitter-parsers.phpdoc
        nvim-treesitter-parsers.printf
        nvim-treesitter-parsers.regex
        nvim-treesitter-parsers.scss
        nvim-treesitter-parsers.sql
        nvim-treesitter-parsers.ssh_config
        nvim-treesitter-parsers.templ
        nvim-treesitter-parsers.terraform
        nvim-treesitter-parsers.tmux
        nvim-treesitter-parsers.toml
        nvim-treesitter-parsers.tsv
        nvim-treesitter-parsers.tsx
        nvim-treesitter-parsers.typescript
        nvim-treesitter-parsers.vim
        nvim-treesitter-parsers.vimdoc
        nvim-treesitter-parsers.vue
        nvim-treesitter-parsers.xml
        nvim-treesitter-parsers.yaml
        nvim-treesitter-parsers.zig
      ];
      extraLuaConfig = ''
        ${builtins.readFile ./nvim/config/options.lua}
        ${builtins.readFile ./nvim/config/auto.lua}
        ${builtins.readFile ./nvim/config/lsp.lua}
        ${builtins.readFile ./nvim/config/log.lua}
        ${builtins.readFile ./nvim/config/keys.lua}
      '';
    };
  };
}
