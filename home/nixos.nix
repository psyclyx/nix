{pkgs, ...}: {
  imports = [
    ./common.nix
    ./programs/sway
  ];

  home.packages = with pkgs; [
    firefox
  ];
}
