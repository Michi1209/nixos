# Edit this configuration file to define what should be installed on
# your system.  Help is available in the configuration.nix(5) man page
# and in the NixOS manual (accessible by running ‘nixos-help’).

{ config, pkgs, ... }:

{
  imports =
    [ # Include the results of the hardware scan.
      ./hardware-configuration.nix
      ./home.nix
    ];

  # Bootloader.
  boot.loader.systemd-boot.enable = true;
  boot.loader.efi.canTouchEfiVariables = true;

  boot.initrd.luks.devices."luks-a888939f-90ad-4fb8-bc8e-31b98db47f7d".device = "/dev/disk/by-uuid/a888939f-90ad-4fb8-bc8e-31b98db47f7d";
  networking.hostName = "nixos"; # Define your hostname.
  # networking.wireless.enable = true;  # Enables wireless support via wpa_supplicant.

  # Configure network proxy if necessary
  # networking.proxy.default = "http://user:password@proxy:port/";
  # networking.proxy.noProxy = "127.0.0.1,localhost,internal.domain";

  # Enable networking
  networking.networkmanager.enable = true;

  services.gnome.gnome-keyring.enable = true;
  # Set your time zone.
  time.timeZone = "Europe/Vienna";

  # Select internationalisation properties.
  i18n.defaultLocale = "en_US.UTF-8";

  i18n.extraLocaleSettings = {
    LC_ADDRESS = "de_AT.UTF-8";
    LC_IDENTIFICATION = "de_AT.UTF-8";
    LC_MEASUREMENT = "de_AT.UTF-8";
    LC_MONETARY = "de_AT.UTF-8";
    LC_NAME = "de_AT.UTF-8";
    LC_NUMERIC = "de_AT.UTF-8";
    LC_PAPER = "de_AT.UTF-8";
    LC_TELEPHONE = "de_AT.UTF-8";
    LC_TIME = "de_AT.UTF-8";
  };

  # Enable the X11 windowing system.
  # services.xserver.enable = true;

  # Enable the XFCE Desktop Environment.
  #services.xserver.displayManager.defaultSession = "none+sway";
  #services.displayManager.autoLogin.user = "michi"
  #services.displayManager.autoLogin.enable = true;
  # services.xserver.displayManager.lightdm.enable = true;
  # services.xserver.desktopManager.xfce.enable = true;
  #services.xserver = {
  #  enable = true;
  #  displayManager.gdm.enable = true;
  #  displayManager.gdm.wayland = true;
  #  displayManager.sessionPackages = [ pkgs.sway ];
  #  libinput.enable = true;
  #};
  
  #services.greetd = {
  #  enable = true;
  #  settings = rec {
  #    initial_session = {
  #      command = "${pkgs.sway}/bin/sway";
  #      user = "michi";
  #    };
  #    default_session = initial_session;
  #  };
  #};

  programs = {
    sway = {
      enable = true;
      wrapperFeatures.gtk = true;
    };
    waybar.enable = true;
    neovim.enable = true;
    zsh = {
      enable = true;
    };
    firefox.enable = true;
    chromium = {
      enable = true;
    };
  };

  # programs.light.enable = true;


  # Configure keymap in X11
  services.xserver.xkb = {
    layout = "us";
    variant = "";
  };

  # Enable CUPS to print documents.
  services.printing.enable = true;
  services.tailscale = {
    enable = true;
    useRoutingFeatures = "client";
  };

  # Enable sound with pipewire.
  hardware.pulseaudio.enable = false;
  security.rtkit.enable = true;
  services.pipewire = {
    enable = true;
    alsa.enable = true;
    alsa.support32Bit = true;
    pulse.enable = true;
    # If you want to use JACK applications, uncomment this
    #jack.enable = true;

    # use the example session manager (no others are packaged yet so this is enabled by default,
    # no need to redefine it in your config for now)
    #media-session.enable = true;
  };

  # Enable touchpad support (enabled default in most desktopManager).
  # services.xserver.libinput.enable = true;

  # Define a user account. Don't forget to set a password with ‘passwd’.
  users.users.michi = {
    isNormalUser = true;
    description = "michi";
    extraGroups = [ "networkmanager" "wheel" "docker" "video" ];
    packages = with pkgs; [
    #  thunderbird
    ];
  };
  users.defaultUserShell = pkgs.zsh;


  fonts.packages = with pkgs; [
     font-awesome
     powerline-fonts
     powerline-symbols
     (nerdfonts.override { fonts = [ "NerdFontsSymbolsOnly" ]; })
  ];

  # Allow unfree packages
  nixpkgs.config.allowUnfree = true;

  # List packages installed in system profile. To search, run:
  # $ nix search wget
  environment.systemPackages = with pkgs; [
    curl
    git
    gnumake
    gnupg
    htop
    nix
    tmux
    tree
    unzip
    fd
    sd
    bat
    autojump
    ripgrep
    fzf
    vim
    micro
    wget
    libgcc
    gcc14
    nodejs_20
    lazydocker
    lazygit

    jq
    hurl
    httpie
    httpie-desktop
    bruno

    xfce.thunar
    slack
    pulseaudio

    grim # screenshot functionality
    slurp # screenshot functionality
    wl-clipboard # wl-copy and wl-paste for copy/paste from stdin / stdout
    # mako # notification system developed by swaywm maintainer
    swaynotificationcenter
    copyq
    rofi-wayland
    pavucontrol
    swayr
    wezterm
    swaylock
    kanshi

    ansible
    vscodium
    jetbrains.webstorm
    scrcpy
    trilium-desktop
    thunderbird

    freetube
   
  ];

  security.polkit.enable = true;

  # Some programs need SUID wrappers, can be configured further or are
  # started in user sessions.
  # programs.mtr.enable = true;
  # programs.gnupg.agent = {
  #   enable = true;
  #   enableSSHSupport = true;
  # };

  # List services that you want to enable:

  # Enable the OpenSSH daemon.
  # services.openssh.enable = true;

  # Open ports in the firewall.
  # networking.firewall.allowedTCPPorts = [ ... ];
  # networking.firewall.allowedUDPPorts = [ ... ];
  # Or disable the firewall altogether.
  # networking.firewall.enable = false;

  # services.libreddit = {};
  virtualisation.docker.enable = true;

  # This value determines the NixOS release from which the default
  # settings for stateful data, like file locations and database versions
  # on your system were taken. It‘s perfectly fine and recommended to leave
  # this value at the release version of the first install of this system.
  # Before changing this value read the documentation for this option
  # (e.g. man configuration.nix or on https://nixos.org/nixos/options.html).
  system.stateVersion = "24.05"; # Did you read the comment?

}
