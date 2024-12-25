{ lib, ... }:

{
  nixpkgs.config.allowUnfreePredicate =
    pkg:
    builtins.elem (lib.getName pkg) [
      "1password"
      "1password-cli"
      "input-fonts"
      "keymapp"
      "steam"
      "steam-original"
      "steam-run"
      "steam-unwrapped"
      "wally-cli"
    ];
}
