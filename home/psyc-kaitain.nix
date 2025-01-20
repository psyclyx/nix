{
  inputs,
  pkgs,
  ...
}: let
in {
  home.stateVersion = "23.11";
  home.packages = with pkgs; [
    git
  ];

  imports = [
    inputs.sops-nix.homeManagerModules.sops
    ../modules/home/programs/git
    ../modules/home/programs/zsh
    ../modules/home/programs/nvim
    ../modules/home/programs/ssh.nix
    ../modules/home/secrets/sops.nix
    ../modules/home/services/ssh-agent.nix
    ../modules/home/xdg.nix
  ];
}
