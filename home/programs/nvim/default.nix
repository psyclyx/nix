{pkgs, ...}: {
  home.packages = with pkgs; [
    neovim
    stylua
    python3
    sqlite
    (tree-sitter.withPlugins (plugins: tree-sitter.allGrammars))
  ];
  home.file.".config/nvim/init.lua".source = ./init.lua;
  home.file.".config/nvim/lua".source = ./lua;
}