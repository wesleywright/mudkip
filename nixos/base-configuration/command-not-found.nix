{
  pkgs,
  ...
}:

{
  # Disable the default command-not-found, since it doesn't work with flakes.
  #
  # Instead, we'll integrate nix-index in our Fish configuration.
  programs.command-not-found.enable = false;
}
