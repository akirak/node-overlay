{
  description = "Minimal flake project";

  inputs = {
    nixpkgs.url = "github:NixOS/nixpkgs/master";
    node2nix = {
      url = "github:svanderburg/node2nix";
      # url = "github:akirak/node2nix/nodejs-18";
      flake = false;
    };
    # pnpm = {
    #   url = "github:pnpm/pnpm";
    #   flake = false;
    # };
  };

  outputs = {
    self,
      nixpkgs,
      flake-utils,
      ...
  } @ inputs:
    let
      makeOverlay = import ./overlay.nix inputs;
    in
      {
        overlays.node-18 = makeOverlay "node-18";
      }
      //
      flake-utils.lib.eachDefaultSystem
        (system: let
          pkgs = import nixpkgs {
            inherit system;
          };

          node2nix = (import inputs.node2nix {
            inherit pkgs system;
          }).package;

          makeUpdater = directory: flag: pkgs.writeShellScript "run-node2nix" ''
            set -euo pipefail
            cd "${directory}"
            ${node2nix}/bin/node2nix -i node-packages.json ${flag}
          '';
        in {
          apps.update-node18 = {
            type = "app";
            program = "${makeUpdater "node-18" "-18"}";
          };
        });
}
