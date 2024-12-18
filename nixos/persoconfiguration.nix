# This is your system's configuration file.
# Use this to configure your system environment (it replaces /etc/nixos/configuration.nix)
{ inputs
, outputs
, hostname
, debug
, lib
, config
, pkgs
, callPackage
, ...
}:
let
  moredebug = "Ok.";
in
{
  # You can import other NixOS modules here
  imports = [
    # If you want to use modules your own flake exports (from modules/nixos):
    # outputs.nixosModules.example

    # Or modules from other flakes (such as nixos-hardware):
    # inputs.hardware.nixosModules.common-cpu-amd
    # inputs.hardware.nixosModules.common-ssd

    # You can also split up your configuration and import pieces of it here:
    # ./users.nix

    # Import your generated (nixos-generate-config) hardware configuration
    ./hardware-configuration.nix
  ];

  nixpkgs = {
    # You can add overlays here
    overlays = [
      # Add overlays your own flake exports (from overlays and pkgs dir):
      outputs.overlays.additions
      outputs.overlays.modifications
      outputs.overlays.unstable-packages

      # You can also add overlays exported from other flakes:
      # neovim-nightly-overlay.overlays.default

      # Or define it inline, for example:
      # (final: prev: {
      #   hi = final.hello.overrideAttrs (oldAttrs: {
      #     patches = [ ./change-hello-to-hi.patch ];
      #   });
      # })
    ];
    # Configure your nixpkgs instance
    config = {
      # Disable if you don't want unfree packages
      allowUnfree = true;
    };
  };

  nix =
    let
      flakeInputs = lib.filterAttrs (_: lib.isType "flake") inputs;
    in
    {
      settings = {
        # Enable flakes and new 'nix' command
        experimental-features = "nix-command flakes";
        # Opinionated: disable global registry
        flake-registry = "";
        # Workaround for https://github.com/NixOS/nix/issues/9574
        nix-path = config.nix.nixPath;
      };
      # Opinionated: disable channels
      channel.enable = true;

      # Opinionated: make flake registry and nix path match flake inputs
      registry = lib.mapAttrs (_: flake: { inherit flake; }) flakeInputs;
      nixPath = lib.mapAttrsToList (n: _: "${n}=flake:${n}") flakeInputs;
    };

  # FIXME: Add the rest of your current configuration

  # TODO: Set your hostname
  networking.hostName = hostname; #"nixamer";

  # Bootloader
  # boot.loader.systemd-boot = {
  #   enable = true;
  #   configurationLimit = 10;
  # };
  boot.loader.efi.canTouchEfiVariables = true;
  # or
  # boot.loader.grub.efiInstallAsRemovable = true;

  boot.loader.grub.enable = true;
  boot.loader.grub.configurationLimit = 10;
  boot.loader.grub.copyKernels = true;
  boot.loader.grub.efiSupport = true;
  # boot.loader.grub.useOSProber = true;
  # boot.loader.grub.fsIdentifier = "label";
  boot.loader.grub.splashImage = ./grubKawan.jpg;
  boot.loader.grub.splashMode = "stretch";

  boot.loader.grub.devices = [ "nodev" ];
  boot.loader.grub.extraEntries =
    if lib.strings.hasPrefix "lordi2" hostname then ''
          menuentry "Arch Linux (btw edition)" --hotkey=a {
            echo "of course you use it"
            set rootest='hd0,gpt5'

            insmod part_gpt
            insmod ext2

            if [ x$feature_platform_search_hint = xy ]; then
              search --no-floppy --fs-uuid --set=root --hint-bios=hd0,gpt5 --hint-efi=hd0,gpt5 --hint-baremetal=ahci0,gpt5  9960d795-268c-4125-9e91-5507e5702e79
            else
              search --no-floppy --fs-uuid --set=root 9960d795-268c-4125-9e91-5507e5702e79
            fi

            linux /boot/vmlinuz-linux root=/dev/sda5 #root=UUID=9960d795-268c-4125-9e91-5507e5702e79 rw

            initrd /boot/initramfs-linux.img
          }


          menuentry "Arch (fallback)" {
            echo "is there a problem ?"
            set rootest='hd0,gpt5'
            linux ($rootest)/boot/vmlinuz-linux root=/dev/sda5 #root=UUID=9960d795-268c-4125-9e91-5507e5702e79 rw
            #($rootest)
            initrd ($rootest)/boot/initramfs-linux-fallback.img
          }

          menuentry "Windows ?" --hotkey=w {
            set color_normal=white/blue
            background_image grub/bsod.jpg
            clear
            set menu_color_normal=white/blue
            echo "PTDR ! t'as cru qu'il y avait windows sur cet ordi ???"
            echo "Non mais et puis quoi encore... pfff"
            play 200 200 1
            sleep --interruptible 5
            if [ "$?" = 1 ]; then
              clear
              echo "T'as qu'à le dire si je te fais chier hein..."
            fi
            color_normal=white/black
          }

          menuentry "Ne choisis pas cette option !" --hotkey=w {
            set menu_color_normal=white/blue
            echo "Never gonna give you up ?"
            play 500 262 1 294 1 349 1 294 1 440 3 440 3 392 5 262 1 294 1 349 1 294 1 392 3 392 3 349 3 330 1 294 3 262 1 294 1 349 1 294 1 349 4 392 2 330 3 294 1 262 3 262 2 392 4 349 4
            sleep --interruptible 5
          }

          ### BEGIN /etc/grub.d/30_uefi-firmware ###
          if [ "$grub_platform" = "efi" ]; then
            fwsetup --is-supported
            if [ "$?" = 0 ]; then
              menuentry 'UEFI de merde Firmware Settings' $menuentry_id_option 'uefi-firmware' {
                fwsetup
              }
            fi
          fi
          ### END /etc/grub.d/30_uefi-firmware ###

          menuentry "Reboot (pas assez rapide pour boot ? tu sais plus la touche ?)" {
      	    echo "Bah alors ? t'as rate la touche de boot ? Le mec est nul quoi !"
            reboot
          }
          menuentry "En fait non !" {
      	    echo "Bon bah je ferme ma gueule alors..."
            halt
          }
    '' else ''menuentry "Reboot" {
      reboot
    }
    menuentry "Poweroff" {
      halt
    }
  '';

   # Make some extra kernel modules available to NixOS
  boot.extraModulePackages = with config.boot.kernelPackages;
    [ v4l2loopback.out ];

  # Activate kernel modules (choose from built-ins and extra ones)
  boot.kernelModules = [
    # Virtual Camera
    "v4l2loopback"
    # Virtual Microphone, built-in
    "snd-aloop"
  ];

  # Enable networking
  networking.networkmanager.enable = true;

  # Set your time zone.
  time.timeZone = "Europe/Paris";

  # Select internationalisation properties.
  i18n.defaultLocale = "en_US.UTF-8";

  i18n.extraLocaleSettings = {
    LC_ADDRESS = "fr_FR.UTF-8";
    LC_IDENTIFICATION = "fr_FR.UTF-8";
    LC_MEASUREMENT = "fr_FR.UTF-8";
    LC_MONETARY = "fr_FR.UTF-8";
    LC_NAME = "fr_FR.UTF-8";
    LC_NUMERIC = "fr_FR.UTF-8";
    LC_PAPER = "fr_FR.UTF-8";
    LC_TELEPHONE = "fr_FR.UTF-8";
    LC_TIME = "fr_FR.UTF-8";
  };

  # Enable the X11 windowing system.
  services.xserver.enable = true;
  # Not ready for wayland yet...
  services.xserver.displayManager.gdm.wayland = false;

  # Enable the GNOME Desktop Environment.
  services.xserver.displayManager.gdm.enable = true;
  services.xserver.desktopManager.gnome.enable = true;
  services.xserver.xkb.extraLayouts.alc = {
    description = "MagicTINTIN's keyboard layout";
    languages = [ "alc" ];
    symbolsFile = ./symbols/alc;
  };

  # enable i3
  services.xserver = {
    windowManager.i3 = {
      enable = true;
      # configFile = ./dotfiles/i3/config;
    };
  };

  environment.gnome.excludePackages = (with pkgs; [
    gnome-tour
    gnome-terminal
    epiphany # web browser
    geary # email reader
    yelp # Help view
    # game apps
    tali # poker
    iagno # go
    hitori # sudoku
    atomix # puzzle
    gnome-contacts
  ]);
  programs.dconf.enable = true;

  # Configure keymap in X11
  services.xserver.xkb = {
    layout = "fr";
    variant = "oss";
  };

  # Configure console keymap
  console.keyMap = "fr";

  # Enable CUPS to print documents.
  services.printing.enable = true;

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
  # environment.variables.EDITOR = "neovim";
  environment.variables.EDITOR = "gedit";
  environment.variables = {
    GI_TYPELIB_PATH = "/run/current-system/sw/lib/girepository-1.0";
    NIX_DEBUG_CFENV = "configuration.nix:\n${debug}";
  };

  programs.zsh.enable = true;
  programs.zsh.shellAliases = {
    nixcf-debug-print = "echo -e \"flake.nix:\n${debug}\nconfiguration.nix:\n${moredebug}\"";
  };
  users.defaultUserShell = pkgs.zsh;
  environment.shells = with pkgs; [ zsh ];

  # TODO: Configure your system-wide user settings (groups, etc), add more users as needed.
  users.users = {
    # FIXME: Replace with your username
    user = {
      # TODO: You can set an initial password for your user.
      # If you do, you can skip setting a root password by passing '--no-root-passwd' to nixos-install.
      # Be sure to change it (using passwd) after rebooting!
      initialPassword = "sdf";
      isNormalUser = true;
      openssh.authorizedKeys.keys = [
        # TODO: Add your SSH public key(s) here, if you plan on using SSH to connect
      ];
      # TODO: Be sure to add any other groups you need (such as networkmanager, audio, docker, etc)
      extraGroups = [ "wheel" "networkmanager" "input" "docker" ];
    };
  };

  # This setups a SSH server. Very important if you're setting up a headless system.
  # Feel free to remove if you don't need it.
  services.openssh = {
    enable = false;
    settings = {
      # Opinionated: forbid root login through SSH.
      PermitRootLogin = "no";
      # Opinionated: use keys only.
      # Remove if you want to SSH using passwords
      PasswordAuthentication = false;
    };
  };

  # To install it for a specific user
  # users.users = {
  #   user = {
  #     packages = [ inputs.home-manager.packages.${pkgs.system}.default ];
  #   };
  # };

  programs.steam = {
    enable = true;
    remotePlay.openFirewall = true; # Open ports in the firewall for Steam Remote Play
    dedicatedServer.openFirewall = true; # Open ports in the firewall for Source Dedicated Server
    package = with pkgs; steam.override { extraPkgs = pkgs: [ attr ]; };
  };

  programs.nm-applet = {
    enable = true;
    indicator = true;
  };


  # To install it globally
  # environment.systemPackages =
  #   [ inputs.home-manager.packages.${pkgs.system}.default ];
  environment.systemPackages = with pkgs; [
    inputs.home-manager.packages.${pkgs.system}.default
    # ...

    # support both 32- and 64-bit applications
    wineWowPackages.stable

    # support 32-bit only
    wine

    # support 64-bit only
    (wine.override { wineBuild = "wine64"; })

    # support 64-bit only
    wine64

    # wine-staging (version with experimental features)
    wineWowPackages.staging

    # winetricks (all versions)
    winetricks

    # native wayland support (unstable)
    wineWowPackages.waylandFull
    
    # ciscoPacketTracer8 go to arch linux for this shit
  ];

  # docker
  # virtualisation.docker.enable = true;
  # virtualisation.docker.daemon.settings = {
  #   userland-proxy = false;
  #   experimental = true;
  #   metrics-addr = "0.0.0.0:9323";
  #   ipv6 = true;
  #   fixed-cidr-v6 = "fd00::/80";
  # };

  # networking.firewall.allowPing = true;
  # networking.firewall.allowedTCPPorts = [ 80 443 ];

  # services.httpd.enable = true;
  # services.httpd.adminAddr = "post@mysite.com";
  # services.httpd.enablePHP = true; # oof... not a great idea in my opinion

  # # services.httpd.virtualHosts."example.org" = {
  # #   documentRoot = "/var/www/mysite.com";
  # #   # want ssl + a let's encrypt certificate? add `forceSSL = true;` right here
  # # };
  # services.httpd.virtualHosts."example" = {
  #   documentRoot = "/var/www/mysite.com";
  #   # want ssl + a let's encrypt certificate? add `forceSSL = true;` right here
  # };

  # services.mysql.enable = true;
  # services.mysql.package = pkgs.mariadb;

  # # hacky way to create our directory structure and index page... don't actually use this
  # systemd.tmpfiles.rules = [
  #   "d /var/www/mysite.com"
  #   "f /var/www/mysite.com/index.php - - - - <?php phpinfo();"
  # ];

  # # # MariaDB
  # # services.mysql = {
  # #   enable = true;
  # #   package = pkgs.mariadb;
  # #   extraOptions = ''
  # #     query_cache_type = 1
  # #     query_cache_limit = 2M
  # #     query_cache_size = 4M
  # #     thread_cache_size = 4
  # #     innodb_buffer_pool_size = 325M
  # #     innodb_buffer_pool_instances = 1
  # #     # smallest value since it's not used
  # #     aria_pagecache_buffer_size = 128K
  # #     # values should be equal
  # #     tmp_table_size = 30M
  # #     max_heap_table_size = 30M
  # #   '';
  # # };

  networking.firewall.allowedTCPPorts = [ 80 443 ];

  services.httpd.enable = true;
  services.httpd.adminAddr = "post@mysite.com";
  services.httpd.enablePHP = true; # oof... not a great idea in my opinion

  services.httpd.virtualHosts."example.org" = {
    documentRoot = "/var/www/mysite.com";
    extraConfig = ''
      RewriteEngine On
      RewriteCond %{REQUEST_FILENAME} !-f
      RewriteCond %{REQUEST_FILENAME} !-d
      # RewriteRule ^(.*)$ /index.php?path=$1 [NC,L,QSA]
      RewriteRule ^(([A-Za-z0-9\-]+/)*[A-Za-z0-9\-]+)$ $1.php [L]
      # FallbackResource /index.php
    '';
    # extraConfig = ''
    # AllowOverride All  
    # '';
    # want ssl + a let's encrypt certificate? add `forceSSL = true;` right here
  };

  services.httpd.extraConfig = ''
    <Directory "/var/www">
      AllowOverride All
    </Directory>

    <Directory "/var/www/mysite.com">
      AllowOverride All
    </Directory>
  '';

  services.mysql.enable = true;
  services.mysql.package = pkgs.mariadb;

  # hacky way to create our directory structure and index page... don't actually use this
  systemd.tmpfiles.rules = [
    "d /var/www/mysite.com"
    "f /var/www/mysite.com/index.php - - - - <?php phpinfo();"
  ];


  # services.phpfpm.pools.phpdemo = {
  #   user = "user";
  #   settings = {
  #     "listen.owner" = config.services.nginx.user;
  #     "pm" = "dynamic";
  #     "pm.max_children" = 32;
  #     "pm.max_requests" = 500;
  #     "pm.start_servers" = 2;
  #     "pm.min_spare_servers" = 2;
  #     "pm.max_spare_servers" = 5;
  #   };
  # };
  # services.nginx = {
  #   enable = true;
  #   virtualHosts."phpdemo.example.com".locations."/" = {
  #     root = "/var/www";
  #     extraConfig = ''
  #       fastcgi_split_path_info ^(.+\.php)(/.+)$;
  #       fastcgi_pass unix:${config.services.phpfpm.pools.phpdemo.socket};
  #       include ${pkgs.nginx}/conf/fastcgi_params;
  #       include ${pkgs.nginx}/conf/fastcgi.conf;
  #     '';
  #    };
  # };
  # users.users.phpdemo = {
  #   isSystemUser = true;
  #   createHome = true;
  #   home = "/var/www/root";
  #   group  = "user";
  # };
  # users.groups.phpdemo = {};

  # https://nixos.wiki/wiki/FAQ/When_do_I_update_stateVersion
  system.stateVersion = "24.05";
}
