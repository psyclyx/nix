{...}: {
  programs.zsh.initExtra = ''
    eval ''$(brew shellenv)

    notify-copy () {
    local content=''$(cat)
    echo "''$content" | pbcopy
    osascript -e "
    display notification \"Copied ''${content:0:50}\" with title \"''$1\" subtitle \"notify-copy\"
    beep
  '';
}
