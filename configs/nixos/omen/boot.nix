{ pkgs, ... }:
{
  boot = {
    kernelPackages = pkgs.linuxPackages_lqx;
    consoleLogLevel = 3;
    initrd = {
      verbose = false;
      systemd.enable = true;
      availableKernelModules = [
        "xhci_pci"
        "ahci"
        "usb_storage"
        "sd_mod"
        "i915"
      ];
    };

    kernelModules = [ "kvm-intel" ];

    kernelParams = [
      "quiet"
      "splash"
      "intremap=on"
      "boot.shell_on_fail"
      "udev.log_priority=3"
      "rd.systemd.show_status=auto"
      "snd-intel-dspcfg.dsp_driver=1" # fix piewire audio
      "mitigations=off"
    ];

    plymouth.enable = true;

    loader = {
      timeout = 0;
      systemd-boot = {
        enable = true;
      };
      efi = {
        canTouchEfiVariables = true;
      };
    };
  };
}
