{...}: {
  system.stateVersion = "24.05"; # Likely don't want to ever change this

  imports = [
    ./boot.nix
    ./console.nix
    ./fonts.nix
    ./home-manager.nix
    ./locale.nix
    ./networking.nix
    ./nix.nix
    ./security.nix
    ./time.nix
  ];
}
