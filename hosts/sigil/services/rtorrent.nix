{...}: {
  services.rtorrent = {
    enable = true;

    user = "rtorrent";
    group = "rtorrent";
    dataDir = "/var/lib/rtorrent";
    dataPermissions = "0770";

    configText = ''
      network.port_range.set = 51103-51103
      dht_port = 6881

      dht.mode.set = auto
      protocol.pex.set = yes
      trackers.use_udp.set = yes

      directory.default.set = /var/lib/bulk/public/
      session.path.set = /var/lib/rtorrent/session
    '';
  };

  services.flood = {
    enable = true;
    openFirewall = true;
    port = 3000;
  };

  systemd.services.rtorrent.vpnConfinement = {
    enable = true;
    vpnNamespace = "wg";
  };
}
