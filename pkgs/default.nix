final: prev: {
  cljstyle = final.callPackage ./cljstyle {};
  pharo12-stable = final.callPackage ./pharo12-stable.nix {};
  love-darwin-bin = final.callPackage ./love-darwin-bin.nix {};
}
