{ pkgs,lib, ...}:
let 
playerctl = "${pkgs.playerctl}/bin/playerctl -p mpv";
terminal = "foot";
var = import ./variables.nix;
inherit (lib) mkEnableOption mkIf mkMerge mapAttrsToList;
in
{
  wayland.windowManager.hyprland = {
    enable = true;
    settings = let
    #stolen from fufexan
      screenarea = ''grim -g "$(slurp)" "$HOME/MediaHub/screenshots/Screenshot-area_$(date +%y-%m-%d_%H%M-%S).png"'';
      screenfull = ''grim "$HOME/MediaHub/Screenshot-full_$(date +%y-%m-%d_%H%M-%S).png"'';

      recordarea = ''wf-recorder -g "$(slurp)" -x yuv420p -c libx264 -f "$HOME/MediaHub/recordings/Screenrecording-area_$(date +%y-%m-%d_%H%M-%S).mp4"'';
      recordfull = ''wf-recorder -x yuv420p -c libx264 -f "$HOME/MediaHub/recordings/Screenrecording-full_$(date +%y-%m-%d_%H%M-%S).mp4"'';
    in 
    { env = mapAttrsToList (name: value: "${name},${toString value}") {
        XDG_CURRENT_DESKTOP = "Hyprland";
        XDG_SESSION_DESKTOP = "Hyprland";

        HYPRLAND_NO_SD_NOTIFY = 1;
        
        HYPRCURSOR_THEME = "Future-Cyan-Hyprcursor_Theme";
        HYPRCURSOR_SIZE = 32;
        XCURSOR_SIZE = 16;
      };

      exec-once = [
        "yambar"
        "fnott"
        "udiskie"
      ];

      general = {
        gaps_in = 0;
        gaps_out = 0;
        border_size = 1;

        allow_tearing = false;
        "col.active_border" = "rgba(ff4500ee) rgba(ff6347ee) 135deg";
        "col.inactive_border" = "rgba(595959aa)";
        "snap:enabled" = 1;
      };

      binds = {
        allow_pin_fullscreen = 1;
      };

      decoration = {
        blur = {
          enabled = false;
        };
      };

      dwindle = {
        special_scale_factor = 0.5;
        force_split = 2;
        default_split_ratio = 1;
      };

      input = {
        follow_mouse = 1;
        kb_layout = "es";
        mouse_refocus = false;
      };

      misc = {
        enable_swallow = true; # hide windows that spawn other windows
        disable_splash_rendering = true;
        disable_hyprland_logo = true;
      };

      animations = {
        enabled = true;
        bezier = "myBezier, 0.05, 0.9, 0.1, 1.05";
        animation = [
              "windows, 1, 3, myBezier"
              "windowsOut, 1, 6, default, popin 80%"
              "border, 1, 6, default"
              "fade, 1, 3, default"
              "workspaces, 1, 2, default"
        ];
      };

      group = {
          "col.border_active" = "rgba(fe8019ee) rgba(fabd2fee) 135deg";
          groupbar = {
              font_family="JetBrainsMono Nerd Font Mono";
              font_size=13;
              "col.active"="0xdd401000";
              "col.inactive"="0xcc303030";
              text_color="0xffffffff";
          };
      };

      "$mod" = "SUPER";
      "$smod" = "SHIFT+$mod";
      "$amod" = "ALT+$mod";
      "$cmod" = "CONTROL+$mod";
      "$scmod" = "CONTROL+SHIFT+$mod";

      bind = [
        "$mod, 1 , workspace, 1"
        "$mod, 2, workspace, 2"
        "$mod, 3, workspace,  3"
        "$mod, 4, workspace,  4"
        "$mod, F1, workspace,  5"
        "$mod, F2, workspace,  6"
        "$mod, F3, workspace,  7"
        "$mod, F4, workspace,  8"
        "$mod, Z, workspace,  9"

        # move window to another workspace
        "$smod, 1, movetoworkspace, 1"
        "$smod, 2, movetoworkspace, 2"
        "$smod, 3, movetoworkspace, 3"
        "$smod, 4, movetoworkspace, 4"
        "$smod, F1, movetoworkspace, 5"
        "$smod, F2, movetoworkspace, 6"
        "$smod, F3, movetoworkspace, 7"
        "$smod, F4, movetoworkspace, 8"
        "$smod, Z, movetoworkspace, 9"

        # change workspace with scroll
        "$mod, mouse_down, workspace, e-1"
        "$mod, mouse_up, workspace, e+1"

        #Programs related
        "$mod, R, exec, fuzzel"

        #screenshot
        ", Print, exec, ${screenarea}"
        "CTRL, Print, exec, ${screenfull}"
        "$mod, Print, exec, ${recordarea}"
        "$smod, Print, exec, ${recordfull}"
        "$scmod, Print, exec, pkill wf-recorder"

        #windows managment related
        "$mod, f, fullscreen"
        "$mod, Space, togglefloating"

        "$mod, q, exec, ${terminal}"
        "$smod, c, killactive"

        # Media control
        "MOD5, P, exec, mpc toggle"
        "MOD5, left, exec, mpc prev"
        "MOD5, right, exec, mpc next"
        "$mod, left, exec, ${playerctl} position 10-"
        "$mod, right, exec, ${playerctl} position 10+"

        #change focus keys
        "$mod, h, movefocus, l"
        "$mod, l, movefocus, r"
        "$mod, k, movefocus, u"
        "$mod, j, movefocus, d"

        "$smod, h, movewindow, l"
        "$smod, l, movewindow, r"
        "$smod, k, movewindow, u"
        "$smod, j, movewindow, d"

        "$mod, F12, exec, pkill -15 '(qutebrowser|zathura)'; hyprctl notify 0 5000 'rgb(ff0088)' '   Shutting down'; pw-cat -p /usr/share/sounds/freedesktop/stereo/service-logout.oga; sleep 3; shutdown now"

# Toggle windowgroup / toggle window group lock
        "$mod, U, moveoutofgroup"
        "$mod SHIFT, Y, lockactivegroup, toggle"
        "$mod, TAB, changegroupactive, f"
        "$mod SHIFT, TAB, changegroupactive, b"
        "$mod, masculine, togglegroup"
        
# nds
        ",KP_End,exec,toggleFS 1"
        ",KP_Down,exec,toggleFS 2"
        ",KP_Next,exec,toggleFS 3"
        ",KP_Left,exec,toggleFS 4"

        "SHIFT,KP_End,exec,togglePAUSE 1"
        "SHIFT,KP_Down,exec,togglePAUSE 2"
        "SHIFT,KP_Next,exec,togglePAUSE 3"
        "SHIFT,KP_Left,exec,togglePAUSE 4"

        "CTRL,KP_End,exec,closeMpvWindow 1"
        "CTRL,KP_Down,exec,closeMpvWindow 2"
        "CTRL,KP_Next,exec,closeMpvWindow 3"
        "CTRL,KP_Left,exec,closeMpvWindow 4"  

        "$mod, A, togglespecialworkspace, fastanime"
        "$mod SHIFT, KP_End, togglespecialworkspace, trans"
        "$mod, KP_End, togglespecialworkspace, transI"
        "$mod, KP_Down, togglespecialworkspace, neomutt"
        "$mod, KP_Next, togglespecialworkspace, newsraft"
        "$mod, KP_Left, togglespecialworkspace, kalker"
        "$mod, KP_Begin, togglespecialworkspace, androidsync"
        "$mod, O, togglespecialworkspace, openfile"
        "$mod, W, togglespecialworkspace, whatsapp"
        "$mod, R, exec, fuzzel"
      ];

#  notifications
      binde = [
        "MOD5, up, exec, $HOME/nix/scripts/volume_notif up"
        "MOD5, down, exec, $HOME/nix/scripts/volume_notif down"
        "MOD5, delete, exec, $HOME/nix/scripts/volume_notif mute"
        "$mod, delete, exec, $HOME/nix/scripts/volume_notif mic"
      ];
      bindm =[
        "$mod, mouse:272, movewindow"  
        "$mod, mouse:273, resizewindow"  
      ];

      workspace = [
        "special:fastanime, on-created-empty: ${terminal} --app-id=fastanime fakehome \"fastanime anilist\""
        "special:trans, on-created-empty: ${terminal} --app-id=trans trans -b -I :es"
        "special:transI, on-created-empty: ${terminal} --app-id=transI trans -b -I :@es"
        "special:neomutt, on-created-empty: ${terminal} --app-id=neomutt neomutt"
        "special:newsraft, on-created-empty: ${terminal} --app-id=newsraftsilent newsraft"
        "special:kalker, on-created-empty: ${terminal} --app-id=kalker kalker"
        "special:androidsync, on-created-empty: ${terminal} --app-id=androidsync $HOME/nix/scripts/androidsync"
        "special:openfile, on-created-empty: ${terminal} --app-id=openfile open_file"
      ];

      windowrulev2 = [
        "float, class:^(floating|mpv)$"
        "float,class:(^(org-geogebra-desktop)),title:(Algebra)"
        "float,class:(^(org-geogebra-desktop)),title:(^(win))"
        "tile,title:(^(GeoGebra Classic))"
        "workspace 1,class:(org.qutebrowser.qutebrowser|firefox)"
        "workspace 2,class:(${terminal}|org.pwmt.zathura)"
        "workspace 3,class:(libreoffice)"
        "workspace 4,class:(^(org-geogebra-desktop))"
        "workspace 5,class:(^(puddletag)$)"
        "workspace 5,class:(^(WebCord)$)"
        "suppressevent maximize,class:^(libreoffice.*)$"
        "group,class:(org.qutebrowser.qutebrowser)"
# 
        "pin, class:(^(mpv))"
        "noanim, class:(^(mpv))"
        "nofocus, class:(^(mpv))"
#        "noborder, class:(^(mpv))"
        "rounding ${var.rounding}, class:(^(mpv))"
        "opacity 1 ${var.high}, class:(^(mpv))"
        "opacity 1 1 0.97, class:(^(${terminal}))"
        "opacity 1 1, class:(^(org.pwmt.zathura))"
        "size ${var.width} ${var.height}, class:(^(mpv))"
      ];
    };
  };
}
