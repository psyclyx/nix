{ config, pkgs, ...}:

{
  imports = [ ../link-apps ];

  system.build.applications = pkgs.lib.mkForce (pkgs.buildEnv {
    name = "applications";
    paths = config.environment.systemPackages ++ config.home-manager.users.psyc.home.packages;
    pathsToLink = "/Applications";
  });
}
