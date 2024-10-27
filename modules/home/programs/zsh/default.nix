{pkgs, ...}: {
  imports = [./p10k-hm.zsh];
  home.packages = with pkgs; [
    jq
  ];
  programs.zoxide.enable = true;
  programs.fzf = {
    enable = true;
    enableZshIntegration = true;
  };
  programs.direnv = {
    enable = true;
    enableZshIntegration = false;
    silent = true;
    nix-direnv.enable = true;
  };
  programs.zsh = {
    enable = true;
    powerlevel10k = {
      enable = true;
      instantPrompt = true;
      config.source = ./p10k.zsh;
    };
    initExtra = ''
      path_append() {
        if [ -d "''$1" ] && [[ ":''$PATH:" != *":''$1:"* ]]; then
      export PATH="''${PATH:+"''$PATH:"}''$1"
        fi
      }

      path_append "$HOME/bin"


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
      rn = "wezterm cli rename-workspace";
      nsp = "nix-shell --run $SHELL -p";
    };
  };
}
