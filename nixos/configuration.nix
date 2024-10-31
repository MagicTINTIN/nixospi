# This is your system's configuration file.
# Use this to configure your system environment (it replaces /etc/nixos/configuration.nix)
{ inputs
, outputs
, hostname
, username
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

  # TODO: Set your hostname
  networking.hostName = hostname; #"nixamer";

  # Bootloader
  # boot.loader.systemd-boot = {
  #   enable = true;
  #   configurationLimit = 10;
  # };
  # NixOS wants to enable GRUB by default
  boot.loader.grub.enable = false;
  # Enables the generation of /boot/extlinux/extlinux.conf
  boot.loader.generic-extlinux-compatible.enable = true;

  # !!! Set to specific linux kernel version
  boot.kernelPackages = pkgs.linuxPackages;

  # Disable ZFS on kernel 6
  boot.supportedFilesystems = lib.mkForce [
    "vfat"
    "xfs"
    "cifs"
    "ntfs"
  ];

  # !!! Needed for the virtual console to work on the RPi 3, as the default of 16M doesn't seem to be enough.
  # If X.org behaves weirdly (I only saw the cursor) then try increasing this to 256M.
  # On a Raspberry Pi 4 with 4 GB, you should either disable this parameter or increase to at least 64M if you want the USB ports to work.
  boot.kernelParams = [ "cma=256M" ];

  # File systems configuration for using the installer's partition layout
  fileSystems = {
    # Prior to 19.09, the boot partition was hosted on the smaller first partition
    # Starting with 19.09, the /boot folder is on the main bigger partition.
    # The following is to be used only with older images.
    /*
      "/boot" = {
      device = "/dev/disk/by-label/NIXOS_BOOT";
      fsType = "vfat";
      };
    */
    "/" = {
      device = "/dev/disk/by-label/NIXOS_SD";
      fsType = "ext4";
    };
  };

  # !!! Adding a swap file is optional, but strongly recommended!
  swapDevices = [{ device = "/swapfile"; size = 1024; }];

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
  # networking.networkmanager.enable = true;
  # WiFi
  hardware = {
    enableRedistributableFirmware = true;
    firmware = [ pkgs.wireless-regdb ];
  };

  # services.watchdogd = {
  #   enable = true;
  #   device = "/dev/watchdog";
  # }
  systemd.watchdog.rebootTime = "10s";
  systemd.watchdog.runtimeTime = "10s";

  services.getty.autologinUser = username;
  services.displayManager.autoLogin = {
    enable = true;
    user = username;
  };

  # Networking
  networking = {
    networkmanager.enable = true;
    # useDHCP = true;
    #interfaces.wlan0 = {
    #  useDHCP = false;
    #  ipv4.addresses = [{
    #    # I used static IP over WLAN because I want to use it as local DNS resolver
    #    address = "192.168.1.4";
    #    prefixLength = 24;
    #  }];
    #};
    interfaces.eth0 = {
      useDHCP = true;
      # I used DHCP because sometimes I disconnect the LAN cable
      ipv4.addresses = [{
        address = "192.168.22.56";
        prefixLength = 24;
      }];
    };

    firewall = {
      enable = true;
      allowPing = true;
      allowedTCPPorts = [ 80 443 ];
    };

    defaultGateway =  {
      address = "192.168.22.1";
      interface = "eth0";
    };

    # hosts = {
    #   # "127.0.0.1" = [ "localhost" "ip.alcproduxion.com" "ipv6.alcproduxion.com" "magictintin.fr" "cpoi.magictintin.fr" "ipv4.magictintin.fr" ];
    #   "127.0.0.1" = [ "localhost" "ip.alcproduxion.com" "magictintin.fr" "cpoi.magictintin.fr" "ipv4.magictintin.fr" ];
    #   "::1" = [ "localhost" "ip.alcproduxion.com" "ipv6.alcproduxion.com" "magictintin.fr" "cpoi.magictintin.fr" ];
    # };

    # Enabling WIFI
    #wireless.enable = true;
    #wireless.interfaces = [ "wlan0" ];
    # If you want to connect also via WIFI to your router
    # wireless.networks."SATRIA".psk = "wifipassword";
    # You can set default nameservers
    # nameservers = [ "192.168.100.3" "192.168.100.4" "192.168.100.1" ];
    # You can set default gateway
    # defaultGateway = {
    #  address = "192.168.1.1";
    #  interface = "eth0";
    # };
  };

  # forwarding
  boot.kernel.sysctl = {
    "net.ipv4.conf.all.forwarding" = true;
    "net.ipv6.conf.all.forwarding" = true;
    "net.ipv4.tcp_ecn" = true;
  };

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
    #gnome-terminal
    epiphany
    #geary
    yelp
    #tali
    #iagno
    #hitori
    #atomix
    #gnome-contacts
  ]);
  
  #services.openssh = {
  #  enable = true;
  #  settings.PermitRootLogin = "yes";
  #};

  # Some sample service.
  # Use dnsmasq as internal LAN DNS resolver.
  services.dnsmasq = {
    enable = true;
    # settings.servers = [ "8.8.8.8" "8.8.4.4" "1.1.1.1" ];
    # settings.extraConfig = ''
    #   address=/.alcproduxion.com/127.0.0.1
    #   address=/.magictintin.fr/127.0.0.1
    #   address=/magictintin.fr/127.0.0.1
    # '';
    settings.address = [ "/.alcproduxion.com/127.0.0.1" "/ipv4.magictintin.fr/127.0.0.1" "/cpoi.magictintin.fr/127.0.0.1" "/magictintin.fr/127.0.0.1" "/0xy.fr/127.0.0.1" "/.0xy.fr/127.0.0.1" ];
  };

  # services.openvpn = {
  #     # You can set openvpn connection
  #     servers = {
  #       privateVPN = {
  #         config = "config /home/nixos/vpn/privatvpn.conf";
  #       };
  #     };
  # };
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
    "${username}" = {
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

  programs.nm-applet = {
    enable = true;
    indicator = true;
  };


  # To install it globally
  # environment.systemPackages =
  #   [ inputs.home-manager.packages.${pkgs.system}.default ];
  environment.systemPackages = with pkgs; [
    inputs.home-manager.packages.${pkgs.system}.default
  ];

  security.acme = {
    acceptTerms = true;
    defaults.email = "magictintin@proton.me";
    # certs = {
    #   "magictintin.fr" = {
    #     # webroot = "/var/www/"
    #     webroot = "/var/lib/acme/acme-challenge/";
    #     # webroot = "/var/www/magictintin.fr/";
    #     extraDomainNames = [ "ipv4.magictintin.fr" "cpoi.magictintin.fr" ];
    #   };
    #   # "alcproduxion.com" = {
    #   #   # webroot = "/var/www/"
    #   #   webroot = "/var/lib/acme/acme-challenge/";
    #   #   extraDomainNames = [ "ip.alcproduxion.com" "ipv6.alcproduxion.com" ];
    #   # };
    # };
  };

  # fix missing websites on startup
  systemd.services.httpd.after = [ "network-online.target" ];
  systemd.services.httpd.wants = [ "network-online.target" ];

  services.httpd = {
    enable = true;
    adminAddr = "magictintin@proton.me";
    enablePHP = true; # oof... 

    # enableSSL = true; # no longer effect

    virtualHosts = {
    # "event.softplus.fr" = {
    #   documentRoot = "/var/www/event";
    #   listen = [
    #     {
    #       ip = "*";
    #       port = 80;
    #     }
    #     {
    #       ip = "*";
    #       port = 443;
    #       ssl = true;
    #     }
    #   ];
    #   extraConfig = ''
    #     RewriteEngine On
    #     RewriteCond %{REQUEST_FILENAME} !-f
    #     RewriteCond %{REQUEST_FILENAME} !-d
    #     # RewriteRule ^(.*)$ /index.php?path=$1 [NC,L,QSA]
    #     RewriteRule ^(([A-Za-z0-9\-]+/)*[A-Za-z0-9\-]+)$ $1.php [L]
    #     # FallbackResource /index.php
    #   '';
    #   # extraConfig = ''
    #   # AllowOverride All  
    #   # '';  # Alias /.well-known/acme-challenge /var/lib/acme/acme-challenge/
    #   # want ssl + a let's encrypt certificate? add `forceSSL = true;` right here
    # };

      "ipv6.alcproduxion.com" = {
        hostName = "ipv6.alcproduxion.com";
        serverAliases = [ "ipv6.alcproduxion.com" ];
        # forceSSL = true;
        # sslServerCert = "/var/lib/acme/ipv6.alcproduxion.com/fullchain.pem";
        # sslServerKey = "/var/lib/acme/ipv6.alcproduxion.com/key.pem";
        sslServerCert = "/etc/ssl/private/a";
        sslServerKey = "/etc/ssl/private/c";
        documentRoot = "/var/www/ipv6.alcproduxion.com";
        addSSL = true;
        extraConfig = ''
          RewriteEngine On
          RewriteCond %{REQUEST_FILENAME} !-f
          RewriteCond %{REQUEST_FILENAME} !-d
          # RewriteRule ^(.*)$ /index.php?path=$1 [NC,L,QSA]
          RewriteRule ^(([A-Za-z0-9\-]+/)*[A-Za-z0-9\-]+)$ $1.php [L]
          # FallbackResource /index.php
          # UseCanonicalName Off
        '';
      };

      "ip.alcproduxion.com" = {
        hostName = "ip.alcproduxion.com";
        serverAliases = [ "ip.alcproduxion.com" ];
        # forceSSL = true;
        # sslServerCert = "/var/lib/acme/ip.alcproduxion.com/fullchain.pem";
        # sslServerKey = "/var/lib/acme/ip.alcproduxion.com/key.pem";
        sslServerCert = "/etc/ssl/private/a";
        sslServerKey = "/etc/ssl/private/c";
        documentRoot = "/var/www/ip.alcproduxion.com";
        addSSL = true;
        extraConfig = ''
          RewriteEngine On
          RewriteCond %{REQUEST_FILENAME} !-f
          RewriteCond %{REQUEST_FILENAME} !-d
          # RewriteRule ^(.*)$ /index.php?path=$1 [NC,L,QSA]
          RewriteRule ^(([A-Za-z0-9\-]+/)*[A-Za-z0-9\-]+)$ $1.php [L]
          # FallbackResource /index.php
          # UseCanonicalName Off
        '';
      };

      "ipv4.magictintin.fr" = {
        hostName = "ipv4.magictintin.fr";
        serverAliases = [ "ipv4.magictintin.fr" ];
        # forceSSL = true;
        # sslServerCert = "/var/lib/acme/ipv4.magictintin.fr/fullchain.pem";
        # sslServerKey = "/var/lib/acme/ipv4.magictintin.fr/key.pem";
        sslServerCert = "/etc/ssl/private/ipmtc";
        sslServerKey = "/etc/ssl/private/ipmtk";
        documentRoot = "/var/www/ipv4.magictintin.fr";
        addSSL = true;
        extraConfig = ''
          RewriteEngine On
          RewriteCond %{REQUEST_FILENAME} !-f
          RewriteCond %{REQUEST_FILENAME} !-d
          # RewriteRule ^(.*)$ /index.php?path=$1 [NC,L,QSA]
          RewriteRule ^(([A-Za-z0-9\-]+/)*[A-Za-z0-9\-]+)$ $1.php [L]
          # FallbackResource /index.php
          # UseCanonicalName Off
        '';
      };

      "cpoi.magictintin.fr" = {
        hostName = "cpoi.magictintin.fr";
        serverAliases = [ "cpoi.magictintin.fr" "www.cpoi.magictintin.fr" ];
        # forceSSL = true;
        # sslServerCert = "/var/lib/acme/cpoi.magictintin.fr/fullchain.pem";
        # sslServerKey = "/var/lib/acme/cpoi.magictintin.fr/key.pem";
        sslServerCert = "/etc/ssl/private/cpmtc";
        sslServerKey = "/etc/ssl/private/cpmtk";

        addSSL = true;

        documentRoot = "/var/www/cpoi.magictintin.fr";
        extraConfig = ''
          RewriteEngine On
          RewriteCond %{REQUEST_FILENAME} !-f
          RewriteCond %{REQUEST_FILENAME} !-d
          # RewriteRule ^(.*)$ /index.php?path=$1 [NC,L,QSA]
          RewriteRule ^(([A-Za-z0-9\-]+/)*[A-Za-z0-9\-]+)$ $1.php [L]
          # FallbackResource /index.php
          # UseCanonicalName Off
        '';
      };

      "magictintin.fr" = {
        hostName = "magictintin.fr";
        serverAliases = [ "magictintin.fr" "www.magictintin.fr" ];
        # forceSSL = true;

        sslServerCert = "/etc/ssl/private/mtc";
        sslServerKey = "/etc/ssl/private/mtk";
        addSSL = true;
        documentRoot = "/var/www/magictintin.fr";
        extraConfig = ''
          RewriteEngine On
          RewriteCond %{REQUEST_FILENAME} !-f
          RewriteCond %{REQUEST_FILENAME} !-d
          # RewriteRule ^(.*)$ /index.php?path=$1 [NC,L,QSA]
          RewriteRule ^(([A-Za-z0-9\-]+/)*[A-Za-z0-9\-]+)$ $1.php [L]
          # FallbackResource /index.php
          # UseCanonicalName Off
        '';
      };

      "c.0xy.fr" = {
        hostName = "c.0xy.fr";
        serverAliases = [ "c.0xy.fr" "*.c.0xy.fr" ];
        # forceSSL = true;

        sslServerCert = "/etc/ssl/private/xyc";
        sslServerKey = "/etc/ssl/private/xyk";
        addSSL = true;
        documentRoot = "/var/www/cpoi.magictintin.fr";
        extraConfig = ''
          RewriteEngine On
          RewriteCond %{REQUEST_FILENAME} !-f
          RewriteCond %{REQUEST_FILENAME} !-d
          # RewriteRule ^(.*)$ /index.php?path=$1 [NC,L,QSA]
          RewriteRule ^(([A-Za-z0-9\-]+/)*[A-Za-z0-9\-]+)$ $1.php [L]
          # FallbackResource /index.php
          # UseCanonicalName Off
        '';
      };

      "0xy.fr" = {
        hostName = "0xy.fr";
        serverAliases = [ "0xy.fr" "*.0xy.fr" ];
        # forceSSL = true;

        sslServerCert = "/etc/ssl/private/xyc";
        sslServerKey = "/etc/ssl/private/xyk";
        addSSL = true;
        documentRoot = "/var/www/0xy.fr";
        extraConfig = ''
          RewriteEngine On
          RewriteCond %{REQUEST_FILENAME} !-f
          RewriteCond %{REQUEST_FILENAME} !-d
          # RewriteRule ^(.*)$ /index.php?path=$1 [NC,L,QSA]
          RewriteRule ^(([A-Za-z0-9\-]+/)*[A-Za-z0-9\-]+)$ $1.php [L]
          # FallbackResource /index.php
          # UseCanonicalName Off
        '';
      };

      "localhost" = {
        hostName = "localhost";
        serverAliases = [ "localhost" ];
        # forceSSL = true;
        documentRoot = "/var/www/default";
        extraConfig = ''
          RewriteEngine On
          RewriteCond %{REQUEST_FILENAME} !-f
          RewriteCond %{REQUEST_FILENAME} !-d
          # RewriteRule ^(.*)$ /index.php?path=$1 [NC,L,QSA]
          RewriteRule ^(([A-Za-z0-9\-]+/)*[A-Za-z0-9\-]+)$ $1.php [L]
          # FallbackResource /index.php
          # UseCanonicalName Off
        '';
      };
  };

  extraConfig = ''
    <Directory "/var/www">
      AllowOverride All
    </Directory>

    <Directory "/var/www/web">
      AllowOverride All
    </Directory>
    '';
  };

  services.mysql.enable = true;
  services.mysql.package = pkgs.mariadb;

  # hacky way to create our directory structure and index page... don't actually use this
  # systemd.tmpfiles.rules = [
  #   "d /var/www/web"
  #   "f /var/www/web/index.php - - - - <?php phpinfo();"
  #   "d /var/www/web4"
  #   "f /var/www/web4/index.php - - - - <?php phpinfo();"
  #   "f /var/www/web4/is4.php - - - - <?php phpinfo();"
  # ];


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
