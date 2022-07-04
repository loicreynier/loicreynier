{
  description = "GitHub profile page";

  inputs = {
    flake-utils = {
      url = "github:numtide/flake-utils";
    };

    nixpkgs.url = "github:NixOS/nixpkgs/nixos-unstable";

    pre-commit-hooks = {
      url = "github:cachix/pre-commit-hooks.nix";
      inputs.nixpkgs.follows = "nixpkgs";
      inputs.flake-utils.follows = "flake-utils";
    };
  };

  outputs = {
    self,
    flake-utils,
    pre-commit-hooks,
    nixpkgs,
  }: let
    supportedSystems = ["x86_64-linux"];
  in (flake-utils.lib.eachSystem supportedSystems (system: let
    pkgs = import nixpkgs {inherit system;};
  in rec {
    checks = {
      pre-commit-check = pre-commit-hooks.lib.${system}.run {
        src = ./.;
        hooks = with pkgs; {
          prettier.enable = true;
        };
      };
    };
  }));
}
