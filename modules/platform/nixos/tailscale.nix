{
  config,
  pkgs,
  lib,
  ...
}: let
  psyclyxTsCfg = config.psyclyx.network.tailscale;
  tsCfg = config.services.tailscale;
in {
  options = {
    psyclyx.network.tailscale = {
      enable = lib.mkEnableOption "Enable tailscale service and related settings";
      exitNode = lib.mkEnableOption "Configure tailscale client as an exit node";
    };
  };

  config = lib.mkIf psyclyxTsCfg.enable {
    services.tailscale = {
      enable = true;
      openFirewall = lib.mkDefault true;
      port = lib.mkDefault 41641;
      interfaceName = lib.mkDefault "ts0";
      useRoutingFeatures =
        if psyclyxTsCfg.exitNode
        then "both"
        else "client";
    };

    environment.systemPackages = [pkgs.tailscale];

    # Don't wait for tailscale interface to come online during boot
    systemd.network.wait-online.ignoredInterfaces = [tsCfg.interfaceName];

    # Configure tailscale as an exit node?
    # TODO: this might be too broad?
    networking.firewall.trustedInterfaces = [tsCfg.interfaceName];

    # This supposedly mitigates some issues
    # around sleep/wake, boot, and system swtiches.
    # TODO: might be able to remove?
    systemd.services.tailscaled = {
      after = [
        "network-online.target"
        "systemd-resolved.service"
      ];
      wants = ["network-online.target"];
    };
  };
}
