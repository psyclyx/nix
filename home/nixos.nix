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
    sops-nix.homeManagerModules.sops
    ./common.nix
    ./xdg.nix
    ./programs/sway
    ./programs/swayidle.nix
    ./programs/rofi
    ./programs/signal.nix
    ./programs/vscodium.nix
    ./programs/firefox
    ./services/ssh-agent.nix
    ./themes/gtk.nix
  ];
}
