{pkgs, ...}: {
  home.packages = [pkgs.fzf];
  home.file.".p10k.zsh".source = ./p10k.zsh;
  programs.zoxide.enable = true;
  programs.fzf = {
    enable = true;
    enableZshIntegration = true;
  };
  programs.zsh = {
    enable = true;
    initExtraFirst = ''
      if [[ -r "''${XDG_CACHE_HOME:-''$HOME/.cache}/p10k-instant-prompt-''${(%):-%n}.zsh" ]]; then
        source "''${XDG_CACHE_HOME:-''$HOME/.cache}/p10k-instant-prompt-''${(%):-%n}.zsh"
      fi'';
    initExtra = ''
      path_append() {
        if [ -d "''$1" ] && [[ ":''$PATH:" != *":''$1:"* ]]; then
      export PATH="''${PATH:+"''$PATH:"}''$1"
        fi
      }

      eval ''$(brew shellenv)

      path_append "$HOME/bin"
      path_append "/run/current-system/sw/bin"


      typeset -U path
      unsetopt BEEP

      ## Vi mode
      bindkey -v
      KEYTIMEOUT=1
      bindkey -M viins '^?' backward-delete-char
      bindkey -M viins '^H' backward-delete-char

      export EDITOR=nvim

      [[ -f ~/.anthropic_token ]] && export ANTHROPIC_API_KEY=''$(cat ~/.anthropic_token)
    '';
    shellAliases = {
      ls = "ls --color=auto";
      gs = "git status";
      gdh = "git diff HEAD";
      gdm = "git diff main";
      gdom = "git diff origin/main";
      gl = "git log --oneline";
      ns = "nix search nixpkgs";
    };
    zplug = {
      enable = true;
      plugins = [
        {
          name = "romkatv/powerlevel10k";
          tags = [as:theme depth:1];
        }
      ];
    };
  };
}
