{ ... }:

{
  users = {
    users.naptime = {
      isNormalUser = true;
      extraGroups = [ "wheel" ];
    };
  };
}
