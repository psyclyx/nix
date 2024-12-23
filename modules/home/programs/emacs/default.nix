{
  config,
  pkgs,
  ...
}: let
  packageConfig = import ./packages.nix;
in {
  programs.emacs = {
    enable = true;
    package = pkgs.emacs-git;
    extraPackages = epkgs:
      (packageConfig.emacsPackages epkgs) ++ (packageConfig.systemPackages pkgs);
  };
  home.file."${config.xdg.configHome}/emacs" = {
    source = ./emacs;
    recursive = true;
  };
}
