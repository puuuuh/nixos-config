{
  description = "Home Manager NixOS configuration";

  inputs = {
    nixpkgs.url = "github:nixos/nixpkgs/nixos-21.11";
    nixpkgs-unstable.url = "github:NixOS/nixpkgs/nixos-unstable";
    home-manager.url = "github:nix-community/home-manager/release-21.11";
    home-manager.inputs.nixpkgs.follows = "nixpkgs";
    overlay-emacs.url = "github:nix-community/emacs-overlay";
  };

  outputs = inputs@{ self, nixpkgs, nixpkgs-unstable, overlay-emacs, home-manager, ... }:
    {
      homeConfigurations = {
        puh = inputs.home-manager.lib.homeManagerConfiguration {
          system = "x86_64-linux";
          homeDirectory = "/home/puh";
          username = "puh";
          stateVersion = "21.11";
          configuration = { config, pkgs, ... }:
            let
              overlay-unstable = final: prev: {
                unstable = inputs.nixpkgs-unstable.legacyPackages.x86_64-linux;
              };
            in
            {
              nixpkgs.overlays = [ overlay-unstable overlay-emacs.overlay ];
              nixpkgs.config = {
                allowUnfree = true;
                allowBroken = true;
              };

              imports = [
                ./users/puh/home.nix
              ];
            };
        };
      };
          puh = self.homeConfigurations.puh.activationPackage;
          defaultPackage.x86_64-linux = self.puh;
    };
}
