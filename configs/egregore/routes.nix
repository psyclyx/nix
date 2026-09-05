# Static routes, as entities.
#
# Only the switches need these declared today: NixOS hosts get their
# default route from the network projection, and iyr's WAN failover is
# policy routing rather than a static default.
#
# The router-on-a-stick cutover is a one-line change here — `over`
# moves from `main` to `core-transit` — plus moving `refs.gateway` on
# the main network. Nothing else in the tree mentions the way off the
# switch any more.
{
  gate = "always";
  config = {
    entities = {
      mdf-agg01-default = {
        type = "route";
        refs = { on = "mdf-agg01"; via = "iyr"; over = "main"; };
        route = {
          dst = "0.0.0.0/0";
          comment = "iyr on main";
        };
      };

      # iyr → the cluster networks, which mdf-agg01 routes and iyr has no
      # interface on. storage and lab need no entry: iyr holds an L2
      # anchor on both, so they're connected rather than routed.
      #
      # These were previously reconstructed by walking every switch,
      # taking the networks it gateways, subtracting the ones this host
      # is connected to, and resolving a next hop through the switch's
      # `uplinkNetwork`. That inferred from a switch-side knob something
      # that depends on the host — which of the five networks iyr and
      # mdf-agg01 share carries the traffic. It's one fact per route and
      # it belongs here.
    }
    // builtins.listToAttrs (builtins.concatMap (n: [
      {
        name = "iyr-to-${n.name}";
        value = {
          type = "route";
          refs = { on = "iyr"; via = "mdf-agg01"; over = "main"; };
          route.dst = n.v4;
        };
      }
      {
        name = "iyr-to-${n.name}-v6";
        value = {
          type = "route";
          refs = { on = "iyr"; via = "mdf-agg01"; over = "main"; };
          route.dst = n.v6;
        };
      }
    ]) [
      { name = "cluster-prod";    v4 = "10.0.220.0/24"; v6 = "fd9a:e830:4b1e:dc::/64"; }
      { name = "cluster-stage";   v4 = "10.0.221.0/24"; v6 = "fd9a:e830:4b1e:dd::/64"; }
      { name = "cluster-scratch"; v4 = "10.0.222.0/24"; v6 = "fd9a:e830:4b1e:de::/64"; }
      { name = "cluster-orch";    v4 = "10.0.223.0/24"; v6 = "fd9a:e830:4b1e:df::/64"; }
    ])
    // {
      # idf-dist01 and the other L2 switches carry a default route
      # declared-but-disabled: they don't route, but the entry is here
      # so enabling it is a data change rather than an improvisation at
      # 2am. Reached over mgmt, which is the only network they hold an
      # address on.
      idf-dist01-default = {
        type = "route";
        refs = { on = "idf-dist01"; via = "iyr"; over = "mgmt"; };
        route = {
          dst = "0.0.0.0/0";
          disabled = true;
        };
      };
    };
  };
}
