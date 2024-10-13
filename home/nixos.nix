{
  pkgs,
  inputs,
  ...
}: let
in {
  colorScheme = inputs.nix-colors.colorSchemes.solarized-dark;

  home.packages = with pkgs; [
    firefox
    neofetch
    obsidian
    git
  ];

  imports = [
    inputs.nix-colors.homeManagerModules.default
    ./common.nix
    ./xdg.nix
    ./programs/sway
    ./programs/swayidle.nix
    ./programs/waybar.nix
    ./programs/rofi
    ./programs/signal.nix
    ./programs/vscodium.nix
    ./themes/gtk.nix
  ];
}
