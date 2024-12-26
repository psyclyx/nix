{
  config,
  pkgs,
  ...
}: let
  packageConfig = import ./packages.nix;
  packages = (packageConfig.systemPackages pkgs);
in {
  programs.emacs = {
    enable = true;
    package = if pkgs.stdenv.isDarwin then pkgs.emacs-30 else pkgs.emacs-git;
    extraPackages = epkgs:
      (packageConfig.emacsPackages epkgs) ++ packages;
  };
  home.packages = packages;
  home.file."${config.xdg.configHome}/emacs" = {
    source = ./emacs;
    recursive = true;
  };
}
