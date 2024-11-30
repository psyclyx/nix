{pkgs, ...}: {
  home.stateVersion = "23.11";
  home.packages = with pkgs; [
    source-code-pro
  ];

  fonts.fontconfig.enable = true;

  imports = [
    ../modules/home/programs/git.nix
    ../modules/home/programs/kitty.nix
    ../modules/home/programs/nvim
    ../modules/home/programs/signal.nix
    ../modules/home/programs/zsh
  ];
}
