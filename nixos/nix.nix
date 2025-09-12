{ inputs, ... }:

{
  nix = {
    gc = {
      automatic = true;
      options = "--delete-older-than 60d";
    };

    nixPath = [ "nixpkgs=${inputs.nixpkgs}" ];

    settings = {
      experimental-features = [
        "nix-command"
        "flakes"
      ];
    };
  };
}
