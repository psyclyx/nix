{pkgs, ...}: {
  boot = {
    kernelPackages = pkgs.linuxPackages-rt_latest;
    loader = {
      systemd-boot = {
        enable = true;
      };
    };
  };
}
