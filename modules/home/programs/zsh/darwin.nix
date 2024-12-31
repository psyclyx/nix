{...}: {
  programs.zsh.initExtra = ''
    eval ''$(/opt/homebrew/bin/brew shellenv)
  '';
}
