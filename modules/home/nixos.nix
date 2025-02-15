{
  inputs,
  pkgs,
  ...
}: let
in {
  home.packages = with pkgs; [
    git
    kitty
    neofetch
    obsidian
    zotero
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
    ./services/syncthing.nix
    ./services/ssh-agent.nix
    ./themes/gtk.nix
    ./xdg.nix
  ];
}
