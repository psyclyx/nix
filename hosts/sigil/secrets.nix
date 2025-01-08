{config, ...}: {
  sops.secrets."wg-mullvad.conf" = {
    format = "binary";
    sopsFile = ./wg-mullvad.conf.enc;
  };
}
