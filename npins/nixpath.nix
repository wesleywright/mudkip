let
  sources = import ./.;

  sourcesWithConfiguration = sources // {
    nixos-config = builtins.toString ../nixos/configuration.nix;
  };
  mapped = builtins.mapAttrs (name: path: "${name}=${path}") sourcesWithConfiguration;
  strings = builtins.attrValues mapped;
in
builtins.concatStringsSep ":" strings
