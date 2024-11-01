# This is your home-manager configuration file
# Use this to configure your home environment (it replaces ~/.config/nixpkgs/home.nix)
{ inputs
, outputs
, hostname
, username
, sshusername
, debug
, lib
, config
, pkgs
, extraArgs
, ...
}:

let
  specialArgs = { inherit inputs; };
  moredebug = "Ok.";
in
{
  # You can import other home-manager modules here
  imports = [
    # If you want to use modules your own flake exports (from modules/home-manager):
    # outputs.homeManagerModules.example

    # Or modules exported from other flakes (such as nix-colors):
    # inputs.nix-colors.homeManagerModules.default

    # You can also split up your configuration and import pieces of it here:
    # ./nvim.nix

    # ./computerCase.nix
    # ./autorandrconf.nix
    # ./autorandr.nix

    # ./apps/i3.nix
    # ./apps/gnome.nix
    ./apps/git.nix
    # ./apps/terminator.nix
    # ./apps/rofi.nix
    # ./apps/pasystray.nix
    # ./apps/firefox.nix
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

  programs.zsh = {
    enable = true;
    enableCompletion = true;
    autosuggestion.enable = true;
    syntaxHighlighting.enable = true;
    initExtra = ''
      source /etc/nixos/home-manager/apps/home/ohmyzsh/magictintheme.zsh-theme;
      source /etc/nixos/home-manager/apps/home/.aliases;
      source /etc/nixos/home-manager/apps/home/.nixaliases;
    '';
    oh-my-zsh = {
      enable = true;
      plugins = [ "git" "thefuck" ];
      # theme = "magictintheme";
    };
    sessionVariables = {
      NIX_DEBUG_HM = "sshome.nix:\n${debug}";
    };
    shellAliases = {
      nixhm-debug-print = "echo -e \"flake.nix:\n${debug}\nsshome.nix:\n${moredebug}\"";
    };
  };

  # TODO: Set your username
  home = {
    username = "${sshusername}";
    homeDirectory = "/home/${sshusername}";
  };

  # Add stuff for your user as you see fit:
  programs.neovim.enable = true;
  programs.firefox.enable = false;
  # home.packages = with pkgs; [ steam ];
  home.packages = with pkgs; [
    # utils
    autorandr
    read-edid
    edid-decode
    
    gnupg

    zsh
    thefuck
    oh-my-zsh
    zsh-autosuggestions

    python3

    noto-fonts
    noto-fonts-cjk-sans
    noto-fonts-cjk-serif
    noto-fonts-color-emoji

    neofetch
    htop
    wget
    curl
    git
    cmake
    gnumake
    libgcc
    direnv
    nixpkgs-fmt
    croc
    keepassxc

    rofi-calc
    lm_sensors
    acpi
    sysstat
    lxappearance
    networkmanagerapplet
    wirelesstools

    vim
    vscode
  ];

  # Enable home-manager and git
  programs.home-manager.enable = true;
  programs.git.enable = true;

  # Nicely reload system units when changing configs
  systemd.user.startServices = "sd-switch";

  # Updating GNOME applications list after update
  home.activation.copyDesktopFiles = lib.hm.dag.entryAfter [ "installPackages" ] ''
    if [ "$XDG_CURRENT_DESKTOP" = "GNOME" ]; then
      if [ -d "${config.home.homeDirectory}/.nix-profile/share/applications" ]; then
        rm -rf ${config.home.homeDirectory}/.local/share/applications
        mkdir -p ${config.home.homeDirectory}/.local/share/applications
        for file in ${config.home.homeDirectory}/.nix-profile/share/applications/*; do
          ln -sf "$file" ${config.home.homeDirectory}/.local/share/applications/
        done
      fi
    fi
  '';
  
  # https://nixos.wiki/wiki/FAQ/When_do_I_update_stateVersion
  home.stateVersion = "24.05";
}
