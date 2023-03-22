# vim:foldmethod=marker:foldmarker=\=\ {,};
# Edit this configuration file to define what should be installed on
# your system.  Help is available in the configuration.nix(5) man page
# and in the NixOS manual (accessible by running ‘nixos-help’).

{ config, inputs, lib, pkgs, ... }:

let
  nvidia-offload = pkgs.writeShellScriptBin "nvidia-offload" ''
    export __NV_PRIME_RENDER_OFFLOAD=1
    export __NV_PRIME_RENDER_OFFLOAD_PROVIDER=NVIDIA-G0
    export __GLX_VENDOR_LIBRARY_NAME=nvidia
    export __VK_LAYER_NV_optimus=NVIDIA_only
    exec "$@"
  '';
in

{
  imports =
    [ # Include the results of the hardware scan.
      ./hardware-configuration.nix
    ];

  # Use the systemd-boot EFI boot loader.
  boot = {
    kernelPackages = pkgs.linuxPackages_latest;
    kernelParams = [
      "acpi_osi=Linux"
      "acpi_rev_override=1"
      "mem_sleep_default=deep"
    ];
  
    initrd = {
      kernelModules = [
        "scsi_mod"
      ];
    };
    
    loader.systemd-boot.enable = true;
    loader.efi.canTouchEfiVariables = false;
    blacklistedKernelModules = [ "nouveau" ];
    
    loader = {
      grub = {
        efiSupport = true;
        #enable = true;
        version = 2;
        useOSProber = true;
        copyKernels = true;
        devices = [ "nodev" ];        
      };
    };
    #kernelPackages = pkgs.linuxPackages;

    #supportedFilesystems = [ "btrfs" "ntfs" ];
    #kernelParams = [
    #  "quiet"
    #  "loglevel=3"
    #  "systemd.show_status=0"
    #];

    #tmpOnTmpfs = true;
    #cleanTmpDir = true;
  };

  documentation = {
    enable = true;
    man.enable = true;
    dev.enable = true;
  };


  nixpkgs.config = {
    allowUnfree = true;
    packageOverrides = pkgs: {
      vaapiIntel = pkgs.vaapiIntel.override { enableHybridCodec = true; };
    };

  };

  nix = {
    package = pkgs.nixFlakes;
    extraOptions = ''
    experimental-features = nix-command flakes 
      keep-outputs = true
      keep-derivations = true
  '';
    checkConfig = true;

    gc = {
      automatic = true;
      persistent = true;
      dates = "weekly";
      options = "--delete-older-than 30d";
    };

    optimise.automatic = true;

    settings = {
    auto-optimise-store = true;
    allowed-users = [ "lxvrns" ];
    # substituters = [ "https://nix-gaming.cachix.org" ];
    # trusted-public-keys = [ "nix-gaming.cachix.org-1:nbjlureqMbRAxR1gJ/f3hxemL9svXaZF/Ees8vCUUs4=" ];
    };

    registry = lib.mapAttrs' (n: v:
      lib.nameValuePair (n) ({ flake = v; })
    ) inputs;

  };

  #networking.wireless.enable = true;  # Enables wireless support via wpa_supplicant.
 
  networking = {
    hostName = "nixos"; # Define your hostname.
    useDHCP = false;
    dhcpcd.enable = false;

    interfaces = { 
      enp6s0f1.useDHCP = true;
      wlan0.useDHCP = true;
    };

    networkmanager = {
      enable = true;
      #dns = "none";
      #wifi.backend = "iwd";
    };
    
    wireless.iwd = {
      enable = true;
      settings.Settings.Autoconnect = true;
    };

    firewall = {
      enable = false;
    };

  };

  # Set your time zone.
  time.timeZone = "Pacific/Auckland";

  # The global useDHCP flag is deprecated, therefore explicitly set to false here.
  # Per-interface useDHCP will be mandatory in the future, so this generated config
  # replicates the default behaviour.
  # networking.useDHCP = false;
  # networking.interfaces.enp1s0.useDHCP = true;

  # Configure network proxy if necessary
  # networking.proxy.default = "http://user:password@proxy:port/";
  # networking.proxy.noProxy = "127.0.0.1,localhost,internal.domain";

  # Select internationalisation properties.
  i18n.defaultLocale = "en_US.UTF-8";
  console = {
    font = "Lat2-Terminus16";
    keyMap = "us";
  };

  # Enable the X11 windowing system.
  services = {
    xserver = {
      enable = true;
      layout = "us";
      xkbOptions = "caps:swapescape, compose:ralt";
    # Enable touchpad support (enabled default in most desktopManager).
      libinput = {
      enable = true;

      touchpad = {
        naturalScrolling = true;
        disableWhileTyping = true;
      };

      mouse = {
        middleEmulation = false;
      };

    };

      displayManager = {
        lightdm.enable = false;
        startx.enable = true;
        gdm.enable = true;
      };

      windowManager = {
        fvwm2 = {
         enable = true; 
         gestures = true;
        };

        i3 = {
          enable = true; 
        };

        awesome = {
          enable = false;
          luaModules = [ pkgs.luaPackages.luarocks ];
        };
      };

      # Not launching wayland session :(
      desktopManager = {
        gnome = {
          enable = true;
          #extraGSettingsOverrides = import ../../modules/desktop/desktopManagers/gnome/gnomeGSettingsOverrides.nix;
        };
      };

           
      };

    gnome = {
      gnome-initial-setup.enable = false;
      core-utilities.enable = true;
      games.enable = false;
      sushi.enable = true;
    };

        # greetd = {
    #   enable = true;

    #   settings = {
    #     default_session = {
    #       command = "${pkgs.greetd.tuigreet}/bin/tuigreet --time --cmd 'sway'";
    #       user = "greeter";
    #     };
    #   };

    # };
 
    undervolt = {
      enable = true;
      coreOffset = -150;
      gpuOffset = -95;
    };

    logind = {
      lidSwitch = "suspend";
      extraConfig = "HandlePowerKey=ignore";
    };

    gnome.gnome-keyring.enable = true;
    gvfs.enable = true;
    auto-cpufreq.enable = true;
    blueman.enable = true;

  };

  # Configure in HM
  # qt5 = {
  #     enable = true;
  #     style = "${if config.colorscheme.kind == "light" then "adwaita" else "adwaita-dark"}";
  #     platformTheme = "gnome";
  # };

  # Enable CUPS to print documents.
  # services.printing.enable = true;

  # Sound
  sound.enable = true;

  services.pipewire = {
    enable = true;
    alsa = {
      enable = true;
      support32Bit = true;
    };

    pulse.enable = true;

#    lowLatency = {
#      enable = true;
#      quantum = 32;
#      rate = 48000;
#    };

    wireplumber.enable = false;
    media-session.enable = true;

  };

  security.rtkit.enable = true;

  # Systemd 
  #systemd = {
  #  services = {
  #    "NetworkManager-wait-online".enable = false;
  #  };
  #};

  hardware = {
    enableAllFirmware = true;
    pulseaudio.enable = false;

    bluetooth = {
      enable = true;
    };

    opengl = {
      enable = true;
      extraPackages = with pkgs; [
        intel-media-driver
        vaapiIntel
        vaapiVdpau
        libvdpau-va-gl
      ];
      driSupport32Bit = true;
    };
   
  };

    # Nvidia Configuration
    services.xserver.videoDrivers = [ "nvidia" ];
    hardware = {

      nvidia = {
        prime = {
          offload.enable = true;
          intelBusId = "PCI:0:2:0";
          nvidiaBusId = "PCI:1:0:0";
        };

        modesetting.enable = false;
        powerManagement = {
          enable = false;
          finegrained = false;
        };
      };
    };

  # Define a user account. Don't forget to set a password with ‘passwd’.
  users.users.lxvrns = {
    isNormalUser = true;
    extraGroups = [ "wheel" "networkmanager" "video" "adbusers" "docker" ]; # Enable ‘sudo’ for the user.
    initialPassword = "123456";
    shell = pkgs.zsh;
  };

  # List packages installed in system profile. To search, run:
  # $ nix search wget
  environment = { 
    systemPackages = with pkgs; [
      wget # Do not forget to add an editor to edit configuration.nix! The Nano editor is also installed by default.
      nano
      glib
      brightnessctl
      ffmpeg nv-codec-headers
      wayfire wcm
      pciutils usbutils btop ripgrep fd bat
      # Gnome Stuff
      gnomeExtensions.user-themes
      gnomeExtensions.just-perfection
      gnomeExtensions.caffeine
      gnomeExtensions.night-theme-switcher
      gnome.gnome-tweaks
      # Gaming
      nvidia-offload mesa vulkan-loader vulkan-tools
      # wineWowPackages.stable
      wineWowPackages.staging lutris winetricks
      # inputs.nix-gaming.packages.${pkgs.system}.wine-tkg
      lutris
    ];

    gnome.excludePackages = (with pkgs; [
      gnome-tour
    ]) ++ (with pkgs.gnome; [
      gnome-music
      gnome-terminal
      gedit
      epiphany
      geary
      gnome-characters
      totem
      tali
      iagno
      hitori
      atomix
    ]);

    binsh = "${pkgs.dash}/bin/dash";

    # For Zsh Completion
    pathsToLink = [ "/share/zsh" ];

    # Set them through HM
    variables = {
    #   EDITOR = "nvim";
    #   VISUAL = "nvim";
       FVWM_USERDIR = "$HOME/.config/fvwm";    
    };

  };

  fonts = {
    fonts = with pkgs; [ 
      noto-fonts
      noto-fonts-cjk
      inter
      iosevka
      ibm-plex
      fira-code
      scientifica
      siji
      twemoji-color-font
      paratype-pt-serif
      material-icons
      merriweather
      merriweather-sans
      font-awesome
    ];

    fontconfig = {
      enable = true;
      useEmbeddedBitmaps = true;

      defaultFonts = {
        serif = [ "Pt Serif" ];
        sansSerif = [ "Inter" ];
        monospace = [ "Scientifica"];
        emoji = [ "Twitter Color Emoji" ];
      };

      localConf = ''
      <?xml version='1.0'?>
      <!DOCTYPE fontconfig SYSTEM 'fonts.dtd'>
      <fontconfig>
       <match target="font">
          <test name="family"><string>scientifica</string></test>
          <edit name="antialias" mode="assign"><bool>false</bool></edit>
          <edit name="autohint" mode="assign"><bool>false</bool></edit>
          <edit name="hinting" mode="assign"><bool>false</bool></edit>
          <edit name="hintstyle" mode="assign"><const>hintnone</const></edit>
          <edit name="rgba" mode="assign"><const>none</const></edit>
        </match>
      </fontconfig>
      '';
    };


  };

  programs = {
    zsh.enable = false; # Enabling results in increased startup time
    dconf.enable = true;
    gnome-disks.enable = true;
    xwayland.enable = true;
    steam.enable = true;

    tmux = {
      enable = true;
      keyMode = "vi";
      shortcut = "a";
      extraConfig = ''
        setw -g mouse on
      '';
    };

    gamemode = {
      enable = true;
      enableRenice = true;
    };

    sway = {
      enable = true;
      wrapperFeatures = {
        base = true;
        gtk = true;
      };

      extraOptions = [
        "--unsupported-gpu"
      ];

      extraSessionCommands = ''
        export XDG_SESSION_DESKTOP=sway
        export SDL_VIDEODRIVER=wayland
        export QT_QPA_PLATFORM=wayland-egl
        export QT_WAYLAND_DISABLE_WINDOWDECORATION=1
        export MOZ_ENABLE_WAYLAND=1
        export MOZ_DISABLE_RDD_SANDBOX=1
        export CLUTTER_BACKEND=wayland
        export ECORE_EVAS_ENGINE=wayland-egl
        export ELM_ENGINE=wayland_egl
        export NO_AT_BRIDGE=1
        export _JAVA_AWT_WM_NONREPARENTING=1
        '';

    };

    adb.enable = true;
    gnupg.agent = {
      enable = true;
      enableSSHSupport = true;
    };
  };

  virtualisation = {
    docker = {
      enable = true;
      enableNvidia = true;
    };

  };

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

  # This value determines the NixOS release from which the default
  # settings for stateful data, like file locations and database versions
  # on your system were taken. It‘s perfectly fine and recommended to leave
  # this value at the release version of the first install of this system.
  # Before changing this value read the documentation for this option
  # (e.g. man configuration.nix or on https://nixos.org/nixos/options.html).
  system.stateVersion = "21.11"; # Did you read the comment?

}

