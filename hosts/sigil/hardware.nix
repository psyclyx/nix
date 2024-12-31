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
  services.xserver.videoDrivers = ["nvidia"];
  hardware.graphics.enable = true;
  hardware.nvidia = {
    nvidiaSettings = true;
    package = config.boot.kernelPackages.nvidiaPackages.stable;
    powerManagement.enable = false;
    powerManagement.finegrained = true;
    open = true;
    modesetting = true;
  };
}
