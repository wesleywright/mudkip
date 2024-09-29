{ config, pkgs, ... }:

{
  home = {
    username = "naptime";
    homeDirectory = "/home/naptime";

    # Specifies API compatibility version, do not change on Home Manager upgrade
    stateVersion = "24.05";

    packages = [
      # # You can also create simple shell scripts directly inside your
      # # configuration. For example, this adds a command 'my-hello' to your
      # # environment:
      # (pkgs.writeShellScriptBin "my-hello" ''
      #   echo "Hello, ${config.home.username}!"
      # '')

      pkgs.python3
      pkgs.xivlauncher
    ];
  };

  nixpkgs.config.allowUnfreePredicate = pkg:
    builtins.elem (pkgs.lib.getName pkg) [
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
