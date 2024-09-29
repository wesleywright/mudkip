{ config, pkgs, ... }:

{
  imports = [
    ./ffxiv.nix
    ./fish.nix
    ./git.nix
    ./neovim.nix
    ./ssh.nix
  ];

  home = {
    username = "naptime";
    homeDirectory = "/home/naptime";

    # Specifies API compatibility version, do not change on Home Manager upgrade
    stateVersion = "24.05";

    packages = [
      pkgs.python3
    ];
  };

  nixpkgs.config.allowUnfreePredicate = pkg:
    builtins.elem (pkgs.lib.getName pkg) [
      "steam"
      "steam-run"
      "steam-original"
    ];

  programs = {
    # Let Home Manager install and manage itself.
    home-manager.enable = true;
  
    bash = {
      enable = true;
      initExtra = ''
        if [[ $(${pkgs.procps}/bin/ps --no-header --pid=$PPID --format=comm) != "fish" && -z ''${BASH_EXECUTION_STRING} ]]
        then
          shopt -q login_shell && LOGIN_OPTION='--login' || LOGIN_OPTION=""
          exec ${pkgs.fish}/bin/fish $LOGIN_OPTION
        fi
      '';
    };

    firefox.enable = true;
  };
}
