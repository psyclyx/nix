{...}: {
  services.nginx.enable = true;
  networking.firewall.allowedTCPPorts = [80 443];
  services.nginx.virtualHosts."tleilax.psyclyx.xyz" = {
    addSSL = true;
    enableACME = true;
    root = "/var/www/psyclyx.xyz";
  };
  security.acme = {
    acceptTerms = true;
    defaults.email = "me@psyclyx.xyz";
  };
}
