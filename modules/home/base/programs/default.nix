{ ... }:
{
  imports = [
    ./git.nix
    ./nvim
    ./packages.nix
    ./ssh.nix
    ./tmux
    ./bash.nix
    ./fish.nix
    ./zsh
  ];
}
