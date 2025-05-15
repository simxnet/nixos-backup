# Edit this configuration file to define what should be installed on
# your system. Help is available in the configuration.nix(5) man page
# and in the NixOS manual (accessible by running ‘nixos-help’).

{ config, pkgs, inputs, ... }:

{
  # --------------------------------------------
  # System Configuration
  # --------------------------------------------

  # Hostname and time settings
  networking.hostName = "nixos"; # Define your hostname.
  time.timeZone = "Europe/Madrid"; # Set your time zone.

  # Internationalization and locale settings
  i18n.defaultLocale = "en_US.UTF-8";

  i18n.extraLocaleSettings = {
    LC_ADDRESS = "es_ES.UTF-8";
    LC_IDENTIFICATION = "es_ES.UTF-8";
    LC_MEASUREMENT = "es_ES.UTF-8";
    LC_MONETARY = "es_ES.UTF-8";
    LC_NAME = "es_ES.UTF-8";
    LC_NUMERIC = "en_US.UTF-8";
    LC_PAPER = "es_ES.UTF-8";
    LC_TELEPHONE = "es_ES.UTF-8";
    LC_TIME = "es_ES.UTF-8";
  };

  # --------------------------------------------
  # Boot Configuration
  # --------------------------------------------

  boot.loader = {
    efi = {
      canTouchEfiVariables = true;
    };
    systemd-boot = {
	enable = true;
    };
  };

  # --------------------------------------------
  # Networking Configuration
  # --------------------------------------------

  # Enable NetworkManager for networking
  networking.networkmanager.enable = true;

  # Uncomment and set up if a proxy is needed
  # networking.proxy.default = "http://user:password@proxy:port/";
  # networking.proxy.noProxy = "127.0.0.1,localhost,internal.domain";

  # --------------------------------------------
  # Display and Desktop Environment
  # --------------------------------------------

  # Enable X11 windowing system
  services.xserver.enable = true;

  # Enable GDM and Hyprland Desktop Environment
  services.xserver.displayManager.gdm.enable = true;
  programs.hyprland = {
    enable = true;
    xwayland.enable = true;
  };

  # Configure keymap in X11 and console
  services.xserver.xkb = {
    layout = "es";
    variant = "";
    options = "grp:alt_space_toggle";
  };
  console.keyMap = "es";

  # --------------------------------------------
  # Sound and Audio Configuration
  # --------------------------------------------

  services.pulseaudio.enable = false;
  security.rtkit.enable = true;

  services.pipewire = {
    enable = true;
    alsa.enable = true;
    alsa.support32Bit = true;
    pulse.enable = true;
    # Uncomment if JACK is needed
    # jack.enable = true;
  };

  # --------------------------------------------
  # Printing Configuration
  # --------------------------------------------

  services.printing.enable = true;

  # --------------------------------------------
  # User Configuration
  # --------------------------------------------

  # Define a user account
  users.users.simxnet = {
    isNormalUser = true;
    description = "Yulia Simonet Freynik";
    extraGroups = [ "networkmanager" "wheel" ];
    packages = with pkgs; [
      (discord.override {
	withOpenASAR = true;
      })
    ];
  };

  # --------------------------------------------
  # Package Management
  # --------------------------------------------

  # List system packages to install
  environment.systemPackages = with pkgs; [
    git
    neovim
    wget
    curl
    nnn
    python3
    just
    rofi
    waybar
    waypaper
    swww
    hyprshot
    hyprpicker
    pywal
    mako
    libnotify
    kitty
    gallery-dl
    telegram-desktop
  ];

  # Allow unfree packages (for things like Discord)
  nixpkgs.config.allowUnfree = true;

  # Enable spicetify
  programs.spicetify.enable = true;

  # --------------------------------------------
  # Fonts Configuration
  # --------------------------------------------

  fonts = {
    enableDefaultPackages = true;
    packages = with pkgs; [
      nerd-fonts.fira-code
      nerd-fonts.fira-mono
      nerd-fonts.noto
    ];

    fontconfig = {
      defaultFonts = {
        serif = [ "Noto Nerd Font" ];
        sansSerif = [ "Noto Nerd Font" ];
        monospace = [ "Noto Nerd Font" ];
      };
    };
  };

  # --------------------------------------------
  # Garbage Collection and System Maintenance
  # --------------------------------------------

  nix.gc = {
    automatic = true;
    dates = "weekly";
    options = "--delete-older-than 1w";
  };

  # Enable experimental features (use with caution)
  nix.settings.experimental-features = ["nix-command" "flakes"];

  # --------------------------------------------
  # Hardware Configuration
  # --------------------------------------------

  hardware.graphics.enable = true;

  # --------------------------------------------
  # System State Version (Keep this unchanged)
  # --------------------------------------------

  system.stateVersion = "24.11"; # Did you read the comment?

  # --------------------------------------------
  # Environment Variables
  # --------------------------------------------

  environment.sessionVariables = {
    WLR_NO_HARDWARE_CURSORS = "1";
    NIXOS_OZONE_WL = "1";
  };

  # --------------------------------------------
  # Optional Services and Features
  # --------------------------------------------

  # Uncomment and configure any additional services as needed

  # Enable SSH
  # services.openssh.enable = true;

  # Enable firewall and open specific ports (if needed)
  # networking.firewall.enable = true;
  # networking.firewall.allowedTCPPorts = [ ... ];
  # networking.firewall.allowedUDPPorts = [ ... ];

  # --------------------------------------------
  # Hardware Configuration Import
  # --------------------------------------------

  imports =
    [
      ./hardware-configuration.nix
      inputs.spicetify-nix.nixosModules.default
    ];
}

