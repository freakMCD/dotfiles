{ config, ...}:
{
    programs.firefox = {
      enable = true;
      profiles.default = {
        id=0;
        name = "edwin";
        isDefault = true;
        userChrome = ''
          #TabsToolbar {
            visibility: collapse;
          }

          #nav-bar, .urlbar-background, #sidebar-box, findbar {
            background: #${config.colors.bg0} !important;
          }

          .urlbar-background {
            outline: none !important;
          }

          #nav-bar {
            position: relative !important;
            z-index: 1 !important;
            margin-top: -40px !important; /* Adjust to match nav-bar height */
            opacity: 0 !important;
            transition: opacity 0.2s, margin-top 0.2s !important;
          }

          #nav-bar:hover,
          #nav-bar:focus-within {
            margin-top: 0 !important;
            opacity: 1 !important;
          }

          menupopup {
            --panel-background: #${config.colors.bg1} !important;
            --panel-color: #${config.colors.gray} !important;
            --panel-border-color: #${config.colors.bg3} !important;
          }

          panelview {
            color: #${config.colors.yellow} !important;
            background: #${config.colors.bg0} !important;
          }
        '';

        settings = {
            "toolkit.legacyUserProfileCustomizations.stylesheets" = true;

            "browser.newtabpage.enabled" = false;
            "browser.startup.homepage" = "about:blank";

            "widget.use-xdg-desktop-portal.file-picker" = 2;
            "browser.translations.automaticallyPopup" = false;
            "browser.cache.disk.enable" = false; # Be kind to hard drive
            "browser.sessionstore.interval" = 1800000;
            "browser.fullscreen.autohide" = false;
            "browser.uidensity" = 1;
            "browser.bookmarks.file" = ../../dotfiles/firefox/bookmarks/bookmarks.html;
            "browser.search.openintab" = true;
            "browser.places.importBookmarksTML" = true;

            "browser.urlbar.suggest.searches" = false;
            "browser.urlbar.shortcuts.bookmarks" = false;
            "browser.urlbar.shortcuts.history" = false;
            "browser.urlbar.shortcuts.tabs" = false;
            "browser.urlbar.showSearchSuggestionsFirst" = false;
            "browser.urlbar.speculativeConnect.enabled" = false;

            "extensions.htmlaboutaddons.recommendations.enabled" = false;
            "extensions.htmlaboutaddons.discover.enabled" = false;
            "extensions.getAddons.showPane" = false;
            "media.videocontrols.picture-in-picture.video-toggle.enabled" = false;
            "widget.non-native-theme.enabled" = false;

            "browser.newtabpage.activity-stream.feeds.telemetry" = false;
            "browser.newtabpage.activity-stream.telemetry" = false;
            "browser.ping-centre.telemetry" = false;
            "toolkit.telemetry.archive.enabled" = false;
            "toolkit.telemetry.bhrPing.enabled" = false;
            "toolkit.telemetry.enabled" = false;
            "toolkit.telemetry.firstShutdownPing.enabled" = false;
            "toolkit.telemetry.hybridContent.enabled" = false;
            "toolkit.telemetry.newProfilePing.enabled" = false;
            "toolkit.telemetry.reportingpolicy.firstRun" = false;
            "toolkit.telemetry.shutdownPingSender.enabled" = false;
            "toolkit.telemetry.unified" = false;
            "toolkit.telemetry.updatePing.enabled" = false;
            "experiments.activeExperiment" = false;
            "experiments.enabled" = false;
            "experiments.supported" = false;
            "network.allow-experiments" = false;
            "ui.key.menuAccessKeyFocuses" = false;
            "ui.key.menuAccessKey" = 17;
           };

        search = {
          force = true;
          default = "google";
          engines = {
            "Nixpkgs" = {
              urls = [ { template = "https://search.nixos.org/packages?&query={searchTerms}"; } ];
              definedAliases = [ "@np" ];
            };          

            "GitHub Code" = {
              urls = [ { template = "https://github.com/search?q={searchTerms}&type=code"; } ];
              definedAliases = [ "@gh" ];
            };
            "Searchix" = {
              urls = [{template = "https://searchix.ovh/?query={searchTerms}"; }];
              definedAliases = ["@sn"];
            };
          };
        };


      };
    };
}
