# Edit this configuration file to define what should be installed on
# your system.  Help is available in the configuration.nix(5) man page
# and in the NixOS manual (accessible by running ‘nixos-help’).

{ config, pkgs, lib, ... }:

let
  unstable = import <nixpkgs-unstable> { };
  in 
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

  # firmware updates
  services.fwupd.enable = true;

  # https://nixos.wiki/wiki/Power_Management
  # suspend power issues
  services.udev.extraRules = ''
    ACTION=="add", SUBSYSTEM=="pci", DRIVER=="pcieport", ATTR{power/wakeup}="disabled"
  '';
  
  services.greetd = {                                                      
    enable = true;                                                         
    settings = rec {
      initial_session = {
      	                                                  
        command = "${pkgs.greetd.tuigreet}/bin/tuigreet --time --cmd sway";
        user = "michi";                                                  
      
      };                                                           
      default_session = initial_session;                                                                   
    };                                                                     
  };
    # kanshi systemd service
  systemd.user.services.kanshi = {
    description = "kanshi daemon";
    environment = {
      WAYLAND_DISPLAY="wayland-1";
      DISPLAY = ":0";
    }; 
    serviceConfig = {
      Type = "simple";
      ExecStart = ''${pkgs.kanshi}/bin/kanshi -c ~/.config/kanshi/config'';
    };
  };

  

  programs = {
    sway = {
      enable = true;
      wrapperFeatures.gtk = true;
    };
    zsh = {
      enable = true;
	  enableCompletion = false;
    };
    waybar.enable = true;
    neovim.enable = true;
    firefox.enable = true;
    chromium = {
      enable = true;
    };
    adb.enable = true;
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


# 	services.tlp = {
# 	      enable = true;
# 	      settings = {
# 	        CPU_SCALING_GOVERNOR_ON_AC = "performance";
# 	        CPU_SCALING_GOVERNOR_ON_BAT = "powersave";
# 
# 	        CPU_ENERGY_PERF_POLICY_ON_BAT = "power";
# 	        CPU_ENERGY_PERF_POLICY_ON_AC = "performance";
# 
# 	        CPU_MIN_PERF_ON_AC = 0;
# 	        CPU_MAX_PERF_ON_AC = 100;
# 	        CPU_MIN_PERF_ON_BAT = 0;
# 	        CPU_MAX_PERF_ON_BAT = 20;
# 
# 	       #Optional helps save long term battery health
# 	       START_CHARGE_THRESH_BAT0 = 40; # 40 and bellow it starts to charge
# 	       STOP_CHARGE_THRESH_BAT0 = 80; # 80 and above it stops charging
# 
# 	      };
# 	};

	services.auto-cpufreq.enable = true;
	services.auto-cpufreq.settings = {
	  battery = {
	     governor = "powersave";
	     turbo = "never";
	  };
	  charger = {
	     governor = "performance";
	     turbo = "auto";
	  };
	};
	powerManagement.enable = true;

  # Enable touchpad support (enabled default in most desktopManager).
  # services.xserver.libinput.enable = true;

  # Define a user account. Don't forget to set a password with ‘passwd’.
  users.users.michi = {
    isNormalUser = true;
    description = "michi";
    
    extraGroups = [ "networkmanager" "wheel" "docker" "video" "adbusers" ];
    packages = [
    #  thunderbird
    unstable.zed-editor
    unstable.bruno
    ];
  };
  users.defaultUserShell = pkgs.zsh;


  fonts.packages = with pkgs; [
     font-awesome
     corefonts
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

	tesseract
    gum # tasty shell scripts
    direnv
    glow # render ma
    zathura
	dive # docker explorer as tui
	wtf # personal dashboard
    jq
    hurl
    httpie
    httpie-desktop
    
    xfce.thunar
    slack
    pulseaudio

	wireguard-tools
	dig # nslookup etc
	doggo # human dns client
	
    grim # screenshot functionality
    slurp # screenshot functionality
    wl-clipboard # wl-copy and wl-paste for copy/paste from stdin / stdout
    wdisplays
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

  
  # Enable sound with pipewire.
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

  # Bluetooth settings  
  # hardware.pulseaudio = {
  #   enable = true;
  #   package = pkgs.pulseaudioFull;
  # };
  hardware.bluetooth.enable = true;
  hardware.bluetooth.settings = {
    General = {
      Enable = "Source,Sink,Media,Socket";
	  Experimental = true;
    };
  };
  services.blueman.enable = true;

#headset buttons to control media player
  # systemd.user.services.mpris-proxy = {
  #   description = "Mpris proxy";
  #   after = [ "network.target" "sound.target" ];
  #   wantedBy = [ "default.target" ];
  #   serviceConfig.ExecStart = "${pkgs.bluez}/bin/mpris-proxy";
  # };

  
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

  nix.gc = {
   automatic = true;
   dates = "weekly";
   options = "--delete-older-than 30d";
  };

  # services.fprintd.enable = true;
  systemd.services.fprintd = {
    wantedBy = [ "multi-user.target" ];
    serviceConfig.Type = "simple";
  };

  services.libreddit = {
  	enable = true;
  	port = 7890;
  	
  };

  services.nginx = {
    enable = true;
    recommendedProxySettings = true;
    # recommendedTlsSettings = true;
    virtualHosts."libreddit.localhost" = {
      locations."/".proxyPass = "http://localhost:7890";
    };
  };


  # allow swaylock input to first ask for password, and if we press enter, fingerprint auth will be started. 
  security.pam.services.swaylock = lib.mkIf (config.services.fprintd.enable) {
    text = ''
account required pam_unix.so # unix (order 10900)

auth		sufficient  	pam_unix.so try_first_pass likeauth nullok
auth		sufficient  	${pkgs.fprintd}/lib/security/pam_fprintd.so
auth required pam_deny.so # deny (order 12300)

# Password management.
password sufficient pam_unix.so nullok yescrypt # unix (order 10200)

# Session management.
session required pam_env.so conffile=/etc/pam/environment readenv=0 # env (order 10100)
session required pam_unix.so # unix (order 10200)

    '';
  };

  # services.libreddit = {};
  virtualisation.docker.enable = true;

  
  virtualisation.waydroid.enable = true;

  # This value determines the NixOS release from which the default
  # settings for stateful data, like file locations and database versions
  # on your system were taken. It‘s perfectly fine and recommended to leave
  # this value at the release version of the first install of this system.
  # Before changing this value read the documentation for this option
  # (e.g. man configuration.nix or on https://nixos.org/nixos/options.html).
  system.stateVersion = "24.05"; # Did you read the comment?

}
