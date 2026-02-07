{ pkgs, ... }:

{
  programs.neovim = {
    defaultEditor = true;
    enable = true;
    viAlias = true;
    vimAlias = true;
    extraConfig = ''
      filetype plugin indent on

      syntax on
      set background=dark
      colorscheme solarized8

      au BufNewFile,BufRead *.py set tabstop=4 softtabstop=4 shiftwidth=4 expandtab smarttab autoindent
      au BufNewFile,BufRead *.rs set tabstop=4 softtabstop=4 shiftwidth=4 expandtab smarttab autoindent
      au BufNewFile,BufRead *.nix set tabstop=2 softtabstop=2 shiftwidth=2 expandtab smarttab autoindent
      au BufNewFile,BufRead *.ml set tabstop=2 softtabstop=2 shiftwidth=2 expandtab smarttab autoindent

      set ruler
      set number

      set listchars=tab:␉·,trail:·,extends:>,precedes:<
      set list
    '';

    plugins = with pkgs.vimPlugins; [
      # Integrates direnv from any project directories so that neovim can use the correct
      # environment configuration.
      direnv-vim

      # This plugin adds a lot of fancy features, but I'm mostly interested in the gutter bar
      # features (it shows added and removed lines) and status line integration.
      gitsigns-nvim

      # This is the best-looking Solarized theme I have found that works with neovim as of Feb 2026.
      vim-solarized8
    ];
  };

  programs.vscode = {
    enable = true;

    # Similarly to update checks, let's try managing extensions solely through
    # nix
    mutableExtensionsDir = false;

    profiles.default = {
      # For now, let's turn this off and see how well updates can be managed via
      # Nix
      enableExtensionUpdateCheck = false;
      enableUpdateCheck = false;

      extensions = [
        pkgs.vscode-extensions.mkhl.direnv
        pkgs.vscode-extensions.rust-lang.rust-analyzer
        pkgs.vscode-extensions.vscodevim.vim
      ];

      userSettings = {
        files = {
          autoSave = "onFocusChange";
        };

        editor = {
          formatOnSave = true;
          #formatOnSaveMode = "modificationsIfAvailable";

          inlayHints.enabled = "off";

          renderWhitespace = "boundary";
          rulers = [ 80 ];
          scrollBeyondLastLine = false;
        };

        explorer = {
          excludeGitIgnore = true;
        };

        rust-analyzer = {
          server.path = "rust-analyzer";
        };
        window = {
          menuBarVisibility = "compact";
          titleBarStyle = "custom";
        };
        workbench.colorTheme = "Solarized Light";

        "[rust]" = {
          editor.rulers = [ 100 ];
        };
      };
    };

  };
}
