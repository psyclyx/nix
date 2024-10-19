{
  inputs,
  buildFirefoxXpiAddon,
  ...
}: {
  home-manager = {
    useGlobalPkgs = true;
    useUserPackages = true;
    extraSpecialArgs = {inherit inputs;};
  };
}
