final: prev: {
  psyclyx.scripts.generate-host-keys = final.callPackage ./psyclyx/scripts/generate-host-keys {};
  cljstyle = final.callPackage ./cljstyle {};
  pharo12-stable = final.callPackage ./pharo12-stable.nix {};
  love-darwin-bin = final.callPackage ./love-darwin-bin.nix {};
}
