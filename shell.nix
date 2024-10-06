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

  HOME_MANAGER_CONFIG = builtins.toString ./home/home.nix;
  NIX_PATH =
    let
      sourcesWithConfiguration = sources // {
        nixos-config = builtins.toString ./nixos/configuration.nix;
      };
      mapped = builtins.mapAttrs (name: path: "${name}=${path}") sourcesWithConfiguration;
      strings = builtins.attrValues mapped;
    in
    builtins.concatStringsSep ":" strings;
}
