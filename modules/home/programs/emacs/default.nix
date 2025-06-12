{
  config,
  lib,
  pkgs,
  inputs,
  ...
}:
let
  packageConfig = import ./packages.nix;
  packages = packageConfig.systemPackages pkgs;
  emacs = with pkgs; if stdenv.isDarwin then emacs-30 else emacs-unstable-pgtk;
in
lib.mkMerge [
  {
    programs = {
      emacs = {
        enable = lib.mkDefault true;
        package = lib.mkDefault emacs;
        extraPackages = epkgs: (packageConfig.emacsPackages epkgs) ++ packages;
      };
    };

    home = lib.mkIf config.programs.emacs.enable {
      packages = packages;
      file.".config/emacs/config.org".source = ./config.org;
      file.".config/emacs/init.el".source = ./init.el;
    };
  }

  (lib.mkIf (pkgs.stdenv.isDarwin && config.programs.emacs.enable) {
    targets.darwin.defaults."org.gnu.Emacs".AppleFontSmoothing = 0;
  })
]
