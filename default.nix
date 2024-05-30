{
  config,
  lib,
  dream2nix,
  pkgs,
  dev,
  pg_current,
  ...
}: let
  buildWithSetuptools = {
    buildPythonPackage.format = "pyproject";
  };
in {
  imports = [
    dream2nix.modules.dream2nix.pip
    buildWithSetuptools
  ];

  deps = {nixpkgs, ...}: {
    python = nixpkgs.python39;
    inherit (nixpkgs.python3Packages) pip;
  };

  name = "sigh";
  version = "unversioned";

  mkDerivation.src = lib.concatStringsSep "/" [
    config.paths.projectRoot
  ];

  env.dontAutoPatchelf = true;

  pip = {
    pypiSnapshotDate = "2024-05-28";

    requirementsList = [
      "Flask==2.3.2"
      "setuptools"
    ];

    # Set `pip.flattenDependencies` to true to use all dependencies for the top-level package.
    # Since the hub isn't a proper package itself, we need this to avoid:
    # error: Top-level package $name is not listed in the lockfile.
    flattenDependencies = true;
  };
}
