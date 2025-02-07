{
  config,
  lib,
  pkgs,
  inputs,
  ...
}: let
  repoSymlink = false; # will eventually be argument
  relPath = lib.strings.removePrefix (toString inputs.self);
  repoPath = f: "${config.home.homeDirectory}/projects/nix" + relPath f;
  mkRepoFile = file: fallback:
    if repoSymlink
    then config.lib.file.mkOutOfStoreSymlink (repoPath file)
    else fallback;

  packageConfig = import ./packages.nix;
  packages = packageConfig.systemPackages pkgs;
  emacs =
    if pkgs.stdenv.isDarwin
    then pkgs.emacs-30
    else pkgs.emacs30-pgtk;
  emacsclient = pkgs.stdenv.mkDerivation {
    pname = "emacsclient";
    version = emacs.version;
    phases = ["installPhase"];
    installPhase = ''
         mkdir -p $out/bin
      cp ${emacs}/bin/emacsclient $out/bin/
    '';
  };
in
  lib.mkMerge [
    {
      programs.emacs = {
        enable = true;
        package = emacs;
        extraPackages = epkgs:
          (packageConfig.emacsPackages epkgs) ++ packages ++ [emacsclient];
      };
      home = {
        file = {
          ".config/emacs/init.el".source = mkRepoFile ./init.el ./init.el;
          ".config/emacs/config.org".source = mkRepoFile ./config.org ./config.org;
        };
        packages = packages;
      };
    }

    (lib.mkIf pkgs.stdenv.isDarwin {
      targets.darwin.defaults."org.gnu.Emacs".AppleFontSmoothing = 0;
    })
  ]
