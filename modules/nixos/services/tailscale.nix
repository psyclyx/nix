{
  config,
  pkgs,
  lib,
  ...
}:
let
  cfg = config.psyclyx.services.tailscale;
  tsCfg = config.services.tailscale;
in
{
  options = {
    psyclyx.services.tailscale = {
      enable = lib.mkEnableOption "Enable tailscale service and related settings";
      exitNode = lib.mkEnableOption "Configure tailscale client as an exit node";
    };
  };

  config = lib.mkIf cfg.enable {
    services.tailscale = {
      enable = true;
      openFirewall = true;
      port = 41641;
      interfaceName = "ts0";
      useRoutingFeatures = if cfg.exitNode then "both" else "client";
    };

    environment.systemPackages = [ pkgs.tailscale ];

    # Don't wait for tailscale interface to come online during boot
    systemd.network.wait-online.ignoredInterfaces = [ tsCfg.interfaceName ];

    networking.firewall.trustedInterfaces = [ tsCfg.interfaceName ];

    # This supposedly mitigates some issues
    # around sleep/wake, boot, and system swtiches.
    # TODO: might be able to remove?
    systemd.services = {
      tailscaled = {
        after = [
          "network-online.target"
          "systemd-resolved.service"
        ];
        wants = [ "network-online.target" ];
      };
    };
  };
}
