{pkgs, config, lib, ...}:
let 
  defaultNameservers = [
    "9.9.9.9"
    "149.112.112.112"
    "2620:fe::fe"
    "2620:fe::9"
  ];
in
{ 

  options.enableMonitoring = lib.mkEnableOption "Enable Prometheus and Grafana monitoring services";
  config = {
    services.blocky = {
      enable = true;
      settings = {
        upstreams = {
        groups.default = defaultNameservers;
        };
        bootstrapDns = defaultNameservers;
        blocking = {
          loading.refreshPeriod = "24h";
          denylists = {
            general = [
              "https://raw.githubusercontent.com/hagezi/dns-blocklists/main/wildcard/ultimate.txt"
              "https://raw.githubusercontent.com/hagezi/dns-blocklists/main/wildcard/tif.txt"
            ];
            social = [
              "https://raw.githubusercontent.com/StevenBlack/hosts/master/alternates/social-only/hosts"
            ]; 
            extra = [
              "https://raw.githubusercontent.com/StevenBlack/hosts/master/alternates/porn-only/hosts"
              ''
                *.twitch.tv
              ''
            ];
          };
          allowlists = {
            social= [
              ''
                web.whatsapp.com
                *.whatsapp.net
              ''
            ];
          };
          clientGroupsBlock = {
            default = [ "general" "social" "extra" ];
          };
        };
        caching = {
          minTime = "5m";
          maxTime = "4h";
          prefetching = true;
          prefetchExpires = "1h";
          prefetchThreshold = 3;
          cacheTimeNegative = "15m";
        };
        ports = lib.mkIf config.enableMonitoring {
          dns = 53;
          http = 4000;
        };
        prometheus = {
          enable = config.enableMonitoring;  # Toggle with enableMonitoring
          path = "/metrics";
        };
      };
    };

    services.prometheus = lib.mkIf config.enableMonitoring {
      enable = true;
      port = 9090;
      globalConfig.scrape_interval = "30s";
      scrapeConfigs = [{
        job_name = "blocky";
        static_configs = [{ targets = [ "127.0.0.1:4000" ]; }];
      }];
    };

    services.grafana = lib.mkIf config.enableMonitoring {
      enable = true;
      declarativePlugins = [ pkgs.grafanaPlugins.grafana-piechart-panel ];
      settings = {
        panels.disable_sanitize_html = true;
        server = {
          http_addr = "127.0.0.1";
          http_port = 3000;
        };
        "auth.anonymous" = {
          enabled = true;
          org_role = "Viewer";
          org_name = "Main Org";
        };
      };
      provision = {
        datasources.settings = {
          apiVersion = 1;
          deleteDatasources = [
            {
              name = "Prometheus";
              orgId = 1;
            }
          ];
          datasources = [
            {
              name = "Prometheus";
              type = "prometheus";
              access = "proxy";
              orgId = 1;
              url = "http://127.0.0.1:9090";
              isDefault = true;
              version = 1;
              editable = false;
            }
          ];
        };
      };
    };

    networking = {
      nameservers = ["127.0.0.1"];
      networkmanager = {
        enable = true;
        dns = "none";
      };
    };
  };
}
