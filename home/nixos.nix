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
  ];

  imports = [
    inputs.nix-colors.homeManagerModules.default
    ./common.nix
    ./programs/sway
    ./programs/waybar.nix
    ./programs/rofi.nix
  ];
}
