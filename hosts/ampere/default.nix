{ pkgs, ... }:
{
  system.stateVersion = 6;

  environment.systemPackages = with pkgs; [
    nur.repos.DimitarNestorov.ghostty
    awscli2
    llama-cpp
    azure-cli
    kubelogin
    mkcert
    nssTools
    openjdk11
  ];

  psyclyx.sketchybar.yOffset = 5;

  programs.fish.enable = true;
  programs.bash.enable = true;

  imports = [
    ../../modules/platform/darwin/base
    ../../modules/platform/darwin/desktop
    ./users.nix
    ./casks.nix
  ];
}
