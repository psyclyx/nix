{ pkgs, config, ... }:

let
  emacs-pkg = (pkgs.emacsWithPackagesFromUsePackage {
                config = ./config.el;
                defaultInitFile = true;
                package = pkgs.emacs-29;
                alwaysEnsure = true;
  });
in
{
  home.packages = [ emacs-pkg ];
}
