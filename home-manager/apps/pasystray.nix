{ config, pkgs, home, ... }:
{
  systemd.user.targets.tray = {
        Unit = {
            Description = "Home Manager System Tray";
            Requires = [ "graphical-session-pre.target" ];
        };
    };
  services.pasystray = {
    enable = true;
  };
}
