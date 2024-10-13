{pkgs, ...}: {
  boot = {
    initrd = {
      availableKernelModules = [
        "xhci_pci"
        "ahci"
        "usb_storage"
        "sd_mod"
      ];
    };

    kernelModules = ["kvm-intel"];

    kernelParams = [
      "snd-intel-dspcfg.dsp_driver=1" # fix pipewire audio
      "i915.enable_psr=0" # screen flickering
    ];

    loader = {
      efi = {
        canTouchEfiVariables = true;
      };
    };
  };
}