{config, ...}:
{
  services = {
    fnott = {
      enable = true;
      settings = {
          main = {
              # Layout
              border-radius = 6;
              max-width = 320;
              padding-vertical = 8;
              padding-horizontal = 12;
              default-timeout = 15;

              # Fonts
              summary-font = "JetBrainsMono Nerd Font:weight=bold:size=13";
              body-font = "JetBrainsMono Nerd Font:size=12";

              # Colors
              background = "${config.colors.bg0}ee";
              border-color = "${config.colors.gray}aa";
              summary-color = "${config.colors.white}ff";
              body-color = "${config.colors.white}dd";

              # Progress bar customization
              progress-color = "${config.colors.gray}cc";
              progress-bar-height = 6;

              # Text formatting
              title-format = "";
              summary-format = "<b>%s</b>";
          };

          # Urgency-specific overrides
          low = {
            background = "${config.colors.bg0}cc";
            summary-color = "${config.colors.b_cyan}ff";
            border-size = 0;
          };

          critical = {
            background = "${config.colors.red}22";
            border-color = "${config.colors.red}ff";
            summary-color = "${config.colors.yellow}ff";
            border-size = 2;
            progress-color = "${config.colors.red}ff";
          };
        };
      };
  };
}
