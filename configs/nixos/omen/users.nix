{ inputs, pkgs, ... }:
{
  nix.settings.trusted-users = [ "psyc" ];
  users = {
    users = {
      psyc = {
        name = "psyc";
        home = "/home/psyc";
        shell = pkgs.zsh;
        isNormalUser = true;
        extraGroups = [
          "wheel"
          "video"
          "builders"
        ];
        openssh.authorizedKeys.keys = [
          "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIEwUKqMso49edYpzalH/BFfNlwmLDmcUaT00USWiMoFO me@psyclyx.xyz"
        ];
      };
    };
  };

  home-manager = {
    users = {
      psyc = {
        imports = [
          inputs.sops-nix.homeManagerModules.sops
          inputs.hyprland.homeManagerModules.default
          inputs.self.homeManagerModules.default
          ../../home/psyc.nix
          ../../../modules/home/programs/emacs
          ../../home/desktop.nix
        ];
        programs.emacs.enable = true;
        services.emacs.enable = true;
        psyclyx = {
          gtk.enable = false;
          programs = {
            hyprland = {
              enable = true;
            };
          };
        };
      };
    };
  };
}
