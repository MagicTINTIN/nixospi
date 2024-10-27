{ config, pkgs, lib, hostname, ... }:

## BACKGROUND WALLPAPERS IMAGES
let
  # Check if the file ~/.about exists
  #aboutFileExists = lib.pathIsRegularFile /home/user/.about; #config.home.homeDirectory."/.about".path; #"${
  
  # Read the content of the ~/.about file if it exists
  # aboutFileContent = if aboutFileExists then builtins.readFile "${config.home.homeDirectory}/.about" else "que dalle";
  # aboutFileContent = "ntm";# builtins.readFile "${config.home.homeDirectory}/.about";

  # Determine which image to use based on the content of ~/.about
  bgImageToLink = if lib.strings.hasPrefix "lordi" hostname then ./assets/fond.jpg else ./assets/bg.jpg;
  i3lockImageToLink = if lib.strings.hasPrefix "lordi" hostname then ./assets/bsodlock_lordi.png else ./assets/bsodlock.png;
in
{
  home.file."nixvars".text = ''
    lordi hasPrefix ${hostname} ? file ${config.home.homeDirectory}/.about []
  '';
  programs.bash = {
    enable = true;
    sessionVariables = {
      NIXAMER = "IS MY COMPUTER";
    };
  };
  # Other Home Manager options...

  # Conditionally link the image to the ~/Pictures directory
  home.file."Pictures/nixLinked/bg.jpg" = {
    source = bgImageToLink;
  };
  home.file."Pictures/nixLinked/i3lock.png" = {
    source = i3lockImageToLink;
  };
}