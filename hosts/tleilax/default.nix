{
  inputs,
  modulesPath,
  pkgs,
  ...
}: let
in {
  system.stateVersion = "24.05";
  time.timeZone = "America/Los_Angeles";
  imports = [
    ../../modules/nixos/base
    ../../modules/nixos/tailscale.nix
    ./users.nix
    ./network.nix
    ./hardware.nix
    ./filesystems.nix
    ./nginx.nix
    ./metrics.nix
  ];


  services.openssh.ports = [17891];
  boot.loader.systemd-boot.enable = true;

  services.fail2ban = {
    enable = true;
    # Ban IP after 5 failures
    maxretry = 5;
    ignoreIP = [
      "100.64.0.0/10"
    ];
    bantime = "1h"; # Ban IPs for one hour on the first ban
    bantime-increment = {
      enable = true; # Enable increment of bantime after each violation
      multipliers = "1 2 4 8 16 32 64";
      maxtime = "168h"; # Do not ban for more than 1 week
      overalljails = true; # Calculate the bantime based on all the violations
    };
    jails = {
      ngnix-url-probe.settings = {
        enabled = true;
        filter = "nginx-url-probe";
        logpath = "/var/log/nginx/access.log";
        action = ''%(action_)s[blocktype=DROP] '';
        backend = "auto"; # Do not forget to specify this if your jail uses a log file
        maxretry = 5;
        findtime = 600;
      };
    };
  };

  environment.etc = {
    "fail2ban/filter.d/nginx-url-probe.local".text = pkgs.lib.mkDefault (pkgs.lib.mkAfter ''
      [Definition]
      failregex = ^<HOST>.*(GET /(wp-|admin|boaform|phpmyadmin|\.env|\.git)|\.(dll|so|cfm|asp)|(\?|&)(=PHPB8B5F2A0-3C92-11d3-A3A9-4C7B08C10000|=PHPE9568F36-D428-11d2-A769-00AA001ACF42|=PHPE9568F35-D428-11d2-A769-00AA001ACF42|=PHPE9568F34-D428-11d2-A769-00AA001ACF42)|\\x[0-9a-zA-Z]{2})
    '');
  };
}
