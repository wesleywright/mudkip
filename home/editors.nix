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
      au BufNewFile,BufRead *.py set tabstop=4 softtabstop=4 shiftwidth=4 expandtab smarttab autoindent
      au BufNewFile,BufRead *.rs set tabstop=4 softtabstop=4 shiftwidth=4 expandtab smarttab autoindent
      au BufNewFile,BufRead *.nix set tabstop=2 softtabstop=2 shiftwidth=2 expandtab smarttab autoindent
      au BufNewFile,BufRead *.ml set tabstop=2 softtabstop=2 shiftwidth=2 expandtab smarttab autoindent

      set ruler
      set number

      set listchars=tab:␉·,trail:·,extends:>,precedes:<
      set list
    '';
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
