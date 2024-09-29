{ ... }:

{
  hardware.pulseaudio.enable = true;
  users.users.naptime.extraGroups = ["audio"];
}
