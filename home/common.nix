{pkgs, ...}: {
  home.stateVersion = "23.11";

  home.packages = with pkgs; [
    (nerdfonts.override {fonts = ["SourceCodePro"];})
  ];

  fonts.fontconfig.enable = true;

  imports = [
    ./programs/wezterm
    ./programs/tmux
    ./programs/zsh
    ./programs/nvim
  ];
}
