{ config, pkgs, lib, ...}:
let
  lockedPrefs = prefs:
    builtins.mapAttrs (_: value: {
      Value = value;
      Status = "locked";
    }) prefs;
in
{
    programs.firefox = {
      enable = true;
      policies = {
          ExtensionSettings = {
            "uBlock0@raymondhill.net" = {
              default_area = "menupanel";
              install_url =
                "https://addons.mozilla.org/en-US/firefox/downloads/latest/ublock-origin/latest.xpi";
              installation_mode = "force_installed";
            };
          };
          BlockAboutAddons = true;
          BlockAboutConfig = true;
          DisableFirefoxAccounts = true;
          DisableFirefoxStudies = true;
          DisableTelemetry = true;
          DontCheckDefaultBrowser = true;
          GenerativeAI.Enabled = false;
          Homepage = { StartPage = "previous-session"; };
          NewTabPage = false;
          OfferToSaveLogins = false;
          PasswordManagerEnabled = false;
          PictureInPicture = false;
          SearchSuggestEnabled = false;
          StartDownloadsInTempDirectory = true;

          WebsiteFilter = import ./.policy.nix;

          Preferences = lockedPrefs {
            "accessibility.browsewithcaret_shortcut.enabled" = false;
            "browser.aboutConfig.showWarning" = false;
            "browser.cache.disk.enable" = false;
            "browser.sessionstore.resume_from_crash" = false;
            "browser.tabs.groups.enabled" = false;
            "browser.urlbar.suggest.engines" = false;
            "browser.urlbar.suggest.history" = false;
            "browser.uidensity" = 1;
            "general.smoothScroll" = false;
            "media.autoplay.default" = 5;
            "network.trr.mode" = 5;
            "toolkit.legacyUserProfileCustomizations.stylesheets" = true;
            "ui.key.menuAccessKeyFocuses" = false;
            "widget.use-xdg-desktop-portal.file-picker" = 2;
          };
      };

      profiles.default = {
        id=0;
        name = "edwin";
        isDefault = true;
        userChrome = ''
          /* Nav bar */
          #nav-bar, .urlbar-background, #sidebar-box, findbar, #navigator-toolbox { background: #${config.colors.bg0} !important; }

          #nav-bar {
            margin-left: 80vw !important;
            margin-top: -36px !important;
            margin-bottom: -5px !important;
          }

          #navigator-toolbox { border: 0px !important; }

          #TabsToolbar {
            margin-right: 20vw !important;
            min-height: 32px !important;
            max-height: 32px !important;
          }

          .tabbrowser-tab {
            padding-inline: 1px !important;
            margin-inline: -1px !important;
          }
          .tab-content { padding-inline: 4px !important; }
          .tab-background { border-radius: 0px !important; }

          /* Hide buttons of Tabbar and urlbar */
          .searchmode-switcher, #reload-button, #tabs-newtab-button, .titlebar-buttonbox, .titlebar-spacer, .tabbrowser-tab .tab-close-button, #alltabs-button, #urlbar-zoom-button, #reader-mode-button, #trust-icon-container, #permissions-granted-icon, #translations-button-icon, #urlbar-searchmode-switcher, #back-button, #forward-button, #PanelUI-button, #tracking-protection-icon-container, #stop-button, .identity-box-button { display: none !important; }

          #star-button-box,
          .unified-extensions-item-row-wrapper {
              padding: 0 !important;
              margin: 0 !important;
              width: 14px !important;
              align-items: center !important;
          }

          /* URL bar */
          #urlbar-container { width: auto !important; }

          #urlbar-input {
              font-size: 0.85em !important;
          }

          #urlbar {
            position: relative !important;
            top: unset !important;
            margin-block: auto !important;
          }
          #urlbar[breakout-extend] {
            position: absolute !important;
            inset-inline: 20vw !important;
            width: unset !important;
            align-self: flex-start !important;
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

        search = {
          force = true;
          default = "ddg";
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
      extensions = {
        force = true;
        settings = {
          "uBlock0@raymondhill.net".settings =
            let
              importedLists = [
                "https://raw.githubusercontent.com/DandelionSprout/adfilt/refs/heads/master/LegitimateURLShortener.txt"
                "https://raw.githubusercontent.com/laylavish/uBlockOrigin-HUGE-AI-Blocklist/main/list.txt"
              ];
            in
            {
              advancedUserEnabled = true;
              cloudStorageEnabled = false;
              importedLists = importedLists;
              externalLists = lib.concatStringsSep "\n" importedLists;
              selectedFilterLists = [
                ## ----- Builtin -----
                "user-filters"
                "ublock-filters"
                "ublock-badware"
                "ublock-privacy"
                "ublock-quick-fixes"
                "ublock-unbreak"
                ## ----- Ads -----
                "easylist"
                ## ----- Privacy -----
                "easyprivacy"
                "LegitimateURLShortener"
                "adguard-spyware-url"
                "block-lan"
                ## ----- Malware -----
                "urlhaus-1"
                ## ----- Multipurpose -----
                "plowe-0"
                "dpollock-0"
                ## ----- Cookie Notices -----
                ## ----- Easylist -----
                "fanboy-cookiemonster"
                "ublock-cookies-easylist"
                ## ------ Social -----
                "fanboy-social"
                # "adguard-social"
                "fanboy-thirdparty_social"
                ## ----- Annoyances -----
                ### ----- Easylist -----
                "easylist-chat"
                "easylist-newsletters"
                "easylist-notifications"
                "easylist-annoyances"
                ### ----- uBlock -----
                "ublock-annoyances"
              ]
              ++ importedLists;
            };
        };
       };
      };
    };
}
