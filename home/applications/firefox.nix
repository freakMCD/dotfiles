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

          menupopup {
            --panel-background: #${config.colors.bg1} !important;
            --panel-color: #${config.colors.gray} !important;
          }

          panelview {
            color: #${config.colors.yellow} !important;
            background: #${config.colors.bg0} !important;
          }
        '';

        settings = {
            "browser.newtabpage.enabled" = false;
            "widget.use-xdg-desktop-portal.file-picker" = 2;
            "toolkit.legacyUserProfileCustomizations.stylesheets" = true;
            "browser.translations.automaticallyPopup" = false;
            "browser.cache.disk.enable" = false; # Be kind to hard drive
            "browser.sessionstore.interval" = 1800000;
            "browser.fullscreen.autohide" = false;
            "browser.uidensity" = 1;
            "ui.key.menuAccessKeyFocuses" = false;
            "browser.bookmarks.file" = ../../dotfiles/firefox/bookmarks/bookmarks.html;
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
            "media.videocontrols.picture-in-picture.video-toggle.enable" = false;
            # Disable "beacon" asynchronous HTTP transfers (used for analytics)
            "beacon.enabled" = true;
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
