{
  inputs,
  config,
  lib,
  modulesPath,
  ...
}: {
  imports = [
    (modulesPath + "/installer/scan/not-detected.nix")
    inputs.nixos-hardware.nixosModules.lenovo-thinkpad-x1-6th-gen
  ];

  boot.initrd.availableKernelModules = ["xhci_pci" "ahci" "usb_storage" "sd_mod"];
  boot.initrd.kernelModules = [];
  boot.kernelModules = ["kvm-intel"];
  boot.extraModulePackages = [];

  fileSystems."/" = {
    device = "/dev/disk/by-uuid/2f7b6389-e485-4052-9099-4051ec7e8937";
    fsType = "btrfs";
    options = ["subvol=@"];
  };

  boot.initrd.luks.devices."crypted".device = "/dev/disk/by-uuid/ad19e9a8-82ee-4d6f-a099-288b15bbfce6";

  fileSystems."/home" = {
    device = "/dev/disk/by-uuid/2f7b6389-e485-4052-9099-4051ec7e8937";
    fsType = "btrfs";
    options = ["subvol=@home"];
  };

  fileSystems."/nix" = {
    device = "/dev/disk/by-uuid/2f7b6389-e485-4052-9099-4051ec7e8937";
    fsType = "btrfs";
    options = ["subvol=@nix"];
  };

  fileSystems."/persist" = {
    device = "/dev/disk/by-uuid/2f7b6389-e485-4052-9099-4051ec7e8937";
    fsType = "btrfs";
    options = ["subvol=@persist"];
  };

  fileSystems."/var" = {
    device = "/dev/disk/by-uuid/2f7b6389-e485-4052-9099-4051ec7e8937";
    fsType = "btrfs";
    options = ["subvol=@var"];
  };

  fileSystems."/boot" = {
    device = "/dev/disk/by-uuid/0B7A-BCCA";
    fsType = "vfat";
    options = ["fmask=0077" "dmask=0077"];
  };

  swapDevices = [
    {device = "/dev/disk/by-uuid/5613edab-b7a6-40a1-ba7e-777aad805837";}
  ];

  networking.useDHCP = lib.mkDefault true;

  hardware.cpu.intel.updateMicrocode = lib.mkDefault config.hardware.enableRedistributableFirmware;
}
