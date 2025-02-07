{
  config,
  lib,
  pkgs,
  inputs,
  ...
}: let
  useSymlinkConfig = false;
  packageConfig = import ./packages.nix;
  packages = packageConfig.systemPackages pkgs;
  relPath = lib.strings.removePrefix (toString inputs.self) (toString ./config);
  configPath = "${config.home.homeDirectory}/projects/nix" + relPath;
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
        file.".config/emacs".source =
          if useSymlinkConfig
          then config.lib.file.mkOutOfStoreSymlink configPath
          else ./config;

        packages = packages;
      };
    }

    (lib.mkIf pkgs.stdenv.isDarwin {
      targets.darwin.defaults."org.gnu.Emacs".AppleFontSmoothing = 0;
    })
  ]
