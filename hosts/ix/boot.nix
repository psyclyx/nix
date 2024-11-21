{...}: {
  boot = {
    initrd = {
      availableKernelModules = [
        "ahci"
        "xhci_pci"
        "virtio_pci"
        "virtio_scsi"
        "sd_mod"
        "sr_mod"
      ];
      systemd.users.root.shell = "/bin/cryptsetup-askpass";
      network = {
        enable = true;
        ssh = {
          enable = true;
          port = 22;
          authorizedKeys = ["ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIEwUKqMso49edYpzalH/BFfNlwmLDmcUaT00USWiMoFO me@psyclyx.xyz"];
          hostKeys = ["/etc/secrets/initrd/ssh_host_rsa_key"];
        };
      };
    };

    kernelModules = [];

    kernelParams = ["ip=dhcp"];

    loader = {
      grub = {
        enable = true;
      };
    };
  };
}
