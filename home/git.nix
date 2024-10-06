{ pkgs, ... }:

{
  programs.git = {
    enable = true;
    extraConfig = {
      init = {
        defaultBranch = "main";
      };
    };
    userEmail = "wesley@wesleywright.me";
    userName = "Wesley Wright";
  };
}
