{config, ...}:
{
  services = {
    mpd = {
      enable = true;
      musicDirectory = "~/Music/";
      network.startWhenNeeded = true;
      extraConfig = ''
        auto_update "yes"
        zeroconf_enabled "no"
        audio_output {
          type "pulse"
          name "My Pulse Output"
        }
      '';
    };

    mpd-mpris.enable = true;

    fnott = {
      enable = true;
      settings = {
          main = {
              # Layout and sizing
              max-width = 380;
              max-height = 600;
              default-timeout = 8;
              idle-timeout = 240;
              layer = "overlay";
              padding-vertical = 20;
              padding-horizontal = 20;
              edge-margin-vertical = 30;
              edge-margin-horizontal = 10;
              dpi-aware="yes";

              # Fonts
              summary-font = "JetBrainsMono Nerd Font:weight=bold:size=13";
              body-font = "JetBrainsMono Nerd Font:size=12";
              title-font = "JetBrainsMono Nerd Font:size=14";

              # Colors
              background = "${config.colors.bg1}ee";
              summary-color = "${config.colors.yellow}ff";
              body-color = "${config.colors.white}dd";
              border-color = "${config.colors.bg3}66";
              border-size = 2;
              border-radius = 6;

              # Progress bar customization
              progress-bar-color = "${config.colors.yellow}cc";
              progress-bar-height = 8;

              # Text formatting
              title-format = "";  # No title formatting
              summary-format = "<b><i>%s</i></b>";  # Summary text
              body-format = "%b";  # Underlined action indicator
          };

          # Urgency-specific overrides
          low = {
            background = "${config.colors.bg2}ee";
            title-color = "${config.colors.gray}ff";
            summary-color = "${config.colors.gray}ff";
            body-color = "${config.colors.gray}dd";
            progress-bar-color = "${config.colors.gray}66";
          };

          critical = {
            background = "${config.colors.red}22";  # Subtle red overlay
            border-color = "${config.colors.red}ff";
            title-color = "${config.colors.red}ff";
            summary-color = "${config.colors.yellow}ff";
            border-size = 2;
            progress-bar-color = "${config.colors.red}ff";
          };
        };
      };
  };
}
