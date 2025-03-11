{pkgs, ...}: {
  system.stateVersion = 6;

  environment.systemPackages = with pkgs; [
    awscli2
    azure-cli
    kubelogin
    mkcert
    nssTools
    openjdk11
  ];

  psyclyx.sketchybar.yOffset = 5;

  imports = [
    ../../modules/platform/darwin/base
    ../../modules/platform/darwin/desktop
    ./users.nix
    ./casks.nix
  ];
}
