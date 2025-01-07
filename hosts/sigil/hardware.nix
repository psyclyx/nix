{
  inputs,
  config,
  ...
}: {
  hardware.cpu.amd.updateMicrocode = true;
  hardware.enableRedistributableFirmware = true;
  imports = [
    inputs.nixos-hardware.nixosModules.common-gpu-nvidia-nonprime
    inputs.nixos-hardware.nixosModules.common-cpu-amd
    inputs.nixos-hardware.nixosModules.common-gpu-intel-disable
  ];
  services.xserver.videoDrivers = ["nvidia"];
  hardware.graphics.enable = true;
  hardware.opengl = {
    enable = true;
    driSupport32Bit = true;
  };
  hardware.nvidia = {
    nvidiaSettings = true;
    package = config.boot.kernelPackages.nvidiaPackages.production;
    powerManagement.enable = false;
    powerManagement.finegrained = false;
    open = false;
    modesetting.enable = true;
  };
}
