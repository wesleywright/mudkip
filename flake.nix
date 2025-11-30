{
  description = "mudkip system configuration files";

  inputs = {
    nixpkgs.url = "github:nixos/nixpkgs/nixos-25.11";
    home-manager = {
      url = "github:nix-community/home-manager/release-25.11";
      inputs.nixpkgs.follows = "nixpkgs";
    };
    plasma-manager = {
      url = "github:nix-community/plasma-manager/trunk";
      inputs.nixpkgs.follows = "nixpkgs";
      inputs.home-manager.follows = "home-manager";
    };
  };

  outputs =
    inputs@{
      nixpkgs,
      home-manager,
      plasma-manager,
      ...
    }:
    let
      system = "x86_64-linux";
      pkgs = import nixpkgs { inherit system; };
    in
    {
      devShell.${system} = pkgs.mkShell {
        packages = [
          pkgs.nixfmt-rfc-style
        ];
      };

      homeConfigurations."naptime" = home-manager.lib.homeManagerConfiguration {
        inherit pkgs;

        modules = [
          plasma-manager.homeModules.plasma-manager

          ./home/home.nix
        ];
      };

      nixosConfigurations.mudkip = nixpkgs.lib.nixosSystem {
        specialArgs = {
          inherit inputs;
        };

        modules = [
          ./nixos/configuration.nix
        ];
      };
    };
}
