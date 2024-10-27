{
  inputs,
  pkgs,
  ...
}: let
in {
  home.packages = with pkgs; [
    neofetch
    obsidian
    git
    kitty
  ];

  imports = [
    inputs.sops-nix.homeManagerModules.sops
    ./common.nix
    ./programs/firefox
    ./programs/git.nix
    ./programs/rofi
    ./programs/signal.nix
    ./programs/ssh.nix
    ./programs/sway
    ./programs/swayidle.nix
    ./programs/vscodium.nix
    ./secrets/sops.nix
    ./services/ssh-agent.nix
    ./themes/gtk.nix
    ./xdg.nix
  ];
}
