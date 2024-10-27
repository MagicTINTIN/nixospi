{ config, pkgs, home, ... }:
{
  programs.rofi = {
    enable = true;
    plugins = [ pkgs.rofi-calc ];
  };
}
