{pkgs, ...}: {
  home.file.".config/nvim/init.lua".source = ./init.lua;
  home.file.".config/nvim/lua".source = ./lua;
  programs.neovim = {
    enable = true;
    extraPackages = with pkgs; [
      clang
      gnumake
      python3
      sqlite
      stylua
      (tree-sitter.withPlugins (plugins: tree-sitter.allGrammars))
    ];
  };
}
