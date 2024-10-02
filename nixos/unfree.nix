{ lib, ... }:

{
  nixpkgs.config.allowUnfreePredicate =
    pkg:
    builtins.elem (lib.getName pkg) [
      "1password"
      "1password-cli"
      "input-fonts"
      "steam"
      "steam-original"
      "steam-run"
    ];
}
