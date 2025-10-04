{ pkgs, ...}:
let 
term= "foot";
in
{
  wayland.windowManager.hyprland = {  enable = true;
    settings = {     
      env = [
        "XDG_CURRENT_DESKTOP,Hyprland"
        "XDG_SESSION_DESKTOP,Hyprland"
        "HYPRLAND_NO_SD_NOTIFY,1"
        "HYPRCURSOR_THEME,Future-Cyan-Hyprcursor_Theme"
        "HYPRCURSOR_SIZE,32"
        "XCURSOR_SIZE,16"
      ];

      exec-once = [
        "fnott"
        "udiskie"
        "yambar"
        "hypridle"
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

      xwayland.enabled = true;
      decoration.blur.enabled = false;
      animations.enabled = false;
      binds.allow_pin_fullscreen = 1;

      dwindle = {
        special_scale_factor = 0.9;
        force_split = 2;
        default_split_ratio = 1;
      };

      input = {
        follow_mouse = 1;
        kb_layout = "us";
        kb_variant= "altgr-intl";
        mouse_refocus = false;
        sensitivity = 0.3;
      };

      misc = {
        enable_swallow = true; # hide windows that spawn other windows
        disable_splash_rendering = true;
        disable_hyprland_logo = true;
        enable_anr_dialog = false;
      };

      
      group = {
          "col.border_active" = "rgba(fe8019ee) rgba(fabd2fee) 135deg";
        groupbar = {
          # Colors
          text_color = "0xffebdbb2";         # Gruvbox foreground (off-white)

          # Aesthetic tweaks
          gradients = true;
          font_family = "JetBrains Mono";
          font_size = 9;
          height = 16;
          indicator_height = 2;
          
          # Rounding parameters
          rounding = 2;
          gradient_rounding = 3;
          round_only_edges = true;
          gradient_round_only_edges = true;

          # Layout
          stacked = false;
          
          # Functional settings
          enabled = true;
          render_titles = true;
          scrolling = true;
          priority = 2;
        };
      };

      "$mod" = "SUPER";
      "$smod" = "SHIFT+$mod";
      "$amod" = "ALT+$mod";
      "$cmod" = "CONTROL+$mod";
      "$scmod" = "CONTROL+SHIFT+$mod";

      bind = [
# Weather
        ''$mod, semicolon, exec, notify-send -h "string:x-canonical-private-synchronous:weather" "Weather Update" "$(curl -s wttr.in?format=3)"''

# Workspaces
        "$mod, 1,  workspace, 1"
        "$mod, 2,  workspace, 2"
        "$mod, 3,  workspace, 3"
        "$mod, 4,  workspace, 4"
        "$mod, F1, workspace, 5"
        "$mod, F2, workspace, 6"
        "$mod, F3, workspace, 7"
        "$mod, F4, workspace, 8"
        "$mod, Z,  workspace, 9"

        "$smod, 1, movetoworkspace, 1"
        "$smod, 2, movetoworkspace, 2"
        "$smod, 3, movetoworkspace, 3"
        "$smod, 4, movetoworkspace, 4"
        "$smod, F1, movetoworkspace, 5"
        "$smod, F2, movetoworkspace, 6"
        "$smod, F3, movetoworkspace, 7"
        "$smod, F4, movetoworkspace, 8"
        "$smod, Z, movetoworkspace, 9"

# Change ws with keys
        "$mod, h, movefocus, l"
        "$mod, l, movefocus, r"
        "$mod, k, movefocus, u"
        "$mod, j, movefocus, d"

        "$smod, h, movewindow, l"
        "$smod, l, movewindow, r"
        "$smod, k, movewindow, u"
        "$smod, j, movewindow, d"
# Change ws with scroll
        "$mod, mouse_down, workspace, e-1"
        "$mod, mouse_up, workspace, e+1"

# Screenshot 
        ", Print, exec, hyprshot -m output"
        "SHIFT, Print, exec, hyprshot -m window"
        "$mod, Print, exec, hyprshot -z -m region"
        "MOD5, Print, exec, $HOME/nix/scripts/record.sh" # Recording
        "$scmod, F12, exec, hyprctl notify 0 30000 'rgb(ff0088)' '   Shutting down in 30s'; systemctl poweroff --when=+30" # Shutdown

# Windows
        "$mod, f, fullscreen"
        "$mod, Space, togglefloating"
        "$smod, c, killactive"
# Groups
        "$mod, U, moveoutofgroup"
        "$smod, Y, lockactivegroup, toggle"
        "$mod, TAB, changegroupactive, f"
        "$smod, TAB, changegroupactive, b"
        "$mod, grave, togglegroup"
        
# programs
        "$mod, C, togglespecialworkspace, kalker"
        "$mod, M, togglespecialworkspace, neomutt"
        "$mod, N, togglespecialworkspace, newsraft"
        "$mod, O, togglespecialworkspace, openfile"
        "$mod, q, togglespecialworkspace, ${term}"
        "$smod, q, exec, ${term}"
        "$mod, R, exec, fuzzel"
      ];

#  notifications
      binde = [
        "MOD5, Up, exec, $HOME/nix/scripts/volume-notif up"
        "MOD5, Down, exec, $HOME/nix/scripts/volume-notif down"
        "MOD5, Delete, exec, $HOME/nix/scripts/volume-notif mute"
        "$mod, Delete, exec, $HOME/nix/scripts/volume-notif mute-mic"
      ];

      bindm =[
        "$mod, mouse:272, movewindow"  
        "$mod, mouse:273, resizewindow"  
      ];

      workspace = [
        "special:neomutt, on-created-empty: ${term} --app-id=neomutt neomutt"
        "special:newsraft, on-created-empty: ${term} --app-id=newsraftsilent newsraft"
        "special:kalker, on-created-empty: ${term} --app-id=kalker kalker"
        "special:openfile, on-created-empty: ${term} --app-id=openfile open_file"
        "special:${term}, on-created-empty: ${term} --app-id=${term}"

      ];

      windowrule = [
        "float,class:(^(org-geogebra-desktop)),title:(Algebra)"
        "float,class:(^(org-geogebra-desktop)),title:(^(win))"
        "tile,title:(^(GeoGebra Classic))"

        "workspace 1,class:(org.qutebrowser.qutebrowser|firefox)"
        "workspace 2,class:(org.pwmt.zathura)"
        "workspace 3,class:(libreoffice)"
        "workspace 4,class:(^(org-geogebra-desktop))"

        "workspace 5,class:(.qemu-system-x86_64-wrapped)"

        "suppressevent maximize,class:^(libreoffice.*)$"
 
        "opacity 1 1 0.97, class:(^(${term}))"
      ];
    };
  };
}
