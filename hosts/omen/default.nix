{...}: {
  imports = [
    ./boot.nix
    ./filesystems.nix
    ./hardware.nix
    ./users.nix
    ../../modules/nixos/programs
    ../../modules/nixos/services
    ../../modules/nixos/system
  ];
}
