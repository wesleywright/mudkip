{ config, pkgs, ... }:

let
  xivlauncher-1p = pkgs.writeShellApplication {
    name = "xivlauncher-1p";
    # NOTE: do NOT specify `op` here; we need to depend on the global install from NixOS,
    # as the bare package doesn't seem to integrate with polkit correctly AFAICT
    runtimeInputs = [
      pkgs.curl
      pkgs.xivlauncher
    ];
    text = ''
      function fetchOTP {
        op item get --otp MogStation
      }

      function sendRequest {
        curl http://localhost:4646/ffxivlauncher/"''${1:-}"
      }

      function passOTPOnce {
        while ! sendRequest 2>/dev/null; do
          sleep 0.5
        done
        sendRequest "$(fetchOTP)"
      }

      passOTPOnce &
      XIVLauncher.Core "$@"
    '';
  };
  xivlauncher-1p-desktop = pkgs.makeDesktopItem {
    name = "xivlauncher-1p-desktop";
    desktopName = "Final Fantasy XIV (1Password)";
    exec = "${xivlauncher-1p}/bin/xivlauncher-1p";
  };
in {
  home = {
    username = "naptime";
    homeDirectory = "/home/naptime";

    # Specifies API compatibility version, do not change on Home Manager upgrade
    stateVersion = "24.05";

    packages = [
      pkgs.python3
      pkgs.xivlauncher

      xivlauncher-1p
      xivlauncher-1p-desktop
    ];
  };

  nixpkgs.config.allowUnfreePredicate = pkg:
    builtins.elem (pkgs.lib.getName pkg) [
      "1password-cli"
      "steam"
      "steam-run"
      "steam-original"
      "xivlauncher"
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

    fish.enable = true;

    git = {
      enable = true;
      userEmail = "wesley@wesleywright.me";
      userName = "Wesley Wright";
    };

    neovim = {
      defaultEditor = true;
      enable = true;
      viAlias = true;
      vimAlias = true;
      extraConfig = ''
        filetype plugin indent on
        syntax on
        au BufNewFile,BufRead *.py set tabstop=4 softtabstop=4 shiftwidth=4 expandtab smarttab autoindent
        au BufNewFile,BufRead *.nix set tabstop=2 softtabstop=2 shiftwidth=2 expandtab smarttab autoindent

        set ruler
        set number
      '';
    };
  };
}
