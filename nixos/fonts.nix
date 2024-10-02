{ pkgs, ... }:

{
  fonts = {
    packages = [ pkgs.input-fonts ];
  };

  nixpkgs.config.input-fonts.acceptLicense = true;
}
