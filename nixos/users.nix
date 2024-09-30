{ ... }:

{
  # Disable root login.
  users.extraUsers.root.hashedPassword = "*";

  users.users.naptime = {
    isNormalUser = true;
    extraGroups = [ "wheel" ];
  };
}
