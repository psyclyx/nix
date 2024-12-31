{
  inputs,
  pkgs,
  buildFirefoxXpiAddon,
  ...
}: let
in {
  home.stateVersion = "23.11";
  home.packages = with pkgs; [
    git
    kitty
    neofetch
    obsidian
    zotero
  ];

  imports = [
    inputs.sops-nix.homeManagerModules.sops
    ../modules/home/programs/firefox
    ../modules/home/programs/git
    ../modules/home/programs/zsh
    ../modules/home/programs/kitty.nix
    ../modules/home/programs/nvim
    ../modules/home/programs/emacs
    ../modules/home/programs/rofi
    ../modules/home/programs/signal.nix
    ../modules/home/programs/ssh.nix
    ../modules/home/programs/sway
    ../modules/home/programs/swayidle.nix
    ../modules/home/secrets/sops.nix
    ../modules/home/services/ssh-agent.nix
    ../modules/home/themes/gtk.nix
    ../modules/home/xdg.nix
  ];
}
