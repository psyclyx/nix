{pkgs, ...}: let
in {
  home.packages = with pkgs; [
    neofetch
    obsidian
    git
    kitty
  ];

  imports = [
    ./common.nix
    ./xdg.nix
    ./programs/sway
    ./programs/swayidle.nix
    ./programs/rofi
    ./programs/signal.nix
    ./programs/vscodium.nix
    ./programs/firefox
    ./themes/gtk.nix
  ];
}
