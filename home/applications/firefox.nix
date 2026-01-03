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
            margin-top: -34px !important; /* Adjust to match nav-bar height */
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
###----- Personal -----###
"browser.newtabpage.enabled" = false;
"browser.startup.homepage" = "about:blank";

"widget.use-xdg-desktop-portal.file-picker" = 2; # Native Linux file Picker
"browser.translations.automaticallyPopup" = false;
"browser.uidensity" = 1;

# Disable suggestions
"browser.urlbar.suggest.searches" = false;
"browser.urlbar.shortcuts.history" = false;
"browser.urlbar.shortcuts.tabs" = false;

"extensions.htmlaboutaddons.discover.enabled" = false;
"media.videocontrols.picture-in-picture.video-toggle.enabled" = false;
"widget.non-native-theme.enabled" = false;

"network.allow-experiments" = false;
"ui.key.menuAccessKeyFocuses" = false;
"ui.key.menuAccessKey" = 17;

# Scrolling
"general.smoothScroll" = false;

###----- From user.js -------#
"gfx.content.skia-font-cache-size" = 32;
/** GFX ***/
"gfx.webrender.layer-compositor" = true;
"gfx.canvas.accelerated.cache-items"= 32768;
"gfx.canvas.accelerated.cache-size"= 4096;
"webgl.max-size"= 16384;

/** DISK CACHE ***/
"browser.cache.disk.enable" = false;

/** MEMORY CACHE ***/
"browser.cache.memory.capacity" = 41297;
"browser.cache.memory.max_entry_size" = 20480;
"browser.sessionhistory.max_total_viewers" = 4;
"browser.sessionstore.max_tabs_undo" = 10;

/** MEDIA CACHE ***/
"media.memory_cache_max_size"= 262144;
"media.memory_caches_combined_limit_kb"= 1048576;
"media.cache_readahead_limit"= 600;
"media.cache_resume_threshold"= 300;

/** IMAGE CACHE ***/
"image.cache.size"= 10485760;
"image.mem.decode_bytes_at_a_time"= 65536;

/** NETWORK ***/
"network.http.max-connections"= 1800;
"network.http.max-persistent-connections-per-server"= 10;
"network.http.max-urgent-start-excessive-connections-per-host"= 5;
"network.http.request.max-start-delay"= 5;
"network.http.pacing.requests.enabled"= false;
"network.dnsCacheEntries"= 10000;
"network.dnsCacheExpiration"= 3600;
"network.ssl_tokens_cache_capacity"= 10240;

/** SPECULATIVE LOADING ***/
"network.http.speculative-parallel-limit"= 0;
"network.dns.disablePrefetch"= true;
"network.dns.disablePrefetchFromHTTPS"= true;
"browser.urlbar.speculativeConnect.enabled"= false;
"browser.places.speculativeConnect.enabled"= false;
"network.prefetch-next"= false;

/****************************************************************************
 * SECTION: SECUREFOX                                                       *
****************************************************************************/
/** TRACKING PROTECTION ***/
"browser.download.start_downloads_in_tmp_dir" = true;
"browser.uitour.enabled" = false;
"privacy.globalprivacycontrol.enabled" = true;
"privacy.antitracking.isolateContentScriptResources" = true;
"security.csp.reporting.enabled" = false;

/** DISK AVOIDANCE ***/
"browser.privatebrowsing.forceMediaMemoryCache" = true;
"browser.sessionstore.interval" = 60000;

/** History ***/
"privacy.history.custom" = true;

/** HTTPS-ONLY MODE ***/
"dom.security.https_only_mode" = true;
"dom.security.https_only_mode_error_page_user_suggestions" = true;

/** VARIOUS ***/
"pdfjs.enableScripting" = false;
"browser.search.update" = false;

/** TELEMETRY ***/
"browser.newtabpage.activity-stream.feeds.telemetry" = false;
"browser.newtabpage.activity-stream.telemetry" = false;
"browser.ping-centre.telemetry" = false;
"datareporting.policy.dataSubmissionEnabled" = false;
"datareporting.healthreport.uploadEnabled" = false;
"datareporting.usage.uploadEnabled" = false;
"toolkit.telemetry.unified" = false;
"toolkit.telemetry.enabled" = false;
"toolkit.telemetry.server" = "data:,";
"toolkit.telemetry.archive.enabled" = false;
"toolkit.telemetry.newProfilePing.enabled" = false;
"toolkit.telemetry.shutdownPingSender.enabled" = false;
"toolkit.telemetry.updatePing.enabled" = false;
"toolkit.telemetry.bhrPing.enabled" = false;
"toolkit.telemetry.firstShutdownPing.enabled" = false;
"toolkit.telemetry.coverage.opt-out" = true;
"toolkit.coverage.opt-out" = true;
"toolkit.coverage.endpoint.base" = "";

/** EXPERIMENTS ***/
"app.shield.optoutstudies.enabled" = false;
"app.normandy.enabled" = false;
"app.normandy.api_url" = "";
"experiments.activeExperiment" = false;
"experiments.enabled" = false;
"experiments.supported" = false;

/****************************************************************************
 * SECTION: PESKYFOX                                                        *
****************************************************************************/
/** MOZILLA UI ***/
"extensions.getAddons.showPane" = false;
"extensions.htmlaboutaddons.recommendations.enabled" = false;
"browser.discovery.enabled" = false;
"browser.shell.checkDefaultBrowser" = false;
"browser.newtabpage.activity-stream.asrouter.userprefs.cfr.addons" = false;
"browser.newtabpage.activity-stream.asrouter.userprefs.cfr.features" = false;
"browser.preferences.moreFromMozilla" = false;
"browser.aboutConfig.showWarning" = false;
"browser.startup.homepage_override.mstone" = "ignore";
"browser.aboutwelcome.enabled" = false;
"browser.profiles.enabled" = true;

/** THEME ADJUSTMENTS ***/
"toolkit.legacyUserProfileCustomizations.stylesheets" = true;
"browser.compactmode.show" = true;

/** AI ***/
"browser.ml.enable" = false;
"browser.ml.chat.enabled" = false;
"browser.ml.chat.menu" = false;
"browser.tabs.groups.smart.enabled" = false;
"browser.ml.linkPreview.enabled" = false;

/** FULLSCREEN NOTICE ***/
"full-screen-api.transition-duration.enter" = "0 0";
"full-screen-api.transition-duration.leave" = "0 0";
"full-screen-api.warning.timeout" = 0;

/** URL BAR ***/
"browser.search.suggest.enabled" = false;
"browser.urlbar.scotchBonnet.enableOverride" = false;
"browser.urlbar.quicksuggest.enabled" = false;
"browser.urlbar.groupLabels.enabled" = false;
"browser.urlbar.trending.featureGate" = false;
"browser.formfill.enable" = false;

/** DOWNLOADS ***/
"browser.download.manager.addToRecentDocs" = false;

/** PDF ***/
"browser.download.open_pdf_attachments_inline" = true;

/** TAB BEHAVIOR ***/
"browser.bookmarks.openInTabClosesMenu" = false;
"browser.menu.showViewImageInfo" = true;
"findbar.highlightAll" = true;
"layout.word_select.eat_space_to_next_word" = false;
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
