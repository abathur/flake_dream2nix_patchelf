{
  description = "My flake with dream2nix packages";

  inputs = {
    dream2nix.url = "github:nix-community/dream2nix";
    nixpkgs.follows = "dream2nix/nixpkgs";
    systems.url = "github:nix-systems/default";
    flake-parts.url = "github:hercules-ci/flake-parts";
    flake-compat = {
      url = "github:edolstra/flake-compat";
      flake = false;
    };
  };
  outputs = inputs @ {
    self,
    dream2nix,
    nixpkgs,
    systems,
    flake-parts,
    ...
  }:
  flake-parts.lib.mkFlake {inherit inputs;} {
    systems = (import systems);
    perSystem = {
      pkgs,
      system,
      ...
    }: rec {
      packages.SIGH = dream2nix.lib.evalModules {
        packageSets.nixpkgs = inputs.dream2nix.inputs.nixpkgs.legacyPackages.${system};
        modules = [
          ./default.nix
          {
            paths.projectRoot = self;
            paths.projectRootFile = "flake.nix";
            paths.lockFile = "lock.json";
            paths.package = self;
          }
        ];
      };
    };
  };
}
