{...}: {
  system.stateVersion = 4;
  imports = [
    ./users.nix
    ./casks.nix
    ../../modules/common/system/cache.nix
    ../../modules/darwin/system/nix.nix
    ../../modules/darwin/system/homebrew.nix
    ../../modules/darwin/system/security.nix
    ../../modules/darwin/system/home-manager.nix
    ../../modules/darwin/system/settings.nix
    ../../modules/darwin/services/nix-daemon.nix
    ../../modules/darwin/services/tailscale.nix
    ../../modules/darwin/programs/raycast.nix
    ../../modules/nixos/programs/zsh.nix
  ];
}
