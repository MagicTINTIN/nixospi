{ config, pkgs, home, lib, ... }:
{
  dconf.settings = with lib.hm.gvariant; {
    "org/gnome/shell" = {
      disable-user-extensions = false;
      disabled-extensions = "disabled";
      enabled-extensions = with pkgs.gnomeExtensions; [
        "drive-menu@gnome-shell-extensions.gcampax.github.com"
        "user-theme@gnome-shell-extensions.gcampax.github.com"
        # "workspace-indicator@gnome-shell-extensions.gcampax.github.com"

        # "tophat@fflewddur.github.io"
        # "topiconsfix@aleskva@devnullmail.com"
        # "freon@UshakovVasilii_Github.yahoo.com"
        tophat.extensionUuid
        topiconsfix.extensionUuid
        freon.extensionUuid
        astra-monitor.extensionUuid

        # "user-theme@gnom-shell-extensions.gcampax.github.com"
        # "native-window-placement@gnome-shell-extensions.gcampax.github.com"
        # "pop-shell@system76.com"
        # "caffeine@patapon.info"
        # "hidetopbar@mathieu.bidon.ca"
        # "gsconnect@andyholmes.github.io"
      ];
      favorite-apps = [ "org.gnome.Settings.desktop" "brave-browser.desktop" "firefox.desktop" "discord.desktop" "freetube.desktop" ];
      had-bluetooth-devices-setup = true;
      remember-mount-password = false;
      welcome-dialog-last-shown-version = "42.4";
    };
    "org/gnome/desktop/background" = {
      # picture-uri-dark = "file:///etc/nixos/assets/bg.jpg"; # file://${pkgs.nixos-artwork.wallpapers.nineish-dark-gray.src}
      # picture-uri-dark = "file:///home/user/Pictures/nixLinked/bg.jpg";
      picture-uri-dark = "file:///etc/nixos/home-manager/assets/bg.jpg";
    };
    "org/gnome/mutter" = {
      edge-tiling = true;
      dynamic-workspaces = true;
    };
    "org/gnome/desktop/calendar" = {
      show-weekdate = true;
    };
    # "org/gnome/desktop/input-sources" = {
    #   # mru-sources  = []; #"@a(ss) []";
    #   show-all-sources = true;
    #   sources = lib.mkOverride 50 [
    #     "('xkb', 'fr+oss')"
    #     "('xkb', 'us')"
    #   ];
    # };
    "org/gnome/settings-daemon/plugins/color" = {
      night-light-enabled = true;
    };
    "org/gnome/shell/extensions/hidetopbar" = {
      enable-active-window = false;
      enable-intellihide = false;
    };
    "org/gnome/shell/extensions/user-theme" = {
      name = "adwaita-dark";
    };
    "org/gnome/desktop/interface" = {
      show-battery-percentage = true;
      clock-show-seconds = true;
      clock-show-weekday = true;
      color-scheme = "prefer-dark";
      enable-hot-corners = false;
      font-antialiasing = "grayscale";
      font-hinting = "slight";
      gtk-theme = "Yaru-dark"; #"Adwaita"; #"adwaita-dark"; #Nordic
      toolkit-accessibility = true; #FIXME true ?
    };
    "org/gnome/settings-daemon/plugins/power" = {
      power-saver-profile-on-low-battery = true;
      sleep-inactive-ac-type = "nothing";
    };
    "org/gnome/desktop/default-applications/terminal" = {
      exec = "terminator";
    };
    "org/gnome/mutter/wayland/keybindings" = {
      restore-shortcuts = ["<Super><Alt><Shift>Escape"];
    };
    "org/gnome/desktop/wm/keybindings" = {
      switch-input-source = ["<Super>Escape"];
      switch-input-source-backward = ["<Shift><Super>Escape"];
      activate-window-menu = "disabled";
      toggle-message-tray = "disabled";
      show-desktop = [ "<Super>d" ];
      close = [ "<Super><Shift>q" "<Alt>F4" ];
      # maximize = "disabled";
      minimize = [ "<Super>w" ];
      # move-to-monitor-down = "disabled";
      # move-to-monitor-left = "disabled";
      # move-to-monitor-right = "disabled";
      # move-to-monitor-up = "disabled";
      # move-to-workspace-down = "disabled";
      # move-to-workspace-up = "disabled";
      # toggle-maximized = ["<Super>m"];
      unmaximize = "disabled";
    };
    "org/gnome/desktop/wm/preferences" = {
      button-layout = "appmenu:minimize,maximize,close"; # the fun : close,close,appmenu:close,close,close,close
      num-workspaces = 10;
    };
    # "org/gnome/shell/extensions/pop-shell" = {
    #   focus-right = "disabled";
    #   tile-by-default = true;
    #   tile-enter = "disabled";
    # };
    "org/gnome/desktop/peripherals/touchpad" = {
      tap-to-click = true;
      two-finger-scrolling-enabled = true;
    };
    # "org/gnome/settings-daemon/plugins/media-keys" = {
    #   next = [ "<Shift><Control>n" ];
    #   previous = [ "<Shift><Control>p" ];
    #   play = [ "<Shift><Control>space" ];
    #   custom-keybindings = [
    #     "/org/gnome/settings-daemon/plugins/media-keys/custom-keybindings/custom0/"
    #     "/org/gnome/settings-daemon/plugins/media-keys/custom-keybindings/custom1/"
    #     "/org/gnome/settings-daemon/plugins/media-keys/custom-keybindings/custom2/"
    #     "/org/gnome/settings-daemon/plugins/media-keys/custom-keybindings/custom3/"
    #   ];
    # };
    "org/gnome/settings-daemon/plugins/media-keys" = {
      home = [ "<Super>e" ];
      www = [ "<Super>b" ];
      custom-keybindings = [
        "/org/gnome/settings-daemon/plugins/media-keys/custom-keybindings/custom0/"
        "/org/gnome/settings-daemon/plugins/media-keys/custom-keybindings/custom1/"
        "/org/gnome/settings-daemon/plugins/media-keys/custom-keybindings/custom2/"
        "/org/gnome/settings-daemon/plugins/media-keys/custom-keybindings/custom3/"
        "/org/gnome/settings-daemon/plugins/media-keys/custom-keybindings/custom4/"
        "/org/gnome/settings-daemon/plugins/media-keys/custom-keybindings/custom5/"
        "/org/gnome/settings-daemon/plugins/media-keys/custom-keybindings/custom6/"
      ];
    };
    "org/gnome/settings-daemon/plugins/media-keys/custom-keybindings/custom0" = {
      name = "terminator super";
      command = "terminator";
      binding = "<Super>Return";
    };
    "org/gnome/settings-daemon/plugins/media-keys/custom-keybindings/custom1" = {
      name = "terminator ctrl_alt";
      command = "terminator";
      binding = "<Ctrl><Alt>t";
    };
    "org/gnome/settings-daemon/plugins/media-keys/custom-keybindings/custom2" = {
      name = "system monitor";
      command = "gnome-system-monitor";
      binding = "<Ctrl><Shift>Escape";
    };
    "org/gnome/settings-daemon/plugins/media-keys/custom-keybindings/custom3" = {
      name = "discord i3like";
      command = "discord";
      binding = "<Super>c";
    };
    "org/gnome/settings-daemon/plugins/media-keys/custom-keybindings/custom4" = {
      name = "rofi calc";
      command = "rofi -theme ~/.config/rofi/magictintheme.rasi -show calc";
      binding = "<Super>comma";
    };
    "org/gnome/settings-daemon/plugins/media-keys/custom-keybindings/custom5" = {
      name = "dmenu";
      # command = "dmenu_run";
      command = "dmenu_run -nf '#BBBBBB' -nb '#222222' -sb '#95290D' -sf '#EEEEEE' -fn 'monospace-10' -p '>'";
      binding = "<Super>space";
    };
    "org/gnome/settings-daemon/plugins/media-keys/custom-keybindings/custom6" = {
      name = "screenshot maim";
      command = "/etc/nixos/home-manager/apps/ss.sh";
      binding = "<Shift><Super>s";
    };
    "org/gnome/shell" = {
      screenshot = [ "<Ctrl>Print" ];
      show-screenshot-ui = [ "Print" ];
    };
    "org/gtk/gtk4/settings/file-chooser" = {
      show-hidden = true;
    };
    "org/gtk/settings/file-chooser" = {
      show-hidden = true;
    };
    # "org/gnome/settings-daemon/plugins/media-keys/custom-keybindings/custom2" = {
    #   name = "rofi-rbw";
    #   command = "rofi-rbw --action copy";
    #   binding = "<Ctrl><Super>s";
    # };
    # "org/gnome/settings-daemon/plugins/media-keys/custom-keybindings/custom3" = {
    #   name = "rofi launcher";
    #   command = "rofi -theme nord -show run -display-run 'run: '";
    #   binding = "<Super>space";
    # };
    "org/gnome/desktop/input-sources" = {
      # xkb-options = [ "terminate:ctrl_alt_bksp" "caps:escape_shifted_capslock" ];
      sources = [ (mkTuple [ "xkb" "alc" ]) (mkTuple [ "xkb" "fr+oss" ]) (mkTuple [ "xkb" "us" ]) ];
    };

    "org/gnome/desktop/search-providers" = {
      sort-order = [
        "org.gnome.Contacts.desktop"
        "org.gnome.Documents.desktop"
        "org.gnome.Settings.desktop"
        "org.gnome.Nautilus.desktop"
        "org.gnome.Calculator.desktop"
        "org.gnome.Characters.desktop"
        "org.gnome.Calendar.desktop"
        "org.gnome.clocks.desktop"
        "org.gnome.seahorse.Application.desktop"
      ];
    };

    "org/gnome/shell/extensions/freon" = {
      # hot-sensors = [ 'NVIDIA GeForce RTX 2060', 'max' ];
      panel-box-index = 3;
      show-decimal-value = false;
      show-icon-on-panel = false;
      show-rotationrate = true;
      show-temperature = true;
      # use-drive-nvmecli = true;
      # use-generic-liquidctl = true;
      # use-generic-lmsensors = true;
      # use-gpu-bumblebeenvidia = true;
      # use-gpu-nvidia = true;
    };

    "org/gnome/shell/extensions/tophat" = {
      meter-fg-color = "rgb (224, 27,36)";
      show-disk = false;
      show-icons = false;
    };
    "org/gnome/shell/extensions/astra-monitor" = {
      gpu-indicators-order = "['icon','activity bar','activity graph','activity percentage','memory bar','memory graph','memory percentage','memory value']";
      headers-height = 0;
      headers-height-override = 0;
      memory-header-bars-color1 = "rgb(237,51,59)";
      memory-header-bars-color2 = "rgba(214,29,29,0.3)";
      memory-header-graph-color1 = "rgb(237,51,59)";
      memory-header-graph-color2 = "rgba(214,29,29,0.3)";
      memory-header-icon = false;
      memory-header-percentage = false;
      memory-header-tooltip = true;
      memory-header-value = false;
      memory-indicators-order = "['icon','bar','graph','percentage','value','free']";
      monitors-order = "['processor','gpu','memory','storage','network','sensors']";
      network-header-icon = false;
      network-header-icon-size = 17;
      network-header-io-bars-color1 = "rgb(246,97,81)";
      network-header-io-graph-color1 = "rgb(246,97,81)";
      network-indicators-order = "['icon','IO bar','IO graph','IO speed']";
      network-menu-arrow-color1 = "rgb(246,97,81)";
      processor-header-bars-color1 = "rgb(246,97,81)";
      processor-header-graph-color1 = "rgb(246,97,81)";
      processor-header-icon = false;
      processor-header-percentage = false;
      processor-header-percentage-core = false;
      processor-header-show = true;
      processor-indicators-order = "['icon','bar','graph','percentage']";
      processor-menu-gpu-color = "";
      profiles = "{'default':{'panel-margin-left':0,'sensors-header-tooltip-sensor2-digits':-1,'memory-update':3,'gpu-header-memory-graph-color1':'rgba(29,172,214,1.0)','panel-box':'right','memory-header-show':true,'network-header-tooltip-io':true,'processor-header-bars-color2':'rgba(214,29,29,1.0)','processor-header-icon-size':18,'storage-source-storage-io':'auto','sensors-header-tooltip-sensor4-name':'','storage-header-icon-color':'','network-source-public-ipv4':'https://api.ipify.org','storage-header-io-graph-color2':'rgba(214,29,29,1.0)','storage-header-io':false,'processor-menu-top-processes-percentage-core':true,'sensors-header-sensor1':'\\'\\'','processor-header-graph':true,'storage-header-graph-width':30,'network-header-bars':false,'processor-source-load-avg':'auto','network-menu-arrow-color1':'rgb(246,97,81)','storage-header-io-graph-color1':'rgb(246,97,81)','gpu-header-icon':true,'processor-menu-graph-breakdown':true,'sensors-header-icon-custom':'','sensors-header-sensor2':'\\'\\'','network-header-icon-alert-color':'rgba(235, 64, 52, 1)','memory-header-tooltip-free':false,'storage-header-io-figures':2,'network-menu-arrow-color2':'rgba(214,29,29,1.0)','sensors-header-tooltip-sensor3-name':'','network-source-public-ipv6':'https://api6.ipify.org','monitors-order':'[\\'processor\\',\\'gpu\\',\\'memory\\',\\'storage\\',\\'network\\',\\'sensors\\']','network-header-graph':true,'network-indicators-order':'[\\'icon\\',\\'IO bar\\',\\'IO graph\\',\\'IO speed\\']','memory-header-percentage':false,'processor-header-tooltip':true,'gpu-main':'\\'\\'','storage-header-bars':true,'sensors-header-tooltip-sensor5-digits':-1,'memory-menu-swap-color':'rgba(29,172,214,1.0)','storage-io-unit':'kB/s','memory-header-graph-width':30,'processor-header-graph-color1':'rgb(246,97,81)','storage-header-tooltip-value':false,'gpu-header-icon-custom':'','processor-header-graph-breakdown':true,'panel-margin-right':0,'gpu-header-icon-size':18,'processor-source-cpu-usage':'auto','sensors-header-tooltip-sensor3-digits':-1,'sensors-header-icon':false,'memory-header-value-figures':3,'processor-header-graph-color2':'rgba(214,29,29,1.0)','compact-mode':false,'panel-box-order':0,'compact-mode-compact-icon-custom':'','network-header-graph-width':30,'gpu-header-tooltip':true,'sensors-header-icon-alert-color':'rgba(235, 64, 52, 1)','gpu-header-activity-percentage-icon-alert-threshold':0,'sensors-header-sensor2-digits':-1,'sensors-header-tooltip-sensor2-name':'','sensors-update':3,'gpu-header-tooltip-memory-value':true,'processor-header-bars':false,'gpu-header-memory-bar-color1':'rgba(29,172,214,1.0)','gpu-header-tooltip-memory-percentage':true,'sensors-header-tooltip-sensor1':'\\'\\'','sensors-header-tooltip-sensor1-digits':-1,'storage-header-free-figures':2,'processor-header-percentage-core':false,'storage-main':'0x500a075127ef8a73-part6','network-source-network-io':'auto','memory-header-bars':true,'processor-header-percentage':false,'sensors-header-icon-color':'','storage-header-io-threshold':0,'memory-header-graph-color1':'rgb(237,51,59)','compact-mode-activation':'both','storage-header-icon-size':18,'sensors-header-tooltip-sensor1-name':'','sensors-header-icon-size':18,'sensors-source':'auto','explicit-zero':false,'storage-header-percentage-icon-alert-threshold':0,'storage-header-tooltip-io':false,'sensors-header-tooltip-sensor2':'\\'\\'','compact-mode-expanded-icon-custom':'','memory-header-graph-color2':'rgba(214,29,29,0.3)','processor-header-icon-alert-color':'rgba(235, 64, 52, 1)','processor-header-tooltip-percentage':true,'gpu-header-show':false,'network-update':1.5,'sensors-header-tooltip-sensor3':'\\'\\'','storage-header-free-icon-alert-threshold':0,'memory-header-icon-custom':'','sensors-header-tooltip-sensor4':'\\'\\'','storage-header-percentage':false,'sensors-temperature-unit':'celsius','storage-header-icon-alert-color':'rgba(235, 64, 52, 1)','storage-menu-arrow-color2':'rgba(214,29,29,1.0)','memory-source-top-processes':'auto','storage-header-value-figures':3,'storage-header-io-bars-color1':'rgb(246,97,81)','storage-menu-arrow-color1':'rgb(246,97,81)','processor-header-graph-width':30,'network-header-icon-custom':'','gpu-header-tooltip-activity-percentage':true,'network-header-icon':false,'sensors-header-sensor2-layout':'vertical','sensors-header-tooltip-sensor5':'\\'\\'','memory-header-bars-breakdown':true,'sensors-header-show':true,'sensors-header-tooltip':false,'storage-update':3,'processor-header-bars-core':false,'storage-indicators-order':'[\\'icon\\',\\'bar\\',\\'percentage\\',\\'value\\',\\'free\\',\\'IO bar\\',\\'IO graph\\',\\'IO speed\\']','processor-menu-bars-breakdown':true,'storage-header-io-bars-color2':'rgba(214,29,29,1.0)','network-io-unit':'kB/s','storage-header-icon':false,'gpu-header-activity-graph-color1':'rgba(29,172,214,1.0)','memory-unit':'kB-kiB','processor-menu-core-bars-breakdown':true,'sensors-header-sensor2-show':false,'network-header-tooltip':true,'storage-header-tooltip-free':true,'storage-header-bars-color1':'rgb(246,97,81)','theme-style':'dark','storage-source-storage-usage':'auto','network-header-io':false,'memory-header-tooltip-percentage':true,'memory-indicators-order':'[\\'icon\\',\\'bar\\',\\'graph\\',\\'percentage\\',\\'value\\',\\'free\\']','memory-source-memory-usage':'auto','memory-header-graph-breakdown':false,'memory-header-tooltip-value':true,'memory-menu-graph-breakdown':true,'sensors-indicators-order':'[\\'icon\\',\\'value\\']','compact-mode-start-expanded':false,'startup-delay':2,'memory-header-percentage-icon-alert-threshold':0,'sensors-header-sensor1-show':false,'network-ignored-regex':'','memory-header-value':false,'memory-header-bars-color1':'rgb(237,51,59)','network-header-io-graph-color1':'rgb(246,97,81)','gpu-header-memory-bar':true,'memory-used':'total-free-buffers-cached','gpu-header-memory-graph-width':30,'gpu-header-memory-graph':false,'headers-font-family':'','memory-header-icon':false,'network-header-io-graph-color2':'rgba(214,29,29,1.0)','memory-header-bars-color2':'rgba(214,29,29,0.3)','processor-gpu':true,'network-header-icon-color':'','storage-header-value':false,'gpu-header-icon-alert-color':'rgba(235, 64, 52, 1)','processor-header-icon':false,'headers-font-size':0,'network-header-io-figures':2,'network-header-show':true,'storage-header-tooltip':true,'network-header-io-bars-color1':'rgb(246,97,81)','processor-update':1.5,'network-source-wireless':'auto','processor-indicators-order':'[\\'icon\\',\\'bar\\',\\'graph\\',\\'percentage\\']','storage-header-icon-custom':'','gpu-header-activity-bar':true,'gpu-header-activity-bar-color1':'rgba(29,172,214,1.0)','shell-bar-position':'top','network-ignored':'\\'[]\\'','network-header-io-bars-color2':'rgba(214,29,29,1.0)','memory-header-icon-color':'','sensors-header-sensor1-digits':-1,'storage-header-io-layout':'vertical','memory-header-icon-size':18,'network-header-io-threshold':0,'storage-header-show':true,'sensors-header-tooltip-sensor4-digits':-1,'processor-header-percentage-icon-alert-threshold':0,'memory-header-tooltip':true,'headers-height-override':0,'memory-header-graph':false,'network-header-icon-size':17,'gpu-header-icon-color':'','memory-header-free-figures':3,'storage-header-io-bars':false,'processor-header-bars-breakdown':true,'gpu-header-activity-graph':false,'storage-ignored':'\\'[]\\'','memory-header-icon-alert-color':'rgba(235, 64, 52, 1)','storage-header-free':false,'processor-header-icon-custom':'','gpu-header-memory-percentage':false,'processor-header-tooltip-percentage-core':false,'processor-source-cpu-cores-usage':'auto','processor-source-top-processes':'auto','processor-header-icon-color':'','sensors-header-tooltip-sensor5-name':'','gpu-header-activity-graph-width':30,'gpu-header-activity-percentage':false,'gpu-indicators-order':'[\\'icon\\',\\'activity bar\\',\\'activity graph\\',\\'activity percentage\\',\\'memory bar\\',\\'memory graph\\',\\'memory percentage\\',\\'memory value\\']','processor-header-bars-color1':'rgb(246,97,81)','gpu-update':1.5,'gpu-header-memory-percentage-icon-alert-threshold':0,'network-header-io-layout':'vertical','processor-header-show':true,'storage-header-graph':false,'memory-header-free-icon-alert-threshold':0,'storage-ignored-regex':'','storage-menu-device-color':'rgb(224,27,36)','storage-header-tooltip-percentage':true,'memory-header-free':false,'storage-source-top-processes':'auto'}}";
      queued-pref-category = "";
      sensors-header-icon = false;
      sensors-header-sensor1-show = false;
      sensors-header-show = true;
      sensors-indicators-order = "['icon','value']";
      storage-header-bars-color1 = "rgb(246,97,81)";
      storage-header-free-figures = 2;
      storage-header-icon = false;
      storage-header-io-bars-color1 = "rgb(246,97,81)";
      storage-header-io-graph-color1 = "rgb(246,97,81)";
      storage-header-tooltip-io = false;
      storage-indicators-order = "['icon','bar','percentage','value','free','IO bar','IO graph','IO speed']";
      storage-main = "0x500a075127ef8a73-part6";
      storage-menu-arrow-color1 = "rgb(246,97,81)";
      storage-menu-device-color = "rgb(224,27,36)";
      # profiles = "{'default':{'panel-margin-left':0,'sensors-header-tooltip-sensor2-digits':-1,'memory-update':3,'gpu-header-memory-graph-color1':'rgba(29,172,214,1.0)','panel-box':'right','memory-header-show':true,'network-header-tooltip-io':true,'processor-header-bars-color2':'rgba(214,29,29,1.0)','processor-header-icon-size':18,'storage-source-storage-io':'auto','sensors-header-tooltip-sensor4-name':'','storage-header-icon-color':'','network-source-public-ipv4':'https://api.ipify.org','storage-header-io-graph-color2':'rgba(214,29,29,1.0)','storage-header-io':false,'processor-menu-top-processes-percentage-core':true,'sensors-header-sensor1':'\\'\\'','processor-header-graph':true,'storage-header-graph-width':30,'network-header-bars':false,'processor-source-load-avg':'auto','network-menu-arrow-color1':'rgb(246,97,81)','storage-header-io-graph-color1':'rgb(246,97,81)','gpu-header-icon':true,'processor-menu-graph-breakdown':true,'sensors-header-icon-custom':'','sensors-header-sensor2':'\\'\\'','network-header-icon-alert-color':'rgba(235, 64, 52, 1)','memory-header-tooltip-free':false,'storage-header-io-figures':2,'network-menu-arrow-color2':'rgba(214,29,29,1.0)','sensors-header-tooltip-sensor3-name':'','network-source-public-ipv6':'https://api6.ipify.org','monitors-order':'[\\'processor\\',\\'gpu\\',\\'memory\\',\\'storage\\',\\'network\\',\\'sensors\\']','network-header-graph':true,'network-indicators-order':'\\'\\'','memory-header-percentage':false,'processor-header-tooltip':true,'gpu-main':'\\'\\'','storage-header-bars':true,'sensors-header-tooltip-sensor5-digits':-1,'memory-menu-swap-color':'rgba(29,172,214,1.0)','storage-io-unit':'kB/s','memory-header-graph-width':30,'processor-header-graph-color1':'rgb(246,97,81)','storage-header-tooltip-value':false,'gpu-header-icon-custom':'','processor-header-graph-breakdown':true,'panel-margin-right':0,'gpu-header-icon-size':18,'processor-source-cpu-usage':'auto','sensors-header-tooltip-sensor3-digits':-1,'sensors-header-icon':false,'memory-header-value-figures':3,'processor-header-graph-color2':'rgba(214,29,29,1.0)','compact-mode':false,'panel-box-order':0,'compact-mode-compact-icon-custom':'','network-header-graph-width':30,'gpu-header-tooltip':true,'sensors-header-icon-alert-color':'rgba(235, 64, 52, 1)','gpu-header-activity-percentage-icon-alert-threshold':0,'sensors-header-sensor2-digits':-1,'sensors-header-tooltip-sensor2-name':'','sensors-update':3,'gpu-header-tooltip-memory-value':true,'processor-header-bars':false,'gpu-header-memory-bar-color1':'rgba(29,172,214,1.0)','gpu-header-tooltip-memory-percentage':true,'sensors-header-tooltip-sensor1':'\\'\\'','sensors-header-tooltip-sensor1-digits':-1,'storage-header-free-figures':2,'processor-header-percentage-core':false,'storage-main':'[default]','network-source-network-io':'auto','memory-header-bars':true,'processor-header-percentage':false,'sensors-header-icon-color':'','storage-header-io-threshold':0,'memory-header-graph-color1':'rgb(237,51,59)','compact-mode-activation':'both','storage-header-icon-size':18,'sensors-header-tooltip-sensor1-name':'','sensors-header-icon-size':18,'sensors-source':'auto','explicit-zero':false,'storage-header-percentage-icon-alert-threshold':0,'storage-header-tooltip-io':false,'sensors-header-tooltip-sensor2':'\\'\\'','compact-mode-expanded-icon-custom':'','memory-header-graph-color2':'rgba(214,29,29,0.3)','processor-header-icon-alert-color':'rgba(235, 64, 52, 1)','processor-header-tooltip-percentage':true,'gpu-header-show':false,'network-update':1.5,'sensors-header-tooltip-sensor3':'\\'\\'','storage-header-free-icon-alert-threshold':0,'memory-header-icon-custom':'','sensors-header-tooltip-sensor4':'\\'\\'','storage-header-percentage':false,'sensors-temperature-unit':'celsius','storage-header-icon-alert-color':'rgba(235, 64, 52, 1)','storage-menu-arrow-color2':'rgba(214,29,29,1.0)','memory-source-top-processes':'auto','storage-header-value-figures':3,'storage-header-io-bars-color1':'rgb(246,97,81)','storage-menu-arrow-color1':'rgb(246,97,81)','processor-header-graph-width':30,'network-header-icon-custom':'','gpu-header-tooltip-activity-percentage':true,'network-header-icon':false,'sensors-header-sensor2-layout':'vertical','sensors-header-tooltip-sensor5':'\\'\\'','memory-header-bars-breakdown':true,'sensors-header-show':true,'sensors-header-tooltip':false,'storage-update':3,'processor-header-bars-core':false,'storage-indicators-order':'\\'\\'','processor-menu-bars-breakdown':true,'storage-header-io-bars-color2':'rgba(214,29,29,1.0)','network-io-unit':'kB/s','storage-header-icon':false,'gpu-header-activity-graph-color1':'rgba(29,172,214,1.0)','memory-unit':'kB-kiB','processor-menu-core-bars-breakdown':true,'sensors-header-sensor2-show':false,'network-header-tooltip':true,'storage-header-tooltip-free':true,'storage-header-bars-color1':'rgb(246,97,81)','theme-style':'dark','storage-source-storage-usage':'auto','network-header-io':false,'memory-header-tooltip-percentage':true,'memory-indicators-order':'\\'\\'','memory-source-memory-usage':'auto','memory-header-graph-breakdown':false,'memory-header-tooltip-value':true,'memory-menu-graph-breakdown':true,'sensors-indicators-order':'\\'\\'','compact-mode-start-expanded':false,'startup-delay':2,'memory-header-percentage-icon-alert-threshold':0,'sensors-header-sensor1-show':false,'network-ignored-regex':'','memory-header-value':false,'memory-header-bars-color1':'rgb(237,51,59)','network-header-io-graph-color1':'rgb(246,97,81)','gpu-header-memory-bar':true,'memory-used':'total-free-buffers-cached','gpu-header-memory-graph-width':30,'gpu-header-memory-graph':false,'headers-font-family':'','memory-header-icon':false,'network-header-io-graph-color2':'rgba(214,29,29,1.0)','memory-header-bars-color2':'rgba(214,29,29,0.3)','processor-gpu':true,'network-header-icon-color':'','storage-header-value':false,'gpu-header-icon-alert-color':'rgba(235, 64, 52, 1)','processor-header-icon':false,'headers-font-size':0,'network-header-io-figures':2,'network-header-show':true,'storage-header-tooltip':true,'network-header-io-bars-color1':'rgb(246,97,81)','processor-update':1.5,'network-source-wireless':'auto','processor-indicators-order':'\\'\\'','storage-header-icon-custom':'','gpu-header-activity-bar':true,'gpu-header-activity-bar-color1':'rgba(29,172,214,1.0)','shell-bar-position':'top','network-ignored':'\\'[]\\'','network-header-io-bars-color2':'rgba(214,29,29,1.0)','memory-header-icon-color':'','sensors-header-sensor1-digits':-1,'storage-header-io-layout':'vertical','memory-header-icon-size':18,'network-header-io-threshold':0,'storage-header-show':true,'sensors-header-tooltip-sensor4-digits':-1,'processor-header-percentage-icon-alert-threshold':0,'memory-header-tooltip':true,'headers-height-override':0,'memory-header-graph':false,'network-header-icon-size':17,'gpu-header-icon-color':'','memory-header-free-figures':3,'storage-header-io-bars':false,'processor-header-bars-breakdown':true,'gpu-header-activity-graph':false,'storage-ignored':'\\'[]\\'','memory-header-icon-alert-color':'rgba(235, 64, 52, 1)','storage-header-free':false,'processor-header-icon-custom':'','gpu-header-memory-percentage':false,'processor-header-tooltip-percentage-core':false,'processor-source-cpu-cores-usage':'auto','processor-source-top-processes':'auto','processor-header-icon-color':'','sensors-header-tooltip-sensor5-name':'','gpu-header-activity-graph-width':30,'gpu-header-activity-percentage':false,'gpu-indicators-order':'\\'\\'','processor-header-bars-color1':'rgb(246,97,81)','gpu-update':1.5,'gpu-header-memory-percentage-icon-alert-threshold':0,'network-header-io-layout':'vertical','processor-header-show':true,'storage-header-graph':false,'memory-header-free-icon-alert-threshold':0,'storage-ignored-regex':'','storage-menu-device-color':'rgb(224,27,36)','storage-header-tooltip-percentage':true,'memory-header-free':false,'storage-source-top-processes':'auto'}}";
    };
  };
}
