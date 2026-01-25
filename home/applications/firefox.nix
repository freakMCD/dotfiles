{ config, pkgs, lib, ...}:
{
    programs.firefox = {
      enable = true;
      policies = {
            ExtensionSettings = with builtins;
              let extension = shortId: uuid: {
                name = uuid;
                value = {
                  install_url = "https://addons.mozilla.org/en-US/firefox/downloads/latest/${shortId}/latest.xpi";
                  installation_mode = "normal_installed";
                };
              };
              in listToAttrs [
                (extension "ublock-origin" "uBlock0@raymondhill.net")
                (extension "youtube-recommended-videos" "myallychou@gmail.com")
              ];
          DisableFirefoxAccounts = true;
          DisableFirefoxStudies = true;
          DisableTelemetry = true;
          DontCheckDefaultBrowser = true;
          GenerativeAI.Enabled = false;
          Homepage = { StartPage = "previous-session"; };
          NewTabPage = false;
          OfferToSaveLogins = false;
          PasswordManagerEnabled = false;
          SearchSuggestEnabled = false;
          StartDownloadsInTempDirectory = true;
          TranslateEnabled = false;
      };

      profiles.default = {
        id=0;
        name = "edwin";
        isDefault = true;
        userChrome = ''
          /* Nav bar */
          #nav-bar, .urlbar-background, #sidebar-box, findbar, #nav-bar, #navigator-toolbox { background: #${config.colors.bg0} !important; }

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

          /* Hide buttons*/
          #reload-button, #tabs-newtab-button, .titlebar-buttonbox, .titlebar-spacer, .tabbrowser-tab .tab-close-button, #alltabs-button { display: none !important; }

          /* URL bar */
          #back-button, #forward-button, #tracking-protection-icon-container, #page-action-buttons { display: none !important; }

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

          #urlbar-container { width: auto !important; }

          #urlbar-container:not(:hover) :where(
            toolbarbutton,
            #userContext-label,
            #star-button-box,
            .verifiedDomain,
            #tracking-protection-icon-container,
            #pageAction-urlbar-_testpilot-containers,
            #pageActionButton,
          ) {
            font-size: 0 !important;
            max-width: 0 !important;
            padding-inline: 0 !important;
            margin-inline: 0 !important;
            opacity: 0 !important;
            transition: var(--out-transition) !important;
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
        # Accessibility, Input & Scrolling
        "accessibility.browsewithcaret_shortcut.enabled" = false;
        "general.smoothScroll" = false;
        "ui.key.menuAccessKey" = 17;        # Alt key
        "ui.key.menuAccessKeyFocuses" = false;

        # Accounts & UI Customization
        "toolkit.legacyUserProfileCustomizations.stylesheets" = true;

        # Core UX, Layout & Startup
        "browser.uidensity" = 1;
        "browser.aboutConfig.showWarning" = false;
        "media.videocontrols.picture-in-picture.video-toggle.enabled" = false;

        # Disk Usage & Downloads v/
        "browser.cache.disk.enable" = false;
        "browser.sessionstore.interval" = 300000; # ms
        "widget.use-xdg-desktop-portal.file-picker" = 2;

        # URL Bar, Search & Suggestions v/
        "browser.urlbar.suggest.engines" = false;
        "browser.urlbar.suggest.history" = false;
        "browser.urlbar.shortcuts.tabs" = false;

        # Mozilla UI, Discovery & Promotions
        "browser.discovery.enabled" = false;
        "extensions.htmlaboutaddons.recommendations.enabled" = false;
        };

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
                # "curben-phishing"
                ## ----- Multipurpose -----
                "plowe-0"
                "dpollock-0"
                ## ----- Cookie Notices -----
                ### ----- Easylist -----
                "fanboy-cookiemonster"
                "ublock-cookies-easylist"
                ## ----- Social -----
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
