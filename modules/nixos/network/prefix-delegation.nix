# Onward IPv6 prefix delegation.
#
# A router that receives a prefix by DHCPv6-PD can hand slices of it to
# downstream routers. systemd-networkd does the receiving well — it
# tracks the lease and re-derives its own interface addresses whenever
# the upstream prefix changes — but it only assigns to interfaces it
# owns. It is not a DHCPv6 server and cannot delegate onward.
#
# Kea is a DHCPv6 server and does delegate, but its `pd-pools` are
# literal configuration: it has no way to learn at runtime that the
# upstream prefix moved. dnsmasq cannot serve IA_PD at all, and odhcpd,
# which does exactly this job, is not packaged in nixpkgs.
#
# So the two halves have to be joined. This module is that join, and
# nothing else: it watches the prefix networkd learned, derives a slice
# per downstream router, replaces the prefix in Kea's pool, and routes
# the slice toward the router that was given it.
#
# The point of the exercise is that a renumber is a non-event. Nothing
# here, and nothing in the fleet data behind it, contains a global
# prefix — only the plan for slicing whatever prefix arrives.
{
  path = ["psyclyx" "nixos" "network" "prefixDelegation"];
  description = "Delegate slices of a dynamically-received IPv6 prefix downstream";

  options = { lib, ... }: {
    enable = lib.mkEnableOption "onward IPv6 prefix delegation";

    keaSocket = lib.mkOption {
      type = lib.types.path;
      default = "/run/kea/kea-dhcp6-ctrl.sock";
      description = ''
        Kea's DHCPv6 control socket. The corresponding
        `control-socket` stanza has to be in Kea's own settings; this
        module only talks to it.
      '';
    };

    downstream = lib.mkOption {
      default = {};
      description = ''
        Routers that receive a slice of our delegation, keyed by name.

        The name is the contract with Kea: the pd-pool this module
        maintains is the one whose `user-context` carries
        `psyclyx-delegation = "<name>"`. Marking the pool rather than
        addressing it by subnet id or position means the rest of Kea's
        configuration can be reordered, renumbered or extended without
        this module losing track of what it owns.
      '';
      type = lib.types.attrsOf (lib.types.submodule {
        options = {
          subnetId = lib.mkOption {
            type = lib.types.int;
            description = ''
              Which slice of the upstream prefix this router gets,
              counted in units of `prefixLength`. With a /60 upstream
              and prefixLength 61, subnetId 1 is the upper half.
            '';
          };
          prefixLength = lib.mkOption {
            type = lib.types.int;
            description = "Size of the slice, e.g. 61 for half of a /60.";
          };
          interface = lib.mkOption {
            type = lib.types.str;
            description = "Link this router is reached over.";
          };
          via = lib.mkOption {
            type = lib.types.str;
            description = ''
              The router's address on that link, used as the next hop
              for the slice. A static address (a ULA on the transit
              link) rather than one derived from the delegation, so the
              route survives the renumber that changes the prefix.
            '';
          };
        };
      });
    };
  };

  config = { cfg, lib, pkgs, ... }: lib.mkIf (cfg.enable && cfg.downstream != {}) (
    let
      plan = pkgs.writeText "prefix-delegation.json" (builtins.toJSON {
        socket = cfg.keaSocket;
        downstream = cfg.downstream;
      });

      binder = pkgs.writers.writePython3Bin "prefix-delegation-bind" {
        flakeIgnore = [ "E501" ];
      } (builtins.readFile ./prefix-delegation-bind.py);
    in {
      systemd.services.prefix-delegation = {
        description = "Delegate slices of the received IPv6 prefix downstream";
        # Ordered after Kea rather than before it: config-set does not
        # persist, so every Kea start needs the prefix re-applied.
        # `wantedBy` on the Kea unit is what makes that happen.
        after = [ "systemd-networkd.service" "kea-dhcp6-server.service" ];
        wantedBy = [ "multi-user.target" "kea-dhcp6-server.service" ];
        path = [ pkgs.iproute2 ];
        serviceConfig = {
          Type = "notify";
          NotifyAccess = "main";
          ExecStart = "${binder}/bin/prefix-delegation-bind ${plan}";
          Restart = "always";
          RestartSec = "5s";
        };
      };
    });
}
