{config, ...}: {
  sops = {
    age.keyFile = config.xdg.configFile."sops/age/keys.txt";
  };
}
