{ ... }:

{
  programs.plasma.startup.startupScript = {
    # Start 1Password in the system tray on login. This will allow features
    # like browser and SSH integration to automatically trigger the initial
    # unlock prompt without having to manually open 1Password and *without*
    # prompting for unlock at login.
    "1password" = {
      text = "1password --silent";
    };
  };
}
