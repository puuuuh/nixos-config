{
  description = "Home Manager NixOS configuration";

  inputs = {
    nixpkgs.url = "github:nixos/nixpkgs/nixos-21.11";
    nixpkgs-unstable.url = "github:NixOS/nixpkgs/nixos-unstable";
    home-manager.url = "github:nix-community/home-manager/release-21.11";
    home-manager.inputs.nixpkgs.follows = "nixpkgs";
    overlay-emacs.url = "github:nix-community/emacs-overlay";
    flake-utils.url = "github:numtide/flake-utils";
  };


  outputs = inputs@{ self, nixpkgs, nixpkgs-unstable, overlay-emacs, home-manager, flake-utils, ... }:
  let shared = flake-utils.lib.eachDefaultSystem (system:
  let pkgs = nixpkgs.legacyPackages.${system}; in
  rec {
    devShell = pkgs.mkShell {
      buildInputs = with pkgs; [ rnix-lsp sumneko-lua-language-server ];
    };
  });
  in
  {
    nixosConfigurations = {
      poplar = inputs.nixpkgs.lib.nixosSystem rec {
        system = "x86_64-linux";

        modules = [
          ./machine/configuration.nix
          home-manager.nixosModules.home-manager 
          {
            home-manager.useGlobalPkgs = true;
            home-manager.useUserPackages = true;
            home-manager.extraSpecialArgs = { unstable = nixpkgs-unstable.legacyPackages.${system}; };
            home-manager.users.puh = import ./users/puh/home.nix;
          }
        ];
        specialArgs = { unstable = nixpkgs-unstable.legacyPackages.${system}; };
      };
      poplar-pc = inputs.nixpkgs.lib.nixosSystem rec {
        system = "x86_64-linux";

        modules = [
          ./machine/pc/configuration.nix
          home-manager.nixosModules.home-manager 
          {
            home-manager.useGlobalPkgs = true;
            home-manager.useUserPackages = true;
            home-manager.extraSpecialArgs = { unstable = nixpkgs-unstable.legacyPackages.${system}; };
            home-manager.users.puh = import ./users/puh/home.nix;
          }
        ];
        specialArgs = { unstable = nixpkgs-unstable.legacyPackages.${system}; };
      };
    };

    templates.rust = {
      path = ./templates/rust;
      description = "A simple Rust project with fenix";
    };

    devShell = shared.devShell;
  };
}
