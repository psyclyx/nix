{
  home.file.".p10k.zsh".source = ./p10k.zsh;
  programs.zoxide.enable = true;
  programs.zsh = {
    enable = true;
    initExtraFirst = ''
      if [[ -r "$\{XDG_CACHE_HOME:-$HOME/.cache}/p10k-instant-prompt-$\{(%):-%n}.zsh" ]]; then
        source "$\{XDG_CACHE_HOME:-$HOME/.cache}/p10k-instant-prompt-$\{(%):-%n}.zsh"
      fi'';
    initExtra = ''
      eval $(brew shellenv)
      eval "$(fzf --zsh)"
      [[ -f ~/.anthropic_token ]] && export ANTHROPIC_API_KEY=$(cat ~/.anthropic_token)
    '';
    zplug = {
      enable = true;
      plugins = [
      { name = "romkatv/powerlevel10k"; tags = [ as:theme depth:1 ]; }
      ];
    };
  };
}

