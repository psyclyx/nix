{pkgs, ...}: {
  system.stateVersion = 4;

  environment.systemPackages = with pkgs; [
    awscli2
    azure-cli
    kubelogin
    mkcert
  ];

  imports = [
    ./users.nix
    ./casks.nix
    ../../modules/darwin/system/nix.nix
    ../../modules/darwin/system/homebrew.nix
    ../../modules/darwin/system/security.nix
    ../../modules/darwin/system/home-manager.nix
    ../../modules/darwin/system/settings.nix
    ../../modules/darwin/services/aerospace.nix
    ../../modules/darwin/services/jankyborders.nix
    ../../modules/darwin/services/nix-daemon.nix
    ../../modules/darwin/services/sketchybar
    ../../modules/darwin/programs/raycast.nix
    ../../modules/nixos/programs/zsh.nix
  ];
}
