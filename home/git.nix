{ pkgs, ... }:

{
  programs.git = {
    enable = true;
    userEmail = "wesley@wesleywright.me";
    userName = "Wesley Wright";
  };
}
