{
  config,
  pkgs,
  ...
}: let
  packageConfig = import ./packages.nix;
  emacs =
    if pkgs.stdenv.isDarwin
    then pkgs.emacs-29
    else pkgs.emacs29;
in {
  programs.emacs = {
    enable = true;
    package = emacs;
    extraPackages = epkgs:
      (packageConfig.emacsPackages epkgs)
      ++ (packageConfig.systemPackages pkgs);
  };

  home.file."${config.xdg.configHome}/emacs" = {
    source = ./emacs;
    recursive = true;
  };
}
