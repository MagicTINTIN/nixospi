{ config, pkgs, home, ... }:
{
  programs.terminator = {
    enable = true;
    config = {
      global_config.window_state = "maximise";
      global_config.borderless=false;
      profiles.default.show_titlebar = false;
      keybindings.split_horiz = "<Alt><Shift>S";
      keybindings.split_vert = "<Ctrl><Shift>S";
      keybindings.toggle_scrollbar = "<Ctrl>B";
      keybindings.toggle_zoom = "<Ctrl><Shift>!";
    };
  };
}
