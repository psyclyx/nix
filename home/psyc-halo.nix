{pkgs, ...}: {
  home.stateVersion = "23.11";
  home.packages = with pkgs; [
    nerdfonts
  ];

  fonts.fontconfig.enable = true;

  imports = [
    ../modules/home/programs/aerospace.nix
    ../modules/home/programs/git.nix
    ../modules/home/programs/kitty.nix
    ../modules/home/programs/nvim
    ../modules/home/programs/signal.nix
    ../modules/home/programs/zsh
  ];
}
