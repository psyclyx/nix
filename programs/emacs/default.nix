{ pkgs, config, ... }:

let
  emacs-pkg = (pkgs.emacsWithPackagesFromUsePackage {
                config = ./emacs.d/packages.el;
                package = pkgs.emacs-29;
                alwaysEnsure = true;
  });
in
{
  home.packages = [ emacs-pkg ];
  home.file.".emacs.d".source = ./emacs.d;
  home.file.".emacs.d".recursive = true;
}
