{ config, pkgs, ... }:

let
  # Custom startup script for Waybar, SWWW, and Mako
  startupScript = pkgs.pkgs.writeShellScriptBin "start" ''
    ${pkgs.waybar}/bin/waybar &
    ${pkgs.swww}/bin/swww-daemon &
    ${pkgs.mako}/bin/mako &
  '';
in {
  # --------------------------------------------
  # User Configuration
  # --------------------------------------------

  # Home directory and username
  home.username = "simxnet";
  home.homeDirectory = "/home/simxnet";

  # --------------------------------------------
  # File and Directory Linking
  # --------------------------------------------

  # Example of linking a file (e.g., wallpaper)
  # home.file.".config/i3/wallpaper.jpg".source = ./wallpaper.jpg;

  # Link scripts directory to user’s config folder
  # home.file.".config/i3/scripts" = {
  #   source = ./scripts;
  #   recursive = true;
  #   executable = true;
  # };

  # --------------------------------------------
  # Xresources Configuration
  # --------------------------------------------

  # Cursor size and DPI for high-resolution screens
  xresources.properties = {
    "Xcursor.size" = 12;
    "Xft.dpi" = 172;
  };

  # --------------------------------------------
  # Home Packages
  # --------------------------------------------

  home.packages = with pkgs; [
    # Command line tools
    fastfetch
    nnn  # Terminal file manager

    # Archive utilities
    zip xz unzip p7zip

    # Search utilities
    ripgrep jq yq-go eza fzf

    # Networking tools
    mtr iperf3 dnsutils ldns aria2 socat nmap ipcalc

    # Miscellaneous utilities
    cowsay file which tree gnused gnutar gawk zstd gnupg

    # Nix-related tools
    nix-output-monitor

    # Productivity tools
    hugo glow btop iotop iftop

    # System call monitoring
    strace ltrace lsof

    # System tools
    sysstat lm_sensors ethtool pciutils usbutils

    # Browser
    firefox
  ];

  # --------------------------------------------
  # Git Configuration
  # --------------------------------------------

  programs.git = {
    enable = true;
    userName = "Simonet";
    userEmail = "simxnet@envs.net";
  };

  # --------------------------------------------
  # Starship Prompt Configuration
  # --------------------------------------------

  programs.starship = {
    enable = true;
    settings = {
      add_newline = false;
      aws.disabled = true;
      gcloud.disabled = true;
      line_break.disabled = true;
    };
  };

  # --------------------------------------------
  # Kitty Terminal Configuration
  # --------------------------------------------

  programs.kitty = {
    enable = true;
    font = {
      name = "FiraCode Nerd Font";
      size = 11;
    };
    settings = {
      bold_font = "auto";
      italic_font = "auto";
      bold_italic_font = "auto";
      cursor_shape = "beam";
      enable_audio_bell = "no";
      window_padding_width = "22";
      hide_window_decorations = "yes";
      background_opacity = "0.8";
      tab_bar_min_tabs = "1";
      tab_bar_edge = "bottom";
      tab_bar_style = "powerline";
      tab_powerline_style = "slanted";
      tab_title_template = "{title}{' :{}:'.format(num_windows) if num_windows > 1 else ''}";
      background = "#181818";  # Eerie Black
      cursor = "#f5e0dc";  # Pale Pink
      cursor_text_color = "#1e1e2e";  # Dark Gunmetal
      url_color = "#f5e0dc";  # Pale Pink
      active_tab_foreground = "#11111b";  # Chinese Black
      active_tab_background = "#cba6f7";  # Pale Violet
      inactive_tab_foreground = "#cdd6f4";  # Lavender Blue
      inactive_tab_background = "#181825";  # Eerie Black
      tab_bar_background = "#1f1f1f";  # Eerie Black
      mark1_foreground = "#1e1e2e";  # Dark Gunmetal
      mark1_background = "#b4befe";  # Vodka
      mark2_foreground = "#1e1e2e";  # Dark Gunmetal
      mark2_background = "#cba6f7";  # Pale Violet
      mark3_foreground = "#1e1e2e";  # Dark Gunmetal
      mark3_background = "#74c7ec";  # Maya Blue
    };
  };

  # --------------------------------------------
  # Bash Configuration
  # --------------------------------------------

  programs.bash = {
    enable = true;
    enableCompletion = true;
    bashrcExtra = ''
      export PATH="$PATH:$HOME/bin:$HOME/.local/bin:$HOME/go/bin"
    '';
    shellAliases = {
      k = "kubectl";
      urldecode = "python3 -c 'import sys, urllib.parse as ul; print(ul.unquote_plus(sys.stdin.read()))'";
      urlencode = "python3 -c 'import sys, urllib.parse as ul; print(ul.quote_plus(sys.stdin.read()))'";
    };
  };
  
  # --------------------------------------------
  # Gallery-dl Configuration
  # --------------------------------------------

  programs.gallery-dl = {
    enable = true;
    settings = {
      extractor.base-directory = "~/Gallery";
    };
  };

  # --------------------------------------------
  # Wayland & Hyprland Configuration
  # --------------------------------------------

  wayland.windowManager.hyprland = {
    enable = true;
    settings = {
      monitor = [
          ",1920x1080,auto,1,bitdepth,8"
          ",preferred,auto,1,mirror,eDP-1,bitdepth,8"
      ];
      exec-once = ''${startupScript}/bin/start'';

      "$terminal" = "kitty";
      "$browser" = "firefox";
      "$fileManager" = "nnn";
      "$screenshot" = "hyprshot";
      "$menu" = "rofi";

      env = [
        "XCURSOR_SIZE, 12"
        "HYPRCURSOR_THEME, phinger-cursors-light"
        "HYPRCURSOR_SIZE, 12"
      ];

      general = {
        gaps_in = "5";
        gaps_out = "20";
        border_size = "1";
        "col.active_border" = "rgba(33ccffee) rgba(00ff99ee) 45deg";
        "col.inactive_border" = "rgba(595959aa)";
        resize_on_border = "false";
        allow_tearing = "false";
        layout = "dwindle";
      };

      decoration = {
        rounding = "8";
        active_opacity = "1.0";
        inactive_opacity = "0.9";
	shadow = {
	    enabled = false;
	};
        blur = {
            size = 10;
            passes = 2;
            noise = 0.0150;
        };
      };

      animations = {
        enabled = "true";
        bezier = "myBezier, 0.05, 0.9, 0.1, 1.05";
        animation = [
          "windows, 1, 7, myBezier"
          "windowsOut, 1, 7, default, popin 80%"
          "border, 1, 10, default"
          "borderangle, 1, 8, default"
          "fade, 1, 7, default"
          "workspaces, 1, 6, default"
        ];
      };

      misc = {
        force_default_wallpaper = "0";
        disable_hyprland_logo = "true";
      };

      gestures = {
        workspace_swipe = "false";
      };

      device = {
        name = "epic-mouse-v1";
        sensitivity = "-0.5";
      };

      "$mainMod" = "SUPER";

      bind = [
        "CTRL SHIFT, P, exec, $screenshot -m region"
        "$mainMod, SPACE, exec, $menu -show drun"
        "$mainMod, K, exec, $terminal"
        "$mainMod, F, exec, $browser"
        "$mainMod, Q, killactive"
        "$mainMod SHIFT, M, exit"
        "$mainMod, V, togglefloating"
        "$mainMod, P, pseudo,"
        "$mainMod, J, togglesplit,"
        "$mainMod, left, movefocus, l"
        "$mainMod, right, movefocus, r"
        "$mainMod, up, movefocus, u"
        "$mainMod, down, movefocus, d"
        "$mainMod, 1, workspace, 1"
        "$mainMod, 2, workspace, 2"
        "$mainMod, 3, workspace, 3"
        "$mainMod, 4, workspace, 4"
        "$mainMod, 5, workspace, 5"
        "$mainMod, 6, workspace, 6"
        "$mainMod, 7, workspace, 7"
        "$mainMod, 8, workspace, 8"
        "$mainMod, 9, workspace, 9"
        "$mainMod, 0, workspace, 10"
        "$mainMod SHIFT, 1, movetoworkspace, 1"
        "$mainMod SHIFT, 2, movetoworkspace, 2"
        "$mainMod SHIFT, 3, movetoworkspace, 3"
        "$mainMod SHIFT, 4, movetoworkspace, 4"
        "$mainMod SHIFT, 5, movetoworkspace, 5"
        "$mainMod SHIFT, 6, movetoworkspace, 6"
        "$mainMod SHIFT, 7, movetoworkspace, 7"
        "$mainMod SHIFT, 8, movetoworkspace, 8"
        "$mainMod SHIFT, 9, movetoworkspace, 9"
        "$mainMod SHIFT, 0, movetoworkspace, 10"
        "$mainMod, mouse_down, workspace, e+1"
        "$mainMod, mouse_up, workspace, e-1"
      ];

      input = {
          kb_layout = "es,ru";
          kb_options = "grp:alt_space_toggle";
          numlock_by_default = true;
      };

      bindm = [
        "$mainMod, mouse:272, movewindow"
        "$mainMod, mouse:273, resizewindow"
      ];

      windowrulev2 = "suppressevent maximize, class:.*";
    };
  };

  # --------------------------------------------
  # Mako Notification Daemon
  # --------------------------------------------

  services.mako = {
    enable = true;
    settings = {
    	anchor = "top-right";
    	backgroundColor = "#282a36";
    	borderColor = "#bd93f9";
    	borderSize = 3;
    	defaultTimeout = 3000;
    	font = "FiraCode Nerd Font";
   	height = 150;
    	width = 300;
    	icons = true;
    	textColor = "#f8f8f2";
    	layer = "overlay";
    	sort = "-time";
    	extraConfig = ''
		[urgency=low]
		border-color=#282a36
		[urgency=normal]
		border-color=#bd93f9
		[urgency=high]
		border-color=#ff5555
		default-timeout=0
		[category=mpd]
		default-timeout=2000
		group-by=category'';
    };
  };

  # --------------------------------------------
  # Home Manager Version
  # --------------------------------------------

  home.stateVersion = "24.11";

  # Enable home-manager to manage itself
  programs.home-manager.enable = true;
}

