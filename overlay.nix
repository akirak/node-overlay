inputs:
final: prev: {

  nodePackages = prev.nodePackages // {
    node2nix = prev.nodePackages.node2nix.override {
      src = inputs.node2nix;
    };
  };

}
