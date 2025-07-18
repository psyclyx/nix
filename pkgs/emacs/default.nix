{
  pkgs,
  package ? pkgs.emacs-unstable-pgtk,
}:
let
  packages = (
    epkgs: with epkgs; [
      better-jumper
      cape
      centaur-tabs
      consult
      corfu
      direnv
      envrc
      evil
      evil-collection
      evil-easymotion
      evil-nerd-commenter
      evil-snipe
      evil-surround
      evil-textobj-anyblock
      exato
      general
      git-gutter-fringe
      magit
      marginalia
      mood-line
      nerd-icons
      nerd-icons-completion
      nerd-icons-corfu
      orderless
      smartparens
      vertico
      ws-butler
    ]
  );
  defaultInitFileName = "default.el";
  configFile = pkgs.writeText defaultInitFileName (builtins.readFile ./config.org);
  orgModeConfigFile = pkgs.runCommand defaultInitFileName { nativeBuildInputs = [ package ]; } ''
    cp ${configFile} config.org
    emacs -Q --batch ./config.org -f org-babel-tangle
    mv config.el $out
  '';
in
(pkgs.emacsPackagesFor package).emacsWithPackages packages
