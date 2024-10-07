let
  sources = import ./npins;
  nixpath = import ./npins/nixpath.nix;
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
  NIX_PATH = nixpath;
}
