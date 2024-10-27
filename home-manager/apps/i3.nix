{ config, pkgs, home, lib, ... }:
{
  home.file =  {
    ".i3b" = {
      source = ./home/i3b;
    };
    ".config/i3/config" = {
      text = builtins.readFile ./home/i3config/config;
    };
    # home.file.".aliases" = {
    #   text = builtins.readFile ./home/.aliases;
    # };
    # home.file.".zshrc" = {
    #   text = builtins.readFile ./home/.zshrc;
    # };
    ".i3blocks.conf" = {
      text = builtins.readFile ./home/.i3blocks.conf;
    };
    ".i3status.conf" = {
      text = builtins.readFile ./home/.i3status.conf;
    };
    ".config/rofi/magictintheme.rasi" = {
      text = builtins.readFile ./home/rofi/magictintheme.rasi;
    };
    # home.file."${pkgs.oh-my-zsh}/share/oh-my-zsh/themes/magictintheme.zsh-theme" = {
    # home.file.".oh-my-zsh/themes/magictintheme.zsh-theme" = {
    #   text = builtins.readFile ./home/ohmyzsh/magictintheme.zsh-theme;
    # };
    # home.file."touchpad.sh" = {
    #   text = builtins.readFile ./home/touchpad.sh;
    # };
  };
}
