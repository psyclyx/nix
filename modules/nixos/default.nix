{
  inputs,
  overlays,
}: {
  hostName,
  hostPlatform,
  modules ? [],
  ...
} @ args: let
  inherit (inputs) nixpkgs home-manager;
in
  nixpkgs.lib.nixosSystem {
    modules =
      [
        {
          networking.hostName = hostName;
          nixpkgs = {
            inherit overlays hostPlatform;
            config.allowUnfree = true;
	    config.nvidia.acceptLicense = true;
          };
        }
        home-manager.nixosModules.home-manager
      ]
      ++ modules;

    specialArgs = {inherit inputs;} // args;
  }
