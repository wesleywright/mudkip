{ ... }:

{
  hardware.pulseaudio.enable = true;
  services.pipewire.enable = false;
  users.users.naptime.extraGroups = [ "audio" ];
}
