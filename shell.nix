let
  sources = import ./npins;
  nixpkgs = import sources.nixpkgs { };
in
{
  pkgs ? nixpkgs,
}:

pkgs.mkShell {
  packages = [
    pkgs.npins
    pkgs.nixfmt-rfc-style
  ];
  NIX_PATH =
    let
      sourcesWithConfiguration = {
        inherit sources;
        nixos-config = builtins.toString ./nixos/configuration.nix;
      };
      mapped = builtins.mapAttrs (name: path: "${name}=${path}") sources;
      strings = builtins.attrValues mapped;
    in
    builtins.concatStringsSep ":" strings;
}
