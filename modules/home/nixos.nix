{
  inputs,
  pkgs,
  buildFirefoxXpiAddon,
  ...
}: let
in {
  home.packages = with pkgs; [
    freecad
    git
    kitty
    neofetch
    obsidian
    zotero
    orca-slicer
  ];

  imports = [
    inputs.sops-nix.homeManagerModules.sops
    ./common.nix
    ./programs/firefox
    ./programs/git
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
