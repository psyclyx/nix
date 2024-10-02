{pkgs, ...}: {
  home.stateVersion = "23.11";

  home.packages = with pkgs; [
    source-code-pro
    firefox
  ];

  fonts.fontconfig.enable = true;

  imports = [
    ./programs/wezterm
    ./programs/tmux
    ./programs/zsh
    ./programs/nvim
  ];
}
