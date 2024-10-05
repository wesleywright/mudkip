{ ... }:

let
  profileName = "naptime's konsole profile :-)";
in
{
  programs.konsole = {
    enable = true;

    extraConfig = {
      KonsoleWindow = {
        ShowMenuBarByDefault = false;
      };
    };

    defaultProfile = profileName;
    profiles = {
      ${profileName} = {
        colorScheme = "Solarized";
        extraConfig = {
          General = {
            TerminalMargin = 0;
          };
          Scrolling = {
            HistoryMode = 2;
          };
        };
        font = {
          name = "Input Mono";
          size = 11;
        };
      };
    };
  };
}
