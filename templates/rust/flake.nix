{
  inputs = {
    naersk.url = "github:nmattia/naersk/master";
    nixpkgs.url = "github:NixOS/nixpkgs/nixpkgs-unstable";
    utils.url = "github:numtide/flake-utils";
    fenix = {
      url = "github:nix-community/fenix";
      inputs.nixpkgs.follows = "nixpkgs";
    };
  };

  outputs = { self, nixpkgs, utils, naersk, fenix }:
    utils.lib.eachDefaultSystem (system:
      let
        overlays = [ fenix.overlay ];
        pkgs = import nixpkgs { inherit system overlays; };
        toolchain = fenix.packages.${system}.fromToolchainFile {
            file = ./rust-toolchain.toml;
            sha256 = "sha256-D9A5EDbiC6jvAdSgjRVYV7rCXELA1r2VPTRl6978J5w=";
        };
        naersk-lib = pkgs.callPackage naersk {}; 
      in {
        defaultPackage = naersk-lib.buildPackage ./.;

        defaultApp = utils.lib.mkApp {
          drv = self.defaultPackage."${system}";
        };

        devShell = with pkgs; mkShell {
          buildInputs = [ toolchain rust-analyzer-nightly mold clang ];
        };

      });

}
