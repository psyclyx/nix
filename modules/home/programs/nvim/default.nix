{pkgs, ...}: let
  grammarsPath = pkgs.symlinkJoin {
    name = "nvim-treesitter-grammars";
    paths = pkgs.vimPlugins.nvim-treesitter.withAllGrammars.dependencies;
  };
in {
  home.file.".config/nvim/init.lua".text = ''
    vim.opt.runtimepath:prepend("${grammarsPath}")
    require("config")
  '';
  home.file.".config/nvim/lua".source = ./lua;
  programs.neovim = {
    enable = true;
    extraPackages = with pkgs; [
      alejandra
      clang
      cljstyle
      gnumake
      lua-language-server
      nixd
      python3
      ripgrep
      sqlite
      stylua
      (tree-sitter.withPlugins (plugins: tree-sitter.allGrammars))
    ];
  };
}
