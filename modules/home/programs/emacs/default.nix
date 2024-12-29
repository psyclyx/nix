{
  config,
  lib,
  pkgs,
  inputs,
  ...
}: let
  packageConfig = import ./packages.nix;
  packages = packageConfig.systemPackages pkgs;
  relPath = lib.strings.removePrefix (toString inputs.self) (toString ./config);
  configPath = "${config.home.homeDirectory}/projects/nix" + relPath;
in {
  programs.emacs = {
    enable = true;
    package =
      if pkgs.stdenv.isDarwin
      then pkgs.emacs-30
      else pkgs.emacs-git;
    extraPackages = epkgs:
      (packageConfig.emacsPackages epkgs) ++ packages;
  };
  home.file.".config/emacs".source = config.lib.file.mkOutOfStoreSymlink configPath;
}
