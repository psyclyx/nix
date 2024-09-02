{...}: {
  home.stateVersion = "23.11";
  imports = [
    ./programs/tmux
    ./programs/zsh
    ./programs/nvim
  ];
}
