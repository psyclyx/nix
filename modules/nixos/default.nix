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
  inherit (inputs.rycee-nurpkgs.lib.${hostPlatform}) buildFirefoxXpiAddon;
in
  nixpkgs.lib.nixosSystem {
    modules =
      [
        {
          networking.hostName = hostName;
          nixpkgs = {
            inherit overlays hostPlatform;
            config.allowUnfree = true;
          };
        }
        home-manager.nixosModules.home-manager
        ./programs
        ./services
        ./system
      ]
      ++ modules;

    specialArgs = {inherit inputs buildFirefoxXpiAddon;} // args;
  }
