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
    plymouth.font = "${pkgs.hack-font}/share/fonts/truetype/Hack-Regular.ttf";
    plymouth.logo = "${pkgs.nixos-icons}/share/icons/hicolor/128x128/apps/nix-snowflake.png";
    plymouth.theme = "breeze";

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
