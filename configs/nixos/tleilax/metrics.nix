{ config, ... }:
{
  services.grafana = {
    enable = true;
    settings.server.http_addr = "0.0.0.0";
    settings.server.http_port = 3010;
  };

  services.prometheus = {
    port = 3020;
    enable = true;

    exporters = {
      node = {
        port = 3021;
        enabledCollectors = [
          "systemd"
          "processes"
        ];
        enable = true;
      };
    };

    scrapeConfigs = [
      {
        job_name = "nodes";
        static_configs = [
          { targets = [ "127.0.0.1:${toString config.services.prometheus.exporters.node.port}" ]; }
        ];
      }
    ];
  };

  services.loki = {
    enable = false;
    configuration = {
      server = {
        http_listen_address = "127.0.0.1";
        http_listen_port = 3030;
        grpc_listen_port = 0;
      };

      auth_enabled = false;

      analytics.reporting_enabled = false;

      ingester = {
        lifecycler = {
          address = "127.0.0.1";
          ring = {
            kvstore = {
              store = "inmemory";
            };
            replication_factor = 1;
          };
        };
        chunk_idle_period = "1h";
        max_chunk_age = "1h";
        chunk_target_size = 999999;
        chunk_retain_period = "30s";
      };

      schema_config = {
        configs = [
          {
            from = "2025-03-01";
            store = "tsdb";
            object_store = "filesystem";
            schema = "v13";
            index = {
              prefix = "index_";
              period = "24h";
            };
          }
        ];
      };

      storage_config = {
        tsdb_shipper = {
          active_index_directory = "${config.services.loki.dataDir}/tsdb-shipper-active";
          cache_location = "${config.services.loki.dataDir}/tsdb-shipper-cache";
          cache_ttl = "24h";
        };

        filesystem = {
          directory = "${config.services.loki.dataDir}/chunks";
        };
      };

      limits_config = {
        reject_old_samples = true;
        reject_old_samples_max_age = "168h";
      };

      table_manager = {
        retention_deletes_enabled = false;
        retention_period = "0s";
      };

      compactor = {
        working_directory = config.services.loki.dataDir;
        compactor_ring = {
          kvstore = {
            store = "inmemory";
          };
        };
      };

    };
  };

  services.promtail = {
    enable = false;
    configuration = {
      server = {
        http_listen_port = "127.0.0.1";
        http_listen_address = 3040;
        instance_interface_names = [ "lo" ];
        grpc_listen_address = "127.0.0.1";
        grpc_listen_port = 3041;

      };
      positions = {
        filename = "/tmp/positions.yaml";
      };
      clients = [
        {
          url = "http://127.0.0.1:${toString config.services.loki.configuration.server.http_listen_port}/loki/api/v1/push";
        }
      ];
      scrape_configs = [
        {
          job_name = "journal";
          journal = {
            max_age = "12h";
            labels = {
              job = "systemd-journal";
              host = "tleilax";
            };
          };
          relabel_configs = [
            {
              source_labels = [ "__journal__systemd_unit" ];
              target_label = "unit";
            }
          ];
        }
      ];
    };
  };
}
