{
  inputs,
  overlays ? [],
}: {
  hostName,
  hostPlatform,
  modules ? [],
  ...
} @ args: let
  inherit (inputs) nixpkgs home-manager;

  defaultModules = [
    {
      networking.hostName = hostName;
      nixpkgs = {
        inherit overlays hostPlatform;
        config.allowUnfree = true;
      };
    }
    home-manager.nixosModules.home-manager
    ./common.nix
  ];
in
  nixpkgs.lib.nixosSystem {
    modules = defaultModules ++ modules;

    specialArgs = {inherit inputs;} // args;
  }
  
