inputs:
final: prev:
let
  nodePackages = import (inputs.self.outPath + "/default.nix") {
    pkgs = prev;
    inherit (prev) system;
  };
in
{
  nodePackages = prev.nodePackages // nodePackages // {
    node2nix = prev.nodePackages.node2nix.override {
      src = inputs.node2nix;
    };

    pnpm = nodePackages.pnpm.override {
      nativeBuildInputs = [
        prev.makeWrapper
      ];

      postInstall = ''
        mkdir -p $out/bin
        makeWrapper "$out/lib/node_modules/pnpm/bin/pnpm.cjs" "$out/bin/pnpm"
        makeWrapper "$out/lib/node_modules/pnpm/bin/pnpx.cjs" "$out/bin/pnpx"
      '';
    };
  };
}
