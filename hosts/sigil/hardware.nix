{
  inputs,
  config,
  ...
}: {
  hardware.cpu.amd.updateMicrocode = true;
  hardware.enableRedistributableFirmware = true;
  imports = [
    inputs.nixos-hardware.nixosModules.common-cpu-amd
  ];
  hardware.nvidia.open = true;

  services.xserver.videoDrivers = ["nvidia"];
  hardware.graphics.enable = true;

  powerManagement.enable = false;
  powerManagement.finegrained = true;
  nvidiaSettings = true;
  hardware.nvidia.package = config.boot.kernelPackages.nvidiaPackages.stable;
}
