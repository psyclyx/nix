{
  inputs,
  pkgs,
}: let
  addons = pkgs.nur.repos.rycee.firefox-addons;
  inherit (inputs.rycee-nurpkgs.lib.${pkgs.system}) buildFirefoxXpiAddon;
in
  with addons; [
    i-dont-care-about-cookies
    link-cleaner
    privacy-badger
    sidebery
    ublock-origin
  ]
