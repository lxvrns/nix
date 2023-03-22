{ config, inputs, pkgs, nix-colors, lib, osConfig, ... }:

{
  # Home Manager needs a bit of information about you and the
  # paths it should manage.
  # colorscheme = nix-colors.colorSchemes.rose-pine-dawn;

  home = {
    username = "lxvrns";
    homeDirectory = "/home/lxvrns";

    packages = with pkgs; [ 
    google-chrome 
    gnome.nautilus
    coreutils tree jq
    pulseaudio
    blender darktable gimp krita inkscape imagemagick gcolor3 kdenlive shotcut audacity handbrake libreoffice 
    zathura mpv foliate calibre imv nitrogen
    amberol nicotine-plus
    git git-crypt gnupg openssl
    playerctl pamixer pavucontrol
    networkmanagerapplet
    picom slop maim xdotool tesseract
    dunst libnotify
    mangohud
    yt-dlp spotdl rhythmbox lollypop cava
    qbittorrent deluge
    ventoy-bin
    aria2 rclone
    # android-tools enable programs.adb instead
    android-udev-rules scrcpy
    tdesktop discord
    obsidian logseq anki 
    rmlint lm_sensors p7zip comma ghostscript qdl
    wezterm
    # Games
    quake3e
    xonotic
    oracle-instantclient
  ];

  # activation = {
  #   genWal = lib.hm.dag.entryAfter ["writeBoundary"] ''
  #     convert ${config.home.homeDirectory}/.dotnix/assets/${config.colorscheme.kind}.png -colorize 1 -fill '#${config.colorscheme.colors.base01}' -tint 100 ${config.home.homeDirectory}/.dotnix/assets/wallpaper.png
  #   '';
  # };

    # This value determines the Home Manager release that your
    # configuration is compatible with. This helps avoid breakage
    # when a new Home Manager release introduces backwards
    # incompatible changes.
    #
    # You can update Home Manager without changing this value. See
    # the Home Manager release notes for a list of state version
    # changes in each release.
  
    stateVersion = "21.11";
  };

  # Let Home Manager install and manage itself.
  programs.home-manager.enable = true; 

  nixpkgs.config.allowUnfree = true;

  modules = {

    desktop = {
      windowManager.i3.enable = true;
      windowManager.awesome.enable = true;
      windowManager.sway.enable = true;
      picom.enable = true;
      dunst.enable = false;
      mako.enable = true;
      waybar.enable = true;
      xidlehook.enable = false;
    };

    shell = {
      zsh.enable = true;
      fish.enable = false;
    };

    programs = {
      foot.enable = true;
      alacritty.enable = true;
      vscode.enable = true;
    };

  };

  services = {
    easyeffects = {
      enable = true;
      preset = "perfect-eq";
    };

  };

  xdg = {
    enable = true;
    mime.enable = true;
    mimeApps = {
      enable = true;

      defaultApplications = {
        "image/jpeg" = [ "imv.desktop" ];
        "image/png" = [ "imv.desktop" ];
        "image/gif" = [ "imv.desktop" ];
        "image/svg+xml" = [ "imv.desktop" ];
        "image/vnd.djvu+multipage" = [ "org.pwmt.zathura.desktop" ];
        "video/mp4" = [ "mpv.desktop" ];
        "video/x-matroska" = [ "mpv.desktop" ];
        "application/pdf" = [ "org.pwmt.zathura.desktop" ];
        "application/json" = [ "nvim.desktop" ];
        "application/x-yaml" = [ "nvim.desktop" ];
        "inode/directory" = [ "org.gnome.Nautilus.desktop" ];
      };

      associations = {
        added = {
          "inode/directory" = [ "org.gnome.Nautilus.desktop" ];
        };
        
        removed = {
          "inode/directory" = [ "code.desktop" ];
        };
      };
    
    };

    dataHome = "${config.home.homeDirectory}/.local/share";
    stateHome = "${config.home.homeDirectory}/.local/state";
    cacheHome = "${config.home.homeDirectory}/.cache";
    configHome = "${config.home.homeDirectory}/.config";

    userDirs = {
      enable = true;
      createDirectories = true;
    };

  };

  imports = [
    ../../modules
    nix-colors.homeManagerModule
  ];
}
