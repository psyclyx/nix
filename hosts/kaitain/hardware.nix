{
  inputs,
  ...
}: {
  hardware.enableRedistributableFirmware = true;
  imports = [
    inputs.nixos-hardware.nixosModules.common-cpu-intel
  ];
}
