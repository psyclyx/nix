{pkgs, ...}: {
  system.stateVersion = 4;

  environment.systemPackages = with pkgs; [
    awscli2
    azure-cli
    kubelogin
    mkcert
  ];

  imports = [
    ../../modules/platform/darwin/base
    ../../modules/platform/darwin/desktop
    ./users.nix
    ./casks.nix
  ];
}
