{
  pkgs,
  buildFirefoxXpiAddon,
}: let
  addons = pkgs.nur.repos.rycee.firefox-addons;
  sci-hub = buildFirefoxXpiAddon rec {
    pname = "sci_hub_addon";
    addonId = "{6031c27b-5ae2-4449-a7fd-ac7feabb4ef3}";
    version = "1.4.1";
    url = "https://addons.mozilla.org/firefox/downloads/file/4055458/${pname}-${version}.xpi";
    sha256 = "sha256-VrSX1G8HWrzXTS7eWauXKOb6FIJqhdWtnaqitlPdMTg=";
    meta = with pkgs.lib; {
      homepage = "https://addons.mozilla.org/en-US/firefox/addon/sci-hub-addon";
      description = "Access scientific papers via Sci-Hub with a click of a button";
      license = licenses.mpl20;
      platforms = platforms.all;
    };
  };
in
  with addons; [
    i-dont-care-about-cookies
    link-cleaner
    privacy-badger
    sidebery
    ublock-origin
  ]
