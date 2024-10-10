{...}: {
  security = {
    pam = {
      loginLimits = [
        {
          domain = "@users";
          item = "rtprio";
          type = "-";
          value = 1;
        }
      ];
    };

    rtkit = {
      enable = true;
    };

    sudo = {
      extraConfig = ''
        Defaults        timestamp_timeout=30
      '';
    };
  };
}
