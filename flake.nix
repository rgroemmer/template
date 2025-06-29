{
  description = "Temp late☕";

  inputs = {
    nixpkgs.url = "github:NixOS/nixpkgs/nixos-unstable";

    pre-commit-hooks = {
      url = "github:cachix/pre-commit-hooks.nix";
      inputs.nixpkgs.follows = "nixpkgs";
    };
  };

  outputs = {
    nixpkgs,
    pre-commit-hooks,
    ...
  }: let
    inherit (nixpkgs) lib;

    systems = ["aarch64-linux" "x86_64-linux"];
    pkgsFor = lib.genAttrs systems (system: import nixpkgs {inherit system;});
    forAllSystems = f: lib.genAttrs systems (system: f pkgsFor.${system});
  in {
    inherit lib;

    formatter = forAllSystems (pkgs: pkgs.alejandra);
    devShells = forAllSystems (pkgs: import ./dev-shells.nix {inherit pkgs pre-commit-hooks;});
    packages = {};
  };
}
