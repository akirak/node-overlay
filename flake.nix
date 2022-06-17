{
  description = "Minimal flake project";

  inputs = {
    node2nix = {
      url = "github:svanderburg/node2nix";
      flake = false;
    };
  };

  outputs = {
    self,
      nixpkgs,
      flake-utils,
      ...
  } @ inputs:
    let
      overlay = import ./overlay.nix inputs;
    in
      {
        overlays.default = overlay;
      }
      //
      flake-utils.lib.eachDefaultSystem
        (system: let
          pkgs = import nixpkgs {
            inherit system;
            overlays = [
              overlay
            ];
          };
        in {
          packages = flake-utils.lib.flattenTree {
            inherit (pkgs.nodePackages) node2nix;
          };

          # devShells.default = pkgs.mkShell {
          #   buildInputs = [
          #   ];
          # };
        });
}
