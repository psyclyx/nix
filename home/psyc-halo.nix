{pkgs, ...}: {
  home.stateVersion = "23.11";

  home.packages = with pkgs; [
    nerd-fonts.noto
    htop
    vscode
  ];

  fonts.fontconfig.enable = true;

  imports = [
    ../modules/home/services/syncthing.nix
    ../modules/home/programs/git.nix
    ../modules/home/programs/kitty.nix
    ../modules/home/programs/nvim
    ../modules/home/programs/emacs
    ../modules/home/programs/signal.nix
    ../modules/home/programs/zsh
  ];
}
