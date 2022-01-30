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
        stable = fenix.packages.${system}.toolchainOf {
          channel = "nightly";
          sha256 = "12c99ccd4b538885505bb48e36bd30351348d5a125c2b1172382a953a8dfebc7";
        };
        toolchain = with fenix.packages.${system};
          combine [
            stable.rustc
            stable.cargo
            stable.rust-src
            stable.clippy
            stable.rustfmt
          ];
        naersk-lib = pkgs.callPackage naersk {}; 
      in {
        defaultPackage = naersk-lib.buildPackage ./.;

        defaultApp = utils.lib.mkApp {
          drv = self.defaultPackage."${system}";
        };

        devShell = with pkgs; mkShell {
          buildInputs = [ toolchain rust-analyzer-nightly cmake clang llvmPackages.libclang pkgconfig sqlx-cli protobuf openssl ];
        };

      });

}
