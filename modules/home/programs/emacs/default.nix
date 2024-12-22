{
  config,
  pkgs,
  inputs,
  ...
}: let
  packageConfig = import ./packages.nix;
  patch = path: "${inputs.homebrew-emacs-plus}/patches/emacs-29/${path}";
  baseEmacs =
    if pkgs.stdenv.isDarwin
    then
      pkgs.emacsGit.overrideAttrs (old: {
        patches =
          (old.patches or [])
          ++ [
            (patch "fix-window-role.patch")
            (patch "no-frame-refocus-cocoa.patch")
            (patch "round-undecorated-frame.patch")
            (patch "system-appearance.patch")
          ];
        configureFlags =
          (old.configureFlags or [])
          ++ [
            "LDFLAGS=-headerpad_max_install_names"
          ];
      })
    else pkgs.emacsPgtk;
  emacs = pkgs.emacsWithPackagesFromUsePackage {
    config = ./config.org;
    defaultInitFile = true;
    package = pkgs.emacs-git;
    alwaysTangle = true;
    alwaysEnsure = true;
  };
in {
  home.packages = [emacs];
}
